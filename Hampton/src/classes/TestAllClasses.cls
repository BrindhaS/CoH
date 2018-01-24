@isTest
public class TestAllClasses {

 
    static testmethod void m1() {
            
            Case c = new Case(Subject='testCase',Service_Request_Type__c = 'Alarms: City Offices',Lucity_Public_Works_Valid__c='yes',status='On Hold',Street_Number__c='230',Street_Name__c='Lincoln st'); 
            insert c;        
            Case cas = new Case(Subject='testCase',Service_Request_Type__c = 'Alarms: City Offices',Lucity_Public_Works_Valid__c='yes',status='New',Street_Number__c='230',Street_Name__c='Lincoln st'); 
            insert cas;
            cas.parentId=c.id;
            cas.Lucity_WR_ID__c = '99999';
            update cas;             
            Case cs = [select CaseNumber from case where id=: cas.Id];
            String casNum = cs.CaseNumber;
            FormWrkCmt.updateParent(casNum,true);      
    } 
    
     static testmethod void m2() {
            
            Case c = new Case(Subject='testCase',Service_Request_Type__c = 'Alarms: City Offices',status='New',Street_Number__c='230',Street_Name__c='Lincoln st'); 
            insert c;        
            Case cs = [select CaseNumber from case where id=: c.Id]; 
            delete cs;    
    } 
    
     static testmethod void m3() {
            
            Case c = new Case(Subject='testCase',Lucity_WR_ID__c = '99999',Service_Request_Type__c = 'Alarms: City Offices',status='New',Lucity_Public_Works_Valid__c='yes',Street_Number__c='230',Street_Name__c='Lincoln st'); 
            insert c;     
            CaseComment cm = new CaseComment();
            cm.CommentBody = 'test';
            cm.ParentId = c.Id;
            insert cm;
            InsertCaseCommentInLucity iCom = new InsertCaseCommentInLucity();
            iCom.callCommentFuture(c.Lucity_WR_ID__c ,c.Id,true,cm.CommentBody);
            iCom.callCommentFuture(c.Lucity_WR_ID__c ,c.Id,false,null);
            cm.CommentBody = 'new test';
            update cm;            
            delete cm; 
    } 
     static testmethod void m4() {
            
            Case c = new Case(Subject='testCase',Service_Request_Type__c = 'Alarms: City Offices',status='New',Lucity_Dept_Code__c='420',Lucity_Status_Code__c =10,Lucity_Public_Works_Valid__c='yes',Street_Number__c='230',Street_Name__c='Lincoln st'); 
            insert c;  
            c.Lucity_Dept_Code__c = '430';
            update c;
            c.Lucity_Dept_Code__c = '440';
            update c; 
            c.Lucity_Dept_Code__c = '460';
            update c; 
               
            
    } 
     static testmethod void m5() {
            
            Case c = new Case(Subject='testCase',Service_Request_Type__c = 'Alarms: City Offices',status='New',Lucity_Dept_Code__c='420',Lucity_Status_Code__c =10,Lucity_Public_Works_Valid__c='yes',Street_Number__c='230',Street_Name__c='Lincoln st'); 
            insert c;           
            c.Lucity_Dept_Code__c = '470';
            update c; 
            c.Lucity_Dept_Code__c = '475';
            update c; 
            c.Lucity_Dept_Code__c = '485';
            update c;
            c.Lucity_Status_Code__c= 952;
            update c;     
            
    } 
    static testmethod void m6() {
            
            Case c = new Case(Subject='testCase',Service_Request_Type__c = 'Alarms: City Offices',status='New',Lucity_Dept_Code__c='420',Lucity_Status_Code__c =10,Lucity_Public_Works_Valid__c='yes',Street_Number__c='230',Street_Name__c='Lincoln st'); 
            insert c;  
            c.Lucity_Dept_Code__c = '1';
            update c;
            c.Lucity_Dept_Code__c = '2';
            update c; 
            c.Lucity_Dept_Code__c = '3';
            update c; 
            c.Lucity_Dept_Code__c = '4';
            update c; 
            
    }
    static testmethod void m7() {
            
            Case c = new Case(Subject='testCase',Service_Request_Type__c = 'Alarms: City Offices',status='New',Lucity_Dept_Code__c='420',Lucity_Status_Code__c =10,Lucity_Public_Works_Valid__c='yes',Street_Number__c='230',Street_Name__c='Lincoln st'); 
            insert c;  
            c.Lucity_Status_Type__c = 'New Request';
            update c;
            c.Lucity_Status_Type__c = 'Transferred';
            update c; 
            c.Lucity_Status_Type__c = 'Return to 311 Call Center';
            update c; 
            c.Lucity_Status_Type__c = 'Assigned to WO';
            update c; 
            
    } 

    static testmethod void m8() {
            
            Case c = new Case(Subject='testCase',Service_Request_Type__c = 'Alarms: City Offices',status='New',Lucity_Dept_Code__c='420',Lucity_Status_Code__c =10,Lucity_Public_Works_Valid__c='yes',Street_Number__c='230',Street_Name__c='Lincoln st'); 
            insert c;  
            c.Lucity_Status_Type__c = 'Request on hold';
            update c;
            c.Lucity_Status_Type__c = 'WO Cancelled';
            update c; 
            c.Lucity_Status_Type__c = 'WO Completed';
            update c; 
            
            
    }
    static testmethod void m9() {
            RecordType rt = [Select Name,Id from RecordType where Name = 'Grounds Maintenance'];
            Case c = new Case(Subject='testCase',Service_Request_Type__c = 'Grounds Maintenance: City/School Property',RecordTypeId = rt.Id,Does_the_issue_pose_a_safety_risk__c=TRUE,status='New',Street_Number__c='230',Street_Name__c='Lincoln st'); 
            insert c;
            Case cs = [select CaseNumber from case where id=: c.Id];
            String casNum = cs.CaseNumber;
            FormWrkCmt.updateParent(casNum,true); 
            RecordType rt1 = [Select Name,Id from RecordType where Name = 'Trash - Collection Violations'];        
            Case c1 = new Case(Subject='testCase',Service_Request_Type__c = 'Trash - Collection Violations',Blocked_Collection_Items__c=TRUE,RecordTypeId = rt1.Id,Building_Materials__c=TRUE,Container_Not_Issued_by_the_City__c=TRUE,Container_Not_Pulled_Back__c=TRUE,Containers_in_Excess_of_Limit__c=TRUE,Contractor_Bagster__c=TRUE,Contractor_Debris_Waste__c=TRUE,Early_Constant_Put_Out__c=TRUE,Extra_Trash_Bags_at_the_Curb__c=TRUE,status='New',Street_Number__c='230',Street_Name__c='Lincoln st'); 
            insert c1; 
            Case cs1 = [select CaseNumber from case where id=: c1.Id];
            String casNum1 = cs1.CaseNumber;
            FormWrkCmt.updateParent(casNum1,true);   
            RecordType rt2 = [Select Name,Id from RecordType where Name = 'Trash - Miscellaneous Issues - Solid Waste'];
            Case c2 = new Case(Subject='testCase',Service_Request_Type__c = 'Trash Miscellaneous Issue - Solid Waste',RecordTypeId = rt.Id,Customer_Requesting_Call_Back__c='Yes',status='New',Street_Number__c='230',Street_Name__c='Lincoln st'); 
            insert c2;
            Case cs2 = [select CaseNumber from case where id=: c2.Id];
            String casNum2 = cs2.CaseNumber;
            FormWrkCmt.updateParent(casNum2,true); 
    }  
    static testmethod void m10() {
            
            RecordType rt = [Select Name,Id from RecordType where Name = 'Signs/Cones/Barricades'];
            Case c = new Case(Subject='testCase',Service_Request_Type__c = 'Signs: Emergency/Safety Hazard',New_Sign_or_Repair__c='New Sign',RecordTypeId = rt.Id,status='New',Street_Number__c='230',Street_Name__c='Lincoln st'); 
            insert c; 
            Case cs = [select CaseNumber from case where id=: c.Id];
            String casNum = cs.CaseNumber;
            FormWrkCmt.updateParent(casNum,true);   
            RecordType rt1 = [Select Name,Id from RecordType where Name = 'Trash - Collection Information/Disability Application'];     
            Case c1 = new Case(Subject='testCase',Service_Request_Type__c = 'Trash - Collection Disability Application',status='New',RecordTypeId = rt1.Id,Street_Number__c='230',Street_Name__c='Lincoln st'); 
            insert c1; 
            Case cs1 = [select CaseNumber from case where id=: c1.Id];
            String casNum1 = cs1.CaseNumber;
            FormWrkCmt.updateParent(casNum1,true); 
            RecordType rt2 = [Select Name,Id from RecordType where Name = 'Traffic and School Signals (Repair/Timing/Emergency)']; 
            Case c2 = new Case(Subject='testCase',Service_Request_Type__c = 'Traffic Signal Repair/Timing',Emergency_Conditions__c='Other',Timing_Issue__c='other',Travel_Direction__c='North',Routine_Repair_Conditions__c='Timing Off',status='New',RecordTypeId = rt2.Id,Street_Number__c='230',Street_Name__c='Lincoln st'); 
            insert c2;  
            Case cs2 = [select CaseNumber from case where id=: c2.Id];
            String casNum2 = cs2.CaseNumber;
            FormWrkCmt.updateParent(casNum2,true); 
    }   
     static testmethod void m11() {
            RecordType rt = [Select Name,Id from RecordType where Name = 'Trash - Container - Solid Waste'];
            Case c = new Case(Subject='testCase',Service_Request_Type__c = 'SW New Container Request',RecordTypeId = rt.Id,Recycling_Container_QTY__c=4,Refuse_Container_QTY__c=4,Customer_Type__c='Business',New_Container_Issue__c='First Container',Payment_Most_Likely_Needed__c=TRUE,Payment_Method__c='Pay in Person',status='New',Street_Number__c='230',Street_Name__c='Lincoln st'); 
            insert c;
            Case cs = [select CaseNumber from case where id=: c.Id];
            String casNum = cs.CaseNumber;
            FormWrkCmt.updateParent(casNum,true); 
            RecordType rt1 = [Select Name,Id from RecordType where Name = 'Illegal Dumping of Debris / Stormwater Violation'];        
            Case c1 = new Case(Subject='testCase',Service_Request_Type__c = 'Illegal Dumping: City Property/Public Right of Way NEAR the curb',RecordTypeId = rt.Id,Hazardous_Materials__c='No',status='New',Street_Number__c='230',Street_Name__c='Lincoln st'); 
            insert c1; 
            Case cs1 = [select CaseNumber from case where id=: c1.Id];
            String casNum1 = cs1.CaseNumber;
            FormWrkCmt.updateParent(casNum1,true);   
    }  
    
     static testmethod void m12() {
            RecordType rt = [Select Name,Id from RecordType where Name = 'Traffic Miscellaneous Issues'];
            Case c = new Case(Subject='testCase',Service_Request_Type__c = 'Traffic Miscellaneous Issues',RecordTypeId = rt.Id,Customer_Requesting_Call_Back__c='Yes',New_Container_Issue__c='First Container',status='New',Street_Number__c='230',Street_Name__c='Lincoln st'); 
            insert c;
            Case cs = [select CaseNumber from case where id=: c.Id];
            String casNum = cs.CaseNumber;
            FormWrkCmt.updateParent(casNum,true);
            RecordType rt1 = [Select Name,Id from RecordType where Name = 'Traffic Pavement Markings and Reflector Posts'];
            Case c1 = new Case(Subject='testCase',Service_Request_Type__c = 'Traffic Pavement Markings and Reflector Posts',RecordTypeId = rt.Id,Items_to_be_Addressed__c='Street Lane Lines',Travel_Direction__c='North',status='New',Street_Number__c='230',Street_Name__c='Lincoln st'); 
            insert c1;
            Case cs1 = [select CaseNumber from case where id=: c1.Id];
            String casNum1 = cs1.CaseNumber;
            FormWrkCmt.updateParent(casNum1,true);
     } 
     
     static testmethod void m13() {
           /* Account acc = new Account(Name='test');
            insert acc;
            Contact c = new Contact(FirstName='test',AccountId=acc.Id,LastName='tester',MailingCity='Hampton',MailingState='Virginia',MailingPostalCode='23630',Email='test@ghj.com',HomePhone='8384756748',Phone='8384756748',MobilePhone='8384756748',OtherPhone='8384756748');
            insert c; */
            Case cas = new Case(Subject='testCase',Service_Request_Type__c = 'Alarms: City Offices',status='New',Lucity_Dept_Code__c='420',Lucity_Status_Code__c =10,Lucity_Public_Works_Valid__c='yes',Lucity_User1_Code__c='401',Lucity_Prob_Code__c='420-999',Street_Number__c='230',Street_Name__c='Lincoln st'); 
            insert cas;
            Case cs = [select CaseNumber from case where id=: cas.Id];
            String casNum = cs.CaseNumber;
            InsertCaseInLucity.insCase(casNum, true);
            InsertCaseInLucity.insCase(casNum, false);    
     }
     
     static testmethod void m14() {
            Case cas = new Case(Subject='testCase',Service_Request_Type__c = 'Alarms: City Offices',status='New',Lucity_Dept_Code__c='420',Lucity_Status_Code__c =10,Lucity_Public_Works_Valid__c='yes',Lucity_User1_Code__c='401',Lucity_Prob_Code__c='420-999',Street_Number__c='230',Street_Name__c='Lincoln st'); 
            insert cas;
            Case cas1 = new Case(Subject='testCase',Service_Request_Type__c = 'Alarms: City Offices',status='New',Lucity_Dept_Code__c='420',Lucity_Status_Code__c =10,Lucity_Public_Works_Valid__c='yes',Lucity_User1_Code__c='401',Lucity_Prob_Code__c='420-999',Street_Number__c='230',Street_Name__c='Lincoln st'); 
            Group que = [select name,id from Group where name = 'PW - Traffic'];
            cas.OwnerId = que.id;
            //update cas1;
            List<Case> cList = new List<Case>();
            cList.add(cas1);
            cList.add(cas);
            upsert cList;
     }   
     
      static testmethod void m15() {
            Case cas = new Case(Subject='testCase',Service_Request_Type__c = 'Alarms: City Offices',status='New',Street_Number__c='230',Street_Name__c='Lincoln st'); 
            insert cas;
            Case cas1 = new Case(Subject='testCase',ParentId=cas.Id,Service_Request_Type__c = 'Alarms: City Offices',status='New',Street_Number__c='230',Street_Name__c='Lincoln st'); 
            insert cas1;
            cas.status = 'Closed';
            update cas;
     }    
}