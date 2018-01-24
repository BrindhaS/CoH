trigger LucityCaseInsertion on Case (after Insert,before update) {
      Boolean flag = false;  
      System.debug('Hello Lucity case!!!!');
            for(Case c:Trigger.New) {
                   System.debug('Hello Lucity for loop!!!!'+ c.Lucity_Public_works__c );
                        if((c.Lucity_Public_works__c == TRUE || c.Lucity_Parks__c == TRUE) && (c.Disposition__c != 'Pending GIS Validation')&& (c.Location_Found_in_GIS__c == 'Found in GIS') && (CaseFieldUpdate.inLucityFutureContext == false)) {
                           System.debug('Conditions satisfied');
                           if(c.Lucity_Public_works__c == TRUE) 
                               flag=true;
                           else if(c.Lucity_Parks__c == TRUE)
                               flag=false;    
                           String num = c.CaseNumber; 
                           System.debug('Case Number'+num+'Flag'+flag);
                           if(c.Lucity_WR_ID__c == null) {                
                               InsertCaseInLucity obj = new InsertCaseInLucity(); 
                               CaseFieldUpdate.inLucityFutureContext = true;        
                               obj.callFuture(num,flag); 
                           }
        
                        }
            }
       


}