trigger CalculatesSLADateTime on Case (before insert, before update) 
{
    System.debug('CalculatesSLADateTime Trigger Entered');
    BusinessHours stdBusinessHours = [select id from businesshours where isDefault = true];
    integer sla = 0, d=0, we = 1;
    Datetime updateDate, startDate;
    for (Case c : Trigger.new) 
    {   
        System.debug('Case ID: '+ c.id + '  SLA: ' + c.SLA__c + '  Created Date: ' + c.CreatedDate);
        updateDate =System.now();
        sla = Integer.valueOf(c.SLA_Number__c);
        if((c.SLA_Type__c == 'Business Hours' || c.SLA_Type__c == 'Hours' )&& (c.CreatedDate != NULL) && (stdBusinessHours != NULL))
        {
            if(c.SLA_Type__c == 'Business Hours')    {        
                updateDate = BusinessHours.add (stdBusinessHours.id, c.CreatedDate, sla * 60 * 60 * 1000L);
                d = calculateHolidaysBetweenTwoDates(c.CreatedDate,updateDate);
               // updateDate = BusinessHours.add(stdBusinessHours.id, updateDate, d*10 * 60 * 60 * 1000L);
            }
            else {
               updateDate = c.CreatedDate.addHours(sla);
            }   
        }
        else if(c.SLA_Type__c == 'Business Days'&& (c.CreatedDate != NULL) && (stdBusinessHours != NULL))
        {
            if ((c.CreatedDate != NULL) && (stdBusinessHours != NULL)) 
            {
                //Working Hours is 7.30 hours / day (8:00 AM - 03:30 PM, M-F). 
                updateDate = c.CreatedDate.addDays(sla);                   
                System.debug('SLA Date after adding SLA: ' + updateDate);
                startDate = c.createdDate;        
                while(we != 0)    {
                    we = weekDayOfMonth(startDate ,updateDate);
                    System.debug('No of Weekends: ' + we );
                    startDate = updateDate;                    
                    updateDate = updateDate.addDays(we);
                    System.debug('Start Date: ' + startDate + '  End Date: ' + updateDate);
                }                                       
                System.debug('SLA Date after excluding weekdays: ' + updateDate);                 
                d = calculateHolidaysBetweenTwoDates(c.CreatedDate,updateDate);
                System.debug('Holidays: ' + d);
                updateDate = updateDate.addDays(d);  
                System.debug('SLA Date after adding Holidays: ' + updateDate);
                                       
            }
        }
        else if(c.SLA_Type__c == 'Days' && (c.CreatedDate != NULL) && (stdBusinessHours != NULL))   {
             System.debug('Days');           
             updateDate = c.CreatedDate.addDays(sla);
             System.debug('SLA Date after adding SLA: ' + updateDate);
        }
        if(c.SLA_Type__c != 'Days' && c.SLA_Type__c != 'Hours' && (c.CreatedDate != NULL) && (stdBusinessHours != NULL))    {
            String dayOfWeek = updateDate.format('E');        
            if(dayOfWeek == 'Sat' || dayOfWeek == 'Sun' ){
                    updateDate = updateDate.addDays(2);          
                     System.debug('SLA Date if it is weekend: ' + updateDate);
            }  
            updateDate = BusinessHours.add(stdBusinessHours.id, updateDate,  10L);                    
            System.debug('SLA Date in Working Hours: ' + updateDate);
        }      
        c.Sla_date__c = updateDate; 
        System.debug('SLA Date updated: ' + c.SLA_Date__c);
    }
    
    public integer calculateHolidaysBetweenTwoDates(Datetime date1,Datetime date2)
    {
        List<String> hDays = new List<String>();
        String year = String.valueOf(date1.year());
        integer month = date1.month();
        String day = String.valueOf(date1.day()); 
        integer numberOfHolidays=0;
        String mnth;
        integer d1,w;
        List<String> monthName = new List<String>{'null','January','February','March','April','May','June','July','August','September','October','November','December'};
        String newDate = year+'-'+ monthName.get(month) +'-'+day;
        List<Holiday> holi=[select RecurrenceInstance,RecurrenceDayOfWeekMask,RecurrenceMonthOfYear,RecurrenceDayOfMonth from Holiday];
        for(Holiday h : holi)
        {
            for(integer i=0 ; i< monthName.size();i++)
            {
                if(monthName.get(i).equals(h.RecurrenceMonthOfYear))
                   mnth = String.valueOf(i);
            }           
            if(h.RecurrenceDayOfMonth != null )
            {
                hDays.add(String.valueOf(date1.year())+'-'+h.RecurrenceMonthOfYear+'-'+ String.valueOf(h.RecurrenceDayOfMonth));
            }
            else 
            {
                if(h.RecurrenceInstance=='First')
                   w = 1;
                else if(h.RecurrenceInstance=='Second')
                   w = 2;
                else if(h.RecurrenceInstance=='Third')
                   w = 3;
                else if(h.RecurrenceInstance=='Fourth')
                   w = 4;         
                else
                   w = 5;  
                if(h.RecurrenceDayOfWeekMask == 2)
                    d1=0;
                else if(h.RecurrenceDayOfWeekMask == 4)
                    d1=1;    
                else if(h.RecurrenceDayOfWeekMask == 8)
                    d1=2;    
                else if(h.RecurrenceDayOfWeekMask == 16)
                    d1=3;    
                else if(h.RecurrenceDayOfWeekMask == 32)
                    d1=4;        
                else if(h.RecurrenceDayOfWeekMask == 64)
                    d1=5;    
                else
                    d1=6;    
                hDays.add(weekDayOfMonth(mnth,w,d1));
            }    
        }  integer z=0;
        integer w1 = date1.date().daysBetween(date2.date()) + 1;
        for(integer i = 0; i< w1;i++)
        {
             newDate = date1.format('YYYY-MMMM-d');
             for(integer j=0; j<hDays.size();j++)
             {
                if(hDays.get(j).trim().equals(newDate.trim()))
                {
                    numberOfHolidays++;
                    hDays.remove(j);
                }   
             }
             date1 = date1.addDays(1);    
        }
        return numberOfHolidays;
    }
    String weekDayOfMonth(String month, Integer week, Integer day) 
    {
        Datetime dt = date.valueOf('2013-'+month+'-01').addDays(1);
        String wee = dt.format('E');
        integer i , j,k;
        if(wee == 'Mon') 
         j = 0;
        else if(wee == 'Tue') 
         j = 1;
        else if(wee == 'Wed') 
         j = 2;
        else if(wee == 'Thu') 
         j = 3;
        else if(wee == 'Fri') 
         j = 4;
        else if(wee == 'Sat') 
         j = 5;    
        else
         j = 6;
        if(day<j)
           k = 7+ day-j;
        else
           k = day-j;  
        i = (week - 1)*7 + k; 
        dt = dt.addDays(i);
        return dt.format('YYYY-MMMM-d');
    }
    
    integer weekDayOfMonth(DateTime d1, DateTime d2) {
       System.debug('Starting Date: ' + d1);
       System.debug('Ending Date: ' + d2);
       integer noOfDays = d1.Date().daysBetween(d2.Date());
       System.debug('Days between the dates: ' + noOfDays );
       integer day = 0;
       while(noOfDays >0)    {
            d1 = d1.addDays(1);
            System.debug('Day for ' + d1 + ' : ' + d1.format('E'));
            if(d1.format('E') == 'Sat' || d1.format('E') == 'Sun')
                day++;
            noOfDays --;
       }
       System.debug('No of Weekends' + day);        
       return day;
   }
}