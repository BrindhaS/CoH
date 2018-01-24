/* The batch class that is used to get the lucity comments, verify for comments and update
 * accordingly to SFDC.
 * Implements BRULE 18
 */

global class BatchSyncCom implements Database.Batchable<sObject>, Database.AllowsCallouts {

 public String query = 'Select id,casenumber,Lucity_public_works__c,Lucity_parks__c,Lucity_WR_Id__c from Case where Lucity_WR_Id__c != NULL and status!=\'Closed\'';
   
     global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
     }

    global class GetLucityComments{
        public string Comment;
        public string RecordedBy;
       
    }   
 
     global void execute(Database.BatchableContext BC, List<Case> records) {         
              
            String endpoint = null;
           // List<CaseComment> temp = new List<CaseComment>();
            for ( integer i = 0; i< records.size(); i++ ) {
                     if(records[i].Lucity_public_works__c == TRUE)  
                         endpoint = 'https://lsf.hampton.gov:35181/LucityRESTAPI_PW/Work/Request.svc/'+records[i].Lucity_WR_Id__c+'/CommentList/?format=json'; 
                     else if(records[i].Lucity_parks__c == TRUE)
                         endpoint = 'https://lsf.hampton.gov:35182/LucityRESTAPI_Parks/Work/Request.svc/'+records[i].Lucity_WR_Id__c+'/CommentList/?format=json'; 

                   List<CaseComment> cCom = [Select id,CommentBody,ParentId from CaseComment where ParentId =: records[i].Id];
            System.debug('End Point '+endpoint + 'Record size '+records.size());  
             if(Test.isRunningTest()) {
                      GetLucityComments r = new GetLucityComments();
                      endpoint = 'https://lsf.hampton.gov:35181/LucityRESTAPI_PW/Work/Request.svc/'+records[i].Lucity_WR_Id__c+'/CommentList/?format=json';
              }        
             try {                  
                  HttpRequest req = new HttpRequest();
                  HttpResponse res = new HttpResponse();
                  Http http = new Http();
                  // Set values to Params
                  String username = 'salesforceTEST';
                  String password = 'aFi9yJyP';                 
                  req.setHeader('Authorization','Basic c2FsZXNmb3JjZXRlc3Q6YUZpOXlKeVA=');                  
                  req.setHeader('Content-Type', 'application/json');
                  req.setEndpoint(endpoint);
                  req.setMethod('GET');      
                  // req.setCompressed(true); 
                  String sJson = null;
                  if (!Test.isRunningTest()) {      
                    res = http.send(req);
                    sJson = res.getBody();                   
                    System.debug('Str:' + res.getBody());
                   // sJson = sJson.replace('[','');
                   // sJson = sJson.replace(']','');
                    System.debug('String JSON: ' + sJson);
                  }             
                  // Parse response. 
                  if( res.getBody() != '[]') {
                    List<GetLucityComments> aResponse = (List<GetLucityComments>) Json.Deserialize(sJson, List<GetLucityComments>.class);
                    system.debug('Comment List ' + aResponse);
                    List<CaseComment> temp2 = new List<CaseComment>();
                    List<CaseComment> cCoList = new List<CaseComment>();
                    String tempComment = '';   
                    Boolean DontInsert =false;
                        for(GetLucityComments aResp : aResponse) {
                            DontInsert = false;
                            if(cCom.size() <= 0) {
                                
                                CaseComment temp = new CaseComment();
                                temp.CommentBody = aResp.Comment + '\n' + 'Created by Lucity User '+ aResp.RecordedBy;
                                temp.ParentId = records[i].Id;
                                temp2.add(temp);
                                System.debug('Added');                       
                            }
                        
                            else if(cCom.size() > 0) {
                                for(CaseComment cm : cCom) {
                                    tempComment = aResp.Comment + '\n' + 'Created by Lucity User ' + aResp.RecordedBy; 
                                    System.debug('Lucity Comment: ' +tempComment );                    
                                    System.debug('SFDC Comment: ' + cm.CommentBody);  
                                    system.debug('DONT INSERT ' + DontInsert);                  
                                    if((cm.CommentBody.equals(tempComment)) || (aResp.RecordedBy.equalsIgnoreCase('salesforcetest'))) {
                                            System.debug(cm.CommentBody + 'equal to '+ tempComment);
                                            DontInsert = true;
                                     }
                                     
                                     else
                                     break;       
                                }        
                            system.debug('DONT INSERT ' + DontInsert);
                            }
                            if(DontInsert == false) {
                                CaseComment cCo = new CaseComment();
                                cCo.CommentBody = tempComment;                         
                                cCo.ParentId = records[i].Id;
                                cCoList.add(cCo);
                                System.debug('Added '+ cCo + 'Case' + records[i].Id);
                            }    
                        } 
                       if(cCoList.size() > 0) 
                           insert cCoList;
                       if(temp2.size() > 0) 
                           insert temp2; 
                  }              
              }
          catch (Exception e) {         
            System.debug('Error:' + e.getMessage() + 'LN:' + e.getLineNumber() );           
          }
       }
      
       System.debug('Done!');
    }   

    global void finish(Database.BatchableContext BC){
        
    }
}