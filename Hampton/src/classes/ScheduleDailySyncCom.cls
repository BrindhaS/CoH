global class ScheduleDailySyncCom implements Schedulable {

    // Schedule Class for daily Sync 
    global void execute(SchedulableContext SC) {
        BatchSyncCom BS =  new BatchSyncCom();
        Database.executeBatch(BS,5); 
         ScheduleDailySyncCom obj = new ScheduleDailySyncCom ();
        DateTime temp = System.now().addMinutes(15);
        String day = string.valueOf(temp.day());
        String month = string.valueOf(temp.month());       
        String hour  = string.valueOf(temp.hour());  
        String minute = string.valueOf(temp.minute());  
        String second = string.valueOf(temp.second());
        String year = string.valueOf(temp.year());
    
        String strJobName = 'Job-' + second + '_' + minute + '_' + hour + '_' + day + '_' + month + '_' + year;
        String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year; 
        System.schedule(strJobName, strSchedule, obj);      
    }

}