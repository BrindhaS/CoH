global class FormWrkCmt {
    
    global String Com(String casNum) {

        String wrkCom = '';
        String lnBrk = '\r\n\t\t\t';
        String spc = '\t';
        String eq = '=';
        wrkCom = 'Case Details' + lnBrk;
        //Case c = [Select OwnerId,ParentId,Additional_or_Exact_Location_Details__c,Subject,Description,In_Street_Blocking_Road__c,Items_to_be_Addressed__c,Specific_Time_Problem_Occurs__c,Reason_for_Study__c,Miscellaneous_Traffic_Issues__c,Customer_Requesting_Call_Back__c,Miscellaneous_Solid_Waste_Issues__c,Spillage_Possible_Hazmat_Issue__c,RecordType.Name,Service_Request_Type__c,Water_Consumption__c,Travel_Direction__c,Issue_Poses_Safety_Risk__c,Type_of_Sign__c,Neighborhood_Share_Contact_Info__c,New_Sign_or_Repair__c,SLA__c,SLA_Date_and_Time__c,Origin,Priority,Grounds_Maintenance_Types__c,Does_the_issue_pose_a_safety_risk__c from case where CaseNumber=: casNum];
        Case c = [Select Owner.Name,ParentId,Additional_or_Exact_Location_Details__c,Building_Materials__c,Tires_Type_Not_Allowed__c,Yard_Waste_in_Black_Bags__c,Vacant_Home_or_Cleaned_Out_Residence__c,Trash_Types_Improperly_Mixed__c,Spillage_Trash_Not_On_City__c,Tires_Excess_of_Limit__c,Overflowing_Container__c,Logs_Stumps_or_Oversized_Limbs__c,Household_Chemicals__c,Glass_Improperly_Contained__c,Extra_Trash_Bags_at_the_Curb__c,Early_Constant_Put_Out__c,Contractor_Debris_Waste__c,Contractor_Bagster__c,Containers_in_Excess_of_Limit__c,Container_Not_Pulled_Back__c,Container_Not_Issued_by_the_City__c,Blocked_Collection_Items__c,Timing_Issue__c,Specific_Time_Problem_Occurs__c,Emergency_Conditions__c,Routine_Repair_Conditions__c,Tires__c,Waterworks_Account_Name_and_Number__c,Preferred_Delivery_Date__c,Payment_Location__c,Payment_Method__c,Payment_Most_Likely_Needed__c,Damage_to_Container_Caused_By__c,Damage_Container_Issue__c,New_Container_Issue__c,Refuse_Container_QTY__c,Recycling_Container_QTY__c,Collection_Types__c,Type_and_Volume_of_Items__c,Hazardous_Materials__c,X911_Communications_Callout__c,Party_at_Fault__c,Debris_Material_Types__c,Stormwater_Component__c,Subject,Description,In_Street_Blocking_Road__c,Items_to_be_Addressed__c,Reason_for_Study__c,Miscellaneous_Traffic_Issues__c,Customer_Requesting_Call_Back__c,Miscellaneous_Solid_Waste_Issues__c,Spillage_Possible_Hazmat_Issue__c,RecordType.Name,Service_Request_Type__c,Water_Consumption__c,Travel_Direction__c,Issue_Poses_Safety_Risk__c,Type_of_Sign__c,Neighborhood_Share_Contact_Info__c,New_Sign_or_Repair__c,SLA__c,SLA_Date_and_Time__c,Origin,Priority,Grounds_Maintenance_Types__c,Does_the_issue_pose_a_safety_risk__c from case where CaseNumber=: casNum];
       // User u = [select id,user.name from User where id =: c.OwnerId];
        if(c.ParentId != null){
         Case temp = [Select id,CaseNumber from case where id =: c.ParentId];
         wrkCom = wrkCom + 'Parent case'+eq+temp.CaseNumber+lnbrk;
        }
        else
         wrkCom = wrkCom + 'Parent case'+eq+'null'+lnbrk;
        
        wrkCom = wrkCom + 'Case owner'+eq+c.Owner.Name+lnbrk;
       
       // wrkCom = wrkCom + 'Account Name'+eq+c.Account+lnbrk;
        
        wrkCom = wrkCom +'Service Request Location' + lnBrk;
        if(c.Additional_or_Exact_Location_Details__c != null) 
                wrkCom = wrkCom + 'Additional or exact Location'+eq+c.Additional_or_Exact_Location_Details__c+lnbrk; 
        else
                wrkCom = wrkCom + 'Additional or exact Location'+eq+'null'+lnbrk;   
       
       
        wrkCom = wrkCom +'Knowledge Search' + lnBrk;
        if(c.Subject != null) 
                wrkCom = wrkCom + 'Subject'+eq+c.Subject+lnbrk;
        else
                wrkCom = wrkCom + 'Subject'+eq+'null'+lnbrk;       
       
        wrkCom = wrkCom +'Additional Information' + lnBrk;
        wrkCom = wrkCom + 'Record type'+eq+c.RecordType.Name+lnbrk;
        wrkCom = wrkCom + 'Service Request Type'+eq+c.Service_Request_Type__c+lnbrk;
        wrkCom = wrkCom + 'SLA'+eq+c.SLA__c+lnbrk;
        wrkCom = wrkCom + 'SLA Date/Time'+eq+c.SLA_Date_and_Time__c+lnbrk;
        wrkCom = wrkCom + 'Case Origin'+eq+c.Origin+lnbrk;
        wrkCom = wrkCom + 'Priority'+eq+c.Priority+lnbrk;
        //Alarms
        if(c.RecordType.Name == 'Alarms') {

        }
        //Grounds maintenance
        if(c.RecordType.Name == 'Grounds Maintenance') {
            wrkCom = wrkCom + 'Grounds Maintenance Types'+eq+c.Grounds_Maintenance_Types__c+lnbrk;
        }
        //Lights
        if(c.RecordType.Name == 'Lights - Parking Lots, Streets and Walkways') {
            if(c.Does_the_issue_pose_a_safety_risk__c != null)
                wrkCom = wrkCom + 'Does the issue pose a safety risk'+eq+c.Does_the_issue_pose_a_safety_risk__c+lnbrk;
            else
                wrkCom = wrkCom + 'Does the issue pose a safety risk'+eq+'null'+lnbrk;
        }
        //Signs
        if(c.RecordType.Name == 'Signs/Cones/Barricades') {
            if(c.New_Sign_or_Repair__c != null)
                wrkCom = wrkCom + 'New Sign or repair'+eq+c.New_Sign_or_Repair__c+lnbrk;
            else
                wrkCom = wrkCom + 'New Sign or repair'+eq+'null'+lnbrk;
            if(c.Neighborhood_Share_Contact_Info__c != null)
                wrkCom = wrkCom + 'Neighborhood share contact info'+eq+c.Neighborhood_Share_Contact_Info__c+lnbrk;
            else
                wrkCom = wrkCom + 'Neighborhood share contact info'+eq+'null'+lnbrk;
            wrkCom = wrkCom + 'Type of sign'+eq+c.Type_of_Sign__c+lnbrk;
            wrkCom = wrkCom + 'Issue poses safety risk'+eq+c.Issue_Poses_Safety_Risk__c+lnbrk;
            wrkCom = wrkCom + 'Travel Direction'+eq+c.Travel_Direction__c+lnbrk;

        }   
        //Trash collection
        if(c.RecordType.Name == 'Trash - Collection Information/Disability Application') {
            if(c.Water_Consumption__c != null)
                wrkCom = wrkCom + 'Water Consumption'+eq+c.Water_Consumption__c+lnbrk;
            else
                wrkCom = wrkCom + 'Water Consumption'+eq+'null'+lnbrk;
        }
        //Trash miscellaneous
        if(c.RecordType.Name == 'Trash - Miscellaneous Issues - Solid Waste') {
            if(c.Spillage_Possible_Hazmat_Issue__c != null)
                wrkCom = wrkCom + 'Spillage Possible Hazmat issue'+eq+c.Spillage_Possible_Hazmat_Issue__c+lnbrk;
            else
                wrkCom = wrkCom + 'Spillage Possible Hazmat issue'+eq+'null'+lnbrk;
            if(c.Miscellaneous_Solid_Waste_Issues__c != null)
                wrkCom = wrkCom + 'Miscellaneous Solid waste issue'+eq+c.Miscellaneous_Solid_Waste_Issues__c+lnbrk;
            else
                wrkCom = wrkCom + 'Miscellaneous Solid waste issue'+eq+'null'+lnbrk;
            wrkCom = wrkCom + 'Customer Requesting call back'+eq+c.Customer_Requesting_Call_Back__c+lnbrk;
        }
        //Traffic miscellaneous
        if(c.RecordType.Name == 'Traffic Miscellaneous Issues') {
            wrkCom = wrkCom + 'Customer Requesting call back'+eq+c.Customer_Requesting_Call_Back__c+lnbrk;
            wrkCom = wrkCom + 'Miscellaneous Traffic Issues'+eq+c.Miscellaneous_Traffic_Issues__c+lnbrk;
        }
        //Traffic pavement
        if(c.RecordType.Name == 'Traffic Pavement Markings and Reflector Posts') {
            wrkCom = wrkCom + 'Items to be addressed'+eq+c.Items_to_be_Addressed__c+lnbrk;
            wrkCom = wrkCom + 'Travel Direction'+eq+c.Travel_Direction__c+lnbrk;
        }
        //Traffic count
        if(c.RecordType.Name == 'Traffic Count/Study Request') {
            wrkCom = wrkCom + 'Reason for study'+eq+c.Reason_for_Study__c+lnbrk;
            wrkCom = wrkCom + 'Specific Time Problem Occurs'+eq+c.Specific_Time_Problem_Occurs__c+lnbrk;
            wrkCom = wrkCom + 'Travel Direction'+eq+c.Travel_Direction__c+lnbrk;
        }
        //Traffic Guardrail
        if(c.RecordType.Name == 'Traffic Guardrail Repair') {
            if(c.In_Street_Blocking_Road__c != null)
                wrkCom = wrkCom + 'In Street/Blocking Road'+eq+c.In_Street_Blocking_Road__c+lnbrk;
            else
                wrkCom = wrkCom + 'In Street/Blocking Road'+eq+'null'+lnbrk;
            wrkCom = wrkCom + 'Travel Direction'+eq+c.Travel_Direction__c+lnbrk;
        }
         //Illegal Dumping of debris
        if(c.RecordType.Name == 'Illegal Dumping of Debris / Stormwater Violation') {
            if(c.Debris_Material_Types__c != null)
                wrkCom = wrkCom + 'Debris Material Types'+eq+c.Debris_Material_Types__c+lnbrk;
            if(c.Stormwater_Component__c != null)
                wrkCom = wrkCom + 'Stormwater component'+eq+c.Stormwater_Component__c+lnbrk;
             wrkCom = wrkCom + 'Hazardous Materials'+eq+c.Hazardous_Materials__c+lnbrk;
            if(c.X911_Communications_Callout__c != null)
                wrkCom = wrkCom + '911 Communications callout'+eq+c.X911_Communications_Callout__c+lnbrk;
            if(c.Party_at_Fault__c != null)
                wrkCom = wrkCom + 'Party at Fault'+eq+c.Party_at_Fault__c+lnbrk;
        }
         //Trash - Collection Request - Solid Waste
        if(c.RecordType.Name == 'Trash - Collection Request - Solid Waste') {           
            wrkCom = wrkCom + 'Collection Types'+eq+c.Collection_Types__c+lnbrk; //changed checkbox fields to multi-picklist 21/7/14           
            wrkCom = wrkCom + 'Type and volume of Items'+eq+c.Type_and_Volume_of_Items__c+lnbrk;
        }
         //Trash - Container - Solid Waste
        if(c.RecordType.Name == 'Trash - Container - Solid Waste') {
            wrkCom = wrkCom + 'Recycling container qty'+eq+c.Recycling_Container_QTY__c+lnbrk;
            wrkCom = wrkCom + 'Refuse container Qty'+eq+c.Refuse_Container_QTY__c+lnbrk;
            if(c.New_Container_Issue__c != null)
                wrkCom = wrkCom + 'New container issue'+eq+c.New_Container_Issue__c+lnbrk;
            if(c.Damage_Container_Issue__c != null)
                wrkCom = wrkCom + 'Damage Container Issue'+eq+c.Damage_Container_Issue__c+lnbrk;
            if(c.Damage_to_Container_Caused_By__c != null)
                wrkCom = wrkCom + 'Damage to container caused by'+eq+c.Damage_to_Container_Caused_By__c+lnbrk;
            if(c.Payment_Most_Likely_Needed__c != null)
                wrkCom = wrkCom + 'Payment most likely needed'+eq+c.Payment_Most_Likely_Needed__c+lnbrk;
            if(c.Payment_Method__c != null)
                wrkCom = wrkCom + 'Payment method'+eq+c.Payment_Method__c+lnbrk;
            if(c.Payment_Location__c != null)
                wrkCom = wrkCom + 'Payment Location'+eq+c.Payment_Location__c+lnbrk;
            if(c.Waterworks_Account_Name_and_Number__c != null)
                wrkCom = wrkCom + 'Waterworks Account name and number'+eq+c.Waterworks_Account_Name_and_Number__c+lnbrk;
            if(c.Preferred_Delivery_Date__c != null)
                wrkCom = wrkCom + 'Preferred Delivery rate'+eq+c.Preferred_Delivery_Date__c+lnbrk;

        }
        //Traffic and School Signals (Repair/Timing/Emergency)
        if(c.RecordType.Name == 'Traffic and School Signals (Repair/Timing/Emergency)') {
            if(c.Emergency_Conditions__c != null)
                wrkCom = wrkCom + 'Emergency conditions'+eq+c.Emergency_Conditions__c+lnbrk;
            if(c.Routine_Repair_Conditions__c != null)
                wrkCom = wrkCom + 'Routine or Repair Conditions'+eq+c.Routine_Repair_Conditions__c+lnbrk;
            if(c.Timing_Issue__c != null)
                wrkCom = wrkCom + 'Timing Issue'+eq+c.Timing_Issue__c+lnbrk;
            if(c.Travel_Direction__c != null)
                wrkCom = wrkCom + 'Travel Direction'+eq+c.Travel_Direction__c+lnbrk;
             wrkCom = wrkCom + 'Type and volume of Items'+eq+c.Specific_Time_Problem_Occurs__c+lnbrk;
        }
         //Trash - Collection Violations
        if(c.RecordType.Name == 'Trash - Collection Violations') {
            if(c.Blocked_Collection_Items__c != null)
                wrkCom = wrkCom + 'Blocked collection items'+eq+c.Blocked_Collection_Items__c+lnbrk;
            if(c.Building_Materials__c != null)
                wrkCom = wrkCom + 'Building materials'+eq+c.Building_Materials__c+lnbrk;
            if(c.Container_Not_Issued_by_the_City__c != null)
                wrkCom = wrkCom + 'Container not issued by the city'+eq+c.Container_Not_Issued_by_the_City__c+lnbrk;
            if(c.Container_Not_Pulled_Back__c != null)
                wrkCom = wrkCom + 'Container not pulled back'+eq+c.Container_Not_Pulled_Back__c+lnbrk;
            if(c.Containers_in_Excess_of_Limit__c != null)
                wrkCom = wrkCom + 'containers in excess of limit'+eq+c.Containers_in_Excess_of_Limit__c+lnbrk;
            if(c.Contractor_Bagster__c != null)
                wrkCom = wrkCom + 'Contractor Bagster'+eq+c.Contractor_Bagster__c+lnbrk;
            if(c.Contractor_Debris_Waste__c != null)
                wrkCom = wrkCom + 'Contractor debris waste'+eq+c.Contractor_Debris_Waste__c+lnbrk;
            if(c.Early_Constant_Put_Out__c != null)
                wrkCom = wrkCom + 'Early constant put out'+eq+c.Early_Constant_Put_Out__c+lnbrk;
            if(c.Extra_Trash_Bags_at_the_Curb__c != null)
                wrkCom = wrkCom + 'Extra trash bags on the curb'+eq+c.Extra_Trash_Bags_at_the_Curb__c+lnbrk;
            if(c.Glass_Improperly_Contained__c != null)
                wrkCom = wrkCom + 'Glass improperly contained'+eq+c.Glass_Improperly_Contained__c+lnbrk;
            if(c.Household_Chemicals__c != null)
                wrkCom = wrkCom + 'Household chemicals'+eq+c.Household_Chemicals__c+lnbrk;
            if(c.Logs_Stumps_or_Oversized_Limbs__c != null)
                wrkCom = wrkCom + 'Logs stumps or oversized containers'+eq+c.Logs_Stumps_or_Oversized_Limbs__c+lnbrk;
            if(c.Overflowing_Container__c != null)
                wrkCom = wrkCom + 'Overflowing containers'+eq+c.Overflowing_Container__c+lnbrk;
            if(c.Spillage_Trash_Not_On_City__c != null)
                wrkCom = wrkCom + 'Spillage trash not on city'+eq+c.Spillage_Trash_Not_On_City__c+lnbrk;
            if(c.Tires_Excess_of_Limit__c != null)
                wrkCom = wrkCom + 'Tires excess of limit'+eq+c.Tires_Excess_of_Limit__c+lnbrk;
            if(c.Tires_Type_Not_Allowed__c != null)
                wrkCom = wrkCom + 'Tires types not allowed'+eq+c.Tires_Type_Not_Allowed__c+lnbrk;
            if(c.Trash_Types_Improperly_Mixed__c != null)
                wrkCom = wrkCom + 'Trash types improperly mixed'+eq+c.Trash_Types_Improperly_Mixed__c+lnbrk;
            if(c.Vacant_Home_or_Cleaned_Out_Residence__c != null)
                wrkCom = wrkCom + 'Vacant home or cleaned out residence'+eq+c.Vacant_Home_or_Cleaned_Out_Residence__c+lnbrk;
            if(c.Yard_Waste_in_Black_Bags__c != null)
                wrkCom = wrkCom + 'Yard waste in black bags'+eq+c.Yard_Waste_in_Black_Bags__c+lnbrk;

        }
        
        wrkCom = wrkCom +'Description Information' + lnBrk;
        if(c.Description != null)               
                wrkCom = wrkCom + 'Description'+eq+c.Description+lnbrk;
        else
                wrkCom = wrkCom + 'Description'+eq+'null'+lnbrk;    

        System.debug('The final String is '+wrkCom);
        return wrkCom;
    }

    @future (callout=true) global static void updateParent(string CaseNum,Boolean flag) {
       Case c = [Select id,Lucity_WR_ID__c from case where casenumber =: CaseNum];
       String endpoint = 'https://lsf.hampton.gov:35182/LucityRESTAPI_Parks/Work/Request.svc/'+c.Lucity_WR_ID__c +'?format=json';
           if(flag == true)
                endpoint = 'https://lsf.hampton.gov:35181/LucityRESTAPI_PW/Work/Request.svc/'+c.Lucity_WR_ID__c +'?format=json';
        FormWrkCmt obj = new FormWrkCmt();  
        String body;     
        String comm= obj.com(CaseNum); 
        JSONGenerator gen = JSON.createGenerator(true); 
        gen.writeStartObject();                                
        gen.writeStringField('WorkOrderComment',comm); 
        gen.writeEndObject();   
        body = gen.getAsString();
        system.debug('Body is '+body);  
       try {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String username = 'salesforceTEST';
        String password = 'aFi9yJyP';
        request.setHeader('Authorization','Basic c2FsZXNmb3JjZXRlc3Q6YUZpOXlKeVA=');
        request.setMethod('PUT');
        request.setHeader('Content-Type','application/json');
        request.setEndpoint(endpoint);
        request.setbody(body);
        System.debug('Sending..');
        if(!Test.isRunningTest()) {
            Httpresponse response = http.send(request);         
            JSONParser parser = JSON.createParser(response.getBody()); 
            System.debug(response.getBody());  
            String jsonString =  response.getBody(); 
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