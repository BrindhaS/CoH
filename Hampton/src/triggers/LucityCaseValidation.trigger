trigger LucityCaseValidation on Case (before delete,before update,before insert) {
    if (Trigger.isBefore) {
        if (Trigger.isDelete) {
            for (Case c : Trigger.old) {
                if ((c.Lucity_Public_Works__c == TRUE || c.Lucity_Parks__c == TRUE)&& (c.Lucity_WR_Id__c != null)     )
                    if(c.Lucity_Returned_Date__c == null) 
                        c.addError('Cases being integrated with Lucity cannot be deleted');
                }        
            }
        else if (Trigger.isUpdate) {
          for (Case c : Trigger.new) {
              if((c.Lucity_Public_Works__c == TRUE || c.Lucity_Parks__c == TRUE)&& (c.Lucity_WR_Id__c != null))    {
                  if((c.status != 'New') && (c.Lucity_WR_Id__c == null))
                        c.addError('New cases being integrated with Lucity must have a Status = New');                
              } 
          }
        }  
    } 
}