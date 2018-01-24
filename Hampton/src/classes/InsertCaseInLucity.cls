global class InsertCaseInLucity{

  public void callFuture(String Casnum,Boolean pause) {
        System.debug('Entered 1');
        insCase(Casnum,pause);
    
    }
 
  global class GetResponse{
        public string Description;
        public string ApplicationErrorCode;
        public string AutoNumber;
        public Integer StatusCode;
        public string DataUrl;
        public string StatusType;
       
    }
 
  @future (callout=true) global static void insCase(string CaseNum,Boolean flag)
    {
           System.debug('Entered 2');
           String work_id,wr_status_code,wr_status_type;
           String endpoint = '';
           List<Case> cas = [select id,Street_Number__c,Street_Name__c,Zip__c,ContactId,createdDate,caseNumber,Lucity_Category_Code__c,Lucity_Category_Type__c,Lucity_Cause_Code__c,Lucity_Cause_Type__c,Lucity_Dept_Code__c,Lucity_Dept_Type__c,Lucity_Prob_Code__c,Lucity_Prob_Type__c,Lucity_User1_Code__c,Lucity_User1_Type__c from case where caseNumber =: CaseNum];
           //Get contact details
            Contact cCon = new Contact();
           if(cas[0].ContactId != null) {
               String conId = cas[0].ContactId;
               cCon = [select id,FirstName,LastName,Email,HomePhone,OtherPhone,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode from contact where id =: conId];
           }
           String aptNum='';//split address1 into 2
           
            String address1='';
            String address2=''; 
            if(cCon.MailingStreet != null) {                      
                address1 = cCon.MailingStreet;               
            }
            string body;
            string wrkComnt;
            FormWrkCmt frm = new FormWrkCmt();
            wrkComnt = frm.Com(CaseNum);
            System.debug('The STRING '+wrkComnt);
           JSONGenerator gen = JSON.createGenerator(true); 
                    
            for(Case a : cas ) {
                gen.writeStartObject();                                
                gen.writeStringField('AccountNumber',a.caseNumber);
                if(a.Lucity_Category_Code__c != null) {
                    gen.writeStringField('CategoryCode',a.Lucity_Category_Code__c);
                    gen.writeStringField('CategoryType',a.Lucity_Category_Type__c);
                } 
               
                if(a.Lucity_Cause_Code__c!= null && a.Lucity_Cause_Type__c!= null) {   
                    gen.writeStringField('CauseCode',a.Lucity_Cause_Code__c);
                    gen.writeStringField('CauseType',a.Lucity_Cause_Type__c);
                }
                if(cCon.FirstName != null)
                    gen.writeStringField('RequestorName1',cCon.FirstName);
                if(cCon.LastName!= null)
                    gen.writeStringField('RequestorName2',cCon.LastName);               
                gen.writeStringField('RequestorBuildingNumber',aptNum);//find val               
                gen.writeStringField('RequestorStreetDirection',address1);//change
                gen.writeStringField('RequestorApartment',address2);
                gen.writeStringField('LocationCity','Hampton');
                gen.writeStringField('LocationState','VA'); 
                if(a.Zip__c!=null) 
                    gen.writeStringField('LocationZipCode',a.Zip__c);
                if(cCon.MailingStreet!=null)
                    gen.writeStringField('RequestorStreet',cCon.MailingStreet);
                if(cCon.MailingCity!=null)
                    gen.writeStringField('RequestorCity',cCon.MailingCity);
                if(cCon.MailingState!=null)    
                    gen.writeStringField('RequestorState',cCon.MailingState);
                if(cCon.MailingPostalCode!=null)     
                    gen.writeStringField('RequestorZipCode',cCon.MailingPostalCode);
                if(cCon.Email!=null)  
                    gen.writeStringField('RequestorEmail',cCon.Email);
                if(cCon.HomePhone!=null)
                    gen.writeStringField('RequestorHomePhone',cCon.HomePhone);
                if(cCon.Phone!=null)
                    gen.writeStringField('RequestorWorkPhone',cCon.Phone);
                if(cCon.MobilePhone!=null)
                    gen.writeStringField('RequestorPhone1',cCon.MobilePhone);   
                if(cCon.OtherPhone!=null)
                    gen.writeStringField('RequestorPhone2',cCon.OtherPhone);   
               /* if((a.Street_Number__c!=null)&&(a.Street_Name__c!=null))  
                    gen.writeStringField('LocationApartment',a.Street_Number__c+' '+a.Street_Name__c); */
               //Mapping changed     
                if(a.Street_Number__c!=null) 
                    gen.writeStringField('LocationBuildingType',a.Street_Number__c);
                if(a.Street_Name__c!=null)
                    gen.writeStringField('LocationBuildingTypeType',a.Street_Name__c);
               //Mapping changed      
                if(a.Lucity_Prob_Code__c!=null) {    
                    gen.writeStringField('ProblemCode',a.Lucity_Prob_Code__c);
                    gen.writeStringField('ProblemType',a.Lucity_Prob_Type__c);   
                } 
                if(a.Lucity_Dept_Code__c!=null) {                
                    gen.writeStringField('DepartmentCode',a.Lucity_Dept_Code__c);
                    gen.writeStringField('DepartmentType',a.Lucity_Dept_Type__c);  
                }  
                if(a.Lucity_User1_Code__c!=null) {                
                    gen.writeStringField('User1Code',a.Lucity_User1_Code__c);
                    gen.writeStringField('User1Type',a.Lucity_User1_Type__c );               
                }   
                gen.writeStringField('WorkOrderComment',wrkComnt);          
                gen.writeEndObject();    
            }
            
            body= gen.getAsString();
        system.debug('Body is '+body);
        try {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String username = 'salesforceTEST';
        String password = 'aFi9yJyP';
        request.setHeader('Authorization','Basic c2FsZXNmb3JjZXRlc3Q6YUZpOXlKeVA=');
        request.setMethod('POST');
        request.setHeader('Content-Type','application/json');        
        request.setTimeout(30000);
        if(flag == true)
           endpoint = 'https://lsf.hampton.gov:35181/LucityRESTAPI_PW/Work/Request.svc/?format=json';
        else 
            endpoint = 'https://lsf.hampton.gov:35182/LucityRESTAPI_Parks/Work/Request.svc/?format=json';
            
        request.setEndpoint(endpoint);       
        //request.setEndpoint('https://lsf.hampton.gov:'+port+'/LucityRESTAPI_PW/Work/Request.svc/?format=json'); 
        request.setbody(body);
        System.debug('Sending..');
        if(Test.isRunningTest()) {
            GetResponse r = new GetResponse();
        }    
        if (!Test.isRunningTest()) {
        Httpresponse response = http.send(request);  
        System.debug(response.getBody());  
        String jsonString =  response.getBody();  
        GetResponse aResponse = (GetResponse) Json.Deserialize(jsonString, GetResponse.class);
        System.debug(aResponse+' Desc '+ aResponse.Description + 'code ' + aResponse.ApplicationErrorCode + aResponse.StatusCode);
        
        Case c = [Select CaseNumber,Lucity_WR_ID__c,Lucity_WR_from_Interface__c,Lucity_Status_Code__c,Lucity_Status_Type__c from case where caseNumber=:CaseNum];
        if(c.Lucity_WR_ID__c == null)
            c.Lucity_WR_ID__c = aResponse.AutoNumber;
        if(c.Lucity_Status_Code__c == null)
            c.Lucity_Status_Code__c =aResponse.StatusCode;
        if(c.Lucity_Status_Type__c == null)
            c.Lucity_Status_Type__c =aResponse.StatusType; 
        if(c.Lucity_WR_from_Interface__c== null) {
            integer indexOfLast = aResponse.DataUrl.lastIndexOf('/');
            String newString = aResponse.DataUrl;
            integer l2 = aResponse.DataUrl.substring(0, indexOfLast).lastIndexOf('/');
            if(indexOfLast >= 0) newString = aResponse.DataUrl.substring(0, l2);
            system.debug(newString);
            c.Lucity_WR_from_Interface__c=newString; 
        }        
       update c;  
      }       
       system.debug('Future '+CaseFieldUpdate.inLucityFutureContext);
      } catch(Exception e) {
          system.debug(e);
      } finally {
           CaseFieldUpdate.inLucityFutureContext = false;
           system.debug('Future '+CaseFieldUpdate.inLucityFutureContext);
      }
   }
 }