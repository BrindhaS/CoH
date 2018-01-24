trigger LucityCaseCommentValidate on CaseComment (before delete, before update) {
     if (Trigger.isDelete) {
          for (CaseComment caseComment : Trigger.old) {
             Case parentCase = [Select Id, Lucity_Parks__c, Lucity_Public_Works__c, Lucity_Returned_Date__c from Case where Id =:caseComment.parentId];
             if((parentCase.Lucity_Public_Works__c== TRUE || parentCase.Lucity_Parks__c == TRUE) && parentCase.Lucity_Returned_Date__c == null)  {
                 caseComment.addError('Comments cannot be deleted on cases being integrated with Lucity');
             }       
          }
     }
     else   {
           for (CaseComment caseComment : Trigger.new) {
               CaseComment oldCaseComment  = Trigger.oldMap.get(caseComment.ID);
               Case parentCase = [Select status , Id, Lucity_Parks__c, Lucity_Public_Works__c, Lucity_Returned_Date__c from Case where Id =:caseComment.parentId];
               if((parentCase.Lucity_Public_Works__c== TRUE || parentCase.Lucity_Parks__c == TRUE) && parentCase.Lucity_Returned_Date__c == null)  {
                   if(caseComment.CommentBody != oldCaseComment.CommentBody) 
                      caseComment.addError('Comments cannot be changed on cases being integrated with Lucity');
               }       
            } 
     }           
}