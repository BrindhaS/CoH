trigger LucityInsertComment on CaseComment (after insert) {
    
    Boolean indicator= false;
    for(CaseComment c : trigger.New) {
         String comBody = c.CommentBody;
     if(!comBody.contains('Created by Lucity')) {
        List<Case> cCas = [Select id,Lucity_WR_ID__c,Lucity_Public_works__c,Lucity_Parks__c  from case where id =: c.ParentId];
        String wrId = cCas[0].Lucity_WR_ID__c;
        String parId = c.ParentId;       
        if((cCas[0].Lucity_WR_ID__c != null)&&(cCas[0].Lucity_Public_works__c == TRUE || cCas[0].Lucity_Parks__c == TRUE)) {
            if(cCas[0].Lucity_Public_works__c == TRUE) indicator=true;
            else if(cCas[0].Lucity_Parks__c == TRUE) indicator=false; 
            InsertCaseCommentInLucity iCom = new InsertCaseCommentInLucity();
            iCom.callCommentFuture(wrId,parId,indicator,comBody); 
        } 
      }       
    }
    
}