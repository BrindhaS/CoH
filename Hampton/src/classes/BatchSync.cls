/* The batch class that is used to get the lucity records, verify for changes and update
 * accordingly to salesforce records.
 * Implements BRULE 16 and BRULE 24
 */

global class BatchSync implements Database.Batchable<sObject>, Database.AllowsCallouts {

 public String query = 'Select Id,CaseNumber,status,Lucity_Status_code__c ,Lucity_Returned_Date__c,Lucity_Status_Type__c ,Lucity_Category_Code__c,Lucity_Prob_Code__c,Lucity_Dept_Code__c ,Lucity_Cause_Code__c,Lucity_WR_ID__c,Lucity_public_works__c,Lucity_parks__c from case where Lucity_WR_ID__c != NULL and status!=\'Closed\'';
   
     global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
     }

    global class GetLucityRequests{
        public string StatusCode;
        public string StatusType;
        public string DepartmentCode;
        public string ProblemCode;
        public string CauseCode;
        public string CategoryCode;
       
    }   
 
     global void execute(Database.BatchableContext BC, List<Case> records) {         
              
            String endpoint = null;
            List<Case> temp = new List<Case>();
            for ( integer i = 0; i< records.size(); i++ ) {
                     if(records[i].Lucity_public_works__c == TRUE)  
                         endpoint = 'https://lsf.hampton.gov:35181/LucityRESTAPI_PW/Work/Request.svc/?format=json&Filter=WKREQ%20WHERE%20RQ_ID%3D'+records[i].Lucity_WR_ID__c;
                     else if(records[i].Lucity_parks__c == TRUE)
                         endpoint = 'https://lsf.hampton.gov:35182/LucityRESTAPI_Parks/Work/Request.svc/?format=json&Filter=WKREQ%20WHERE%20RQ_ID%3D'+records[i].Lucity_WR_ID__c; 
             System.debug('End Point '+endpoint + 'Record size '+records.size());    
             if(Test.isRunningTest()) {
                      GetLucityRequests r = new GetLucityRequests();
                      endpoint = 'https://lsf.hampton.gov:35181/LucityRESTAPI_PW/Work/Request.svc/?format=json&Filter=WKREQ%20WHERE%20RQ_ID%3D'+records[i].Lucity_WR_ID__c;
              }        
             try {                  
                  HttpRequest req = new HttpRequest();
                  HttpResponse res = new HttpResponse();
                  Http http = new Http();
                  // Set values to Params
                  String username = 'salesforceTEST';
                  String password = 'aFi9yJyP';
                  String sJson = null;                 
                  req.setHeader('Authorization','Basic c2FsZXNmb3JjZXRlc3Q6YUZpOXlKeVA=');                  
                  req.setHeader('Content-Type', 'application/json');
                                       
                  // req.setCompressed(true);                  
                  if (!Test.isRunningTest()) { 
                    req.setEndpoint(endpoint); 
                    req.setMethod('GET');     
                    res = http.send(req);
                    sJson = res.getBody();                   
                    System.debug('Str:' + res.getBody());
                    sJson = sJson.replace('[','');
                    sJson = sJson.replace(']','');
                    System.debug('String JSON: ' + sJson);
                  }             
                  // Parse response.  
                    GetLucityRequests aResponse = (GetLucityRequests) Json.Deserialize(sJson, GetLucityRequests.class);
                    
                        if((records[i].Lucity_Status_code__c != Integer.ValueOf(aResponse.StatusCode)) || (records[i].Lucity_Status_Type__c != aResponse.StatusType)) {
                            records[i].Lucity_Status_code__c = Integer.ValueOf(aResponse.StatusCode);
                            records[i].Lucity_Status_Type__c = aResponse.StatusType;
                            if((aResponse.StatusCode == '10') && (records[i].Lucity_Dept_Code__c != aResponse.DepartmentCode)) {
                                records[i].Lucity_Dept_Code__c = aResponse.DepartmentCode;
                            }
                            if((aResponse.StatusCode == '10') && (records[i].Lucity_Prob_Code__c!= aResponse.ProblemCode)) {
                                records[i].Lucity_Prob_Code__c= aResponse.ProblemCode;
                            }
                            if((records[i].Lucity_Parks__c == TRUE) && (aResponse.StatusCode == '10') && (records[i].Lucity_Cause_Code__c!= aResponse.CauseCode)) {
                                records[i].Lucity_Cause_Code__c= aResponse.CauseCode;
                            }
                            if((records[i].Lucity_Parks__c == TRUE) && (aResponse.StatusCode == '10') && (records[i].Lucity_Category_Code__c!= aResponse.CategoryCode)) {
                                records[i].Lucity_Category_Code__c= aResponse.CategoryCode;
                            }
                            if(aResponse.StatusCode == '952') {
                                records[i].Lucity_Returned_Date__c= System.NOW();
                            }
                             System.debug('Lucity Status code '+ records[i].Lucity_Status_code__c);
                            temp.add(records[i]);               
                            System.debug('TEMP '+temp);
                        }  
                   System.debug('Status code '+aResponse.StatusCode + 'Status Type ' +aResponse.StatusType + 'Department code ' + aResponse.DepartmentCode);              
                                
          }
          catch (Exception e) {         
            System.debug('Error:' + e.getMessage() + 'LN:' + e.getLineNumber() );           
          }
       }
       update temp;
       System.debug('Updated');
    }   

    global void finish(Database.BatchableContext BC){
        
    }
}