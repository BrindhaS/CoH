trigger HandleLucityFieldUpdate on Case (after update)
 { 
   
     Case NewCase = trigger.new[0];
     Boolean flag = false;
     if((NewCase.Lucity_Returned_Date__c == null) && (NewCase.Lucity_WR_ID__c != null) &&  (NewCase.Lucity_public_works__c == TRUE || NewCase.Lucity_parks__c == TRUE)) {
         if(NewCase.Lucity_public_works__c == TRUE) flag=true;
         Case OldCase = trigger.old[0];
         Case CaseObject = new Case();
         // This takes all available fields from the required object.
         Schema.SObjectType objType = CaseObject.getSObjectType();
         Map<String, Schema.SObjectField> M = Schema.SObjectType.Case.fields.getMap();
         for (String str : M.keyset())  { 
         try 
         {
          System.debug('Field name: '+str +'. New value: ' + NewCase.get(str) +'. Old value: '+OldCase.get(str));
          if((NewCase.get(str) != OldCase.get(str)) && (str != 'lastmodifiedbyid') && (str != 'systemmodstamp') && (str != 'lastmodifieddate')&& (str != 'address_x__c') && (str != 'last_status_change__c') && (str != 'address_y__c') && (str != 'time_with_support__c') && (!str.contains('lucity')) && (!str.contains('sla'))) { 
            System.debug('Lucity Future Context '+ CaseFieldUpdate.inLucityFutureContext);
            system.debug('******The value has changed!!!! '); 
                  //FL 1/20/2015 - Added str != 'Send_Case_Creation_Email_to_Contact__c' to if statement below to allow Advocate to modify field after case is saved - see UAT Issue Log #2
                if((str != 'parentid') && (str != 'Send_Case_Creation_Email_to_Contact__c') && (OldCase.Lucity_Status_code__c == NewCase.Lucity_Status_code__c)  && (OldCase.Lucity_Status_type__c == NewCase.Lucity_Status_type__c))
                    NewCase.addError('Only field that can be changed on cases being integrated with Lucity is Parent Case.');
                else if(str == 'parentid' && CaseFieldUpdate.inLucityFutureContext == false) {
                 String casn = NewCase.CaseNumber;
                 CaseFieldUpdate.inLucityFutureContext = true;
                 System.debug('Calling Lucity....!!');
                 FormWrkCmt.updateParent(casn,flag);
                }
                        
           }
          } catch (Exception e) {
             System.debug('Error: ' + e); }
            } 
            
    
    }
}