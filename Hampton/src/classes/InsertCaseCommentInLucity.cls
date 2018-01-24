global class InsertCaseCommentInLucity{

     public void callCommentFuture (String workorderId,String parId,Boolean flag,String comBody) {
        System.debug('Entered callCommentFuture');
        insComment(workorderId,parId,flag,comBody);
    
    }

     global class GetCommentResponse{
        public string Description;
        public string ApplicationErrorCode;
        public string Comment;
       
    }   
  
  @future (callout=true) global static void insComment(String workorderId,String parId,Boolean flag,String comBody)
    {
    
        List<CaseComment> cCom = [Select CommentBody,parentID from CaseComment where parentID =: parId];           
            
            JSONGenerator gen = JSON.createGenerator(true); 
                   
           String body;
           
                gen.writeStartObject(); 
                if(comBody != null)                             
                    gen.writeStringField('Comment',comBody);
                else
                    gen.writeStringField('Comment','');
                gen.writeEndObject();    
            
           
            body= gen.getAsString();
        System.debug(body); 
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization','Basic c2FsZXNmb3JjZXRlc3Q6YUZpOXlKeVA=');
        request.setMethod('POST');
        request.setHeader('Content-Type','application/json');
        if(flag == true)
            request.setEndpoint('https://lsf.hampton.gov:35181/LucityRESTAPI_PW/Work/Request.svc/' + workorderId + '/CommentList/?format=json');
        else
            request.setEndpoint('https://lsf.hampton.gov:35182/LucityRESTAPI_Parks/Work/Request.svc/' + workorderId + '/CommentList/?format=json');
        request.setbody(body);
        if (!Test.isRunningTest()) {
            Httpresponse response = http.send(request);  
            System.debug(response.getBody());  
            String jsonComString =  response.getBody();  
            GetCommentResponse aResponse = (GetCommentResponse) Json.Deserialize(jsonComString, GetCommentResponse.class);
        }
        }

}