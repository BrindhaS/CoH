@isTest
public class TestHamptonTriggers
{
    static testmethod void testAttachmentWrapper()
    {
        Contact c = new Contact(Lastname='TestUser123');
        insert c;
        
        Attachment a = new Attachment(ParentId=c.Id, Body=Blob.valueOf('abc'), Name='TestAttach');
        insert a;
        delete a;
    }
    
    static testmethod void testComplaintDup()
    {
        MUSW__Parcel__c p = new MUSW__Parcel__c(name='asdfasfsd');
        insert p;
        MUSW__Complaint2__c c = new MUSW__Complaint2__c(MUSW__Parcel__c=p.Id, MUSW__Type__c='TestX');
        insert c;
        MUSW__Complaint2__c c2 = new MUSW__Complaint2__c(MUSW__Parcel__c=p.Id, MUSW__Type__c='TestX', Complaint2__c=c.Id);
        insert c2;
    }
    
    static testmethod void testPermitApplicant()
    {
        Account a = new Account(Name='avbcasdasd');
        insert a;
        MUSW__Parcel__c par = new MUSW__Parcel__c(Name='xyz123abc');
        insert par;
        MUSW__Permit2__c p = new MUSW__Permit2__c(MUSW__Type__c='Building', ContractorAccount__c=a.Id, Applicant_Type__c='Contractor', MUSW__Parcel__c=par.id, Owner_Phone_Number__c='123');
        insert p;
    }
    
    static testmethod void testOccupancyPermitUpdateParent()
    {
        HamptonTriggerService.setLock();
        MUSW__Parcel__c pa = new MUSW__Parcel__c(name='asdfasfsd');
        insert pa;
        MUSW__Permit2__c p = new MUSW__Permit2__c(MUSW__Type__c = 'Building',MUSW__Parcel__c=pa.id, Owner_Phone_Number__c='123');
        insert p;
        Date d = system.today();
        MUSW__Permit2__c op = new MUSW__Permit2__c(MUSW__Type__c = 'Occupancy Certificate',Permit2__c = p.Id, MUSW__Issue_Date__c = d, MUSW__Parcel__c=pa.id);
        insert op;
        op.MUSW__Status__c = 'Issued';
        update op;
    }
    
    static testmethod void testViolationCloseInspection()
    {
        HamptonTriggerService.setLock();
        MUSW__Parcel__c par = new MUSW__Parcel__c(MUSW__Street2__c='Test St', MUSW__Street_Number__c='14B', MUSW__City__c='Testville', MUSW__Parcel_Number2__c='1000TEST400');
        insert par;
        MUSW__Violation_Type__c ord = new MUSW__Violation_Type__c(MUSW__Code_Number__c='1=234.5TEST', Name='Test Ordinance X');
        insert ord;
        MUSW__Complaint2__c com = new MUSW__Complaint2__c(MUSW__Type__c='TestTypeComp', MUSW__Origin__c='Test', MUSW__Parcel__c=par.Id);
        insert com;
        MUSW__Inspection__c ins = new MUSW__Inspection__c(MUSW__Parcel__c=par.Id, Complaint2__c=com.Id, RecordTypeId='012E0000000QU8l', MUSW__Type__c='TESTInspection');
        insert ins;
        MUSW__Violation__c v1 = new MUSW__Violation__c(MUSW__Type__c=ord.Id, MUSW__Complaint2__c=com.Id);
        MUSW__Violation__c v2 = new MUSW__Violation__c(MUSW__Type__c=ord.Id, MUSW__Complaint2__c=com.Id);
        insert new MUSW__Violation__c[]{v1, v2};
        Inspection_Violation__c iv1 = new Inspection_Violation__c(Inspection__c=ins.Id, Violation__c=v1.Id, Complaint2__c=com.Id);
        Inspection_Violation__c iv2 = new Inspection_Violation__c(Inspection__c=ins.Id, Violation__c=v2.Id, Complaint2__c=com.Id);
        insert new Inspection_Violation__c[]{iv1, iv2};
        
        v1.MUSW__Status__c = 'Closed - Corrected';
        v2.MUSW__Status__c = 'Closed - Corrected';
        update new MUSW__Violation__c[]{v1, v2};
        
        MUSW__Inspection__c insq = [select Close_Inspection__c from MUSW__Inspection__c where Id = :ins.Id];
        system.assert(insq.Close_Inspection__c == true);
    }
    
    static testmethod void testIVDeduper()
    {
        HamptonTriggerService.setLock();
        MUSW__Parcel__c par = new MUSW__Parcel__c(MUSW__Street2__c='Test St', MUSW__Street_Number__c='14B', MUSW__City__c='Testville', MUSW__Parcel_Number2__c='1000TEST400');
        insert par;
        MUSW__Violation_Type__c ord = new MUSW__Violation_Type__c(MUSW__Code_Number__c='1=234.5TEST', Name='Test Ordinance X');
        insert ord;
        MUSW__Inspection__c ins = new MUSW__Inspection__c(MUSW__Parcel__c=par.Id, RecordTypeId='012E0000000QU8l', MUSW__Type__c='Field Observation');
        insert ins;
        MUSW__Violation__c v = new MUSW__Violation__c(MUSW__Type__c=ord.Id, Parcel__c=par.Id);
        insert v;
        MUSW__Inspection__c reins1 = new MUSW__Inspection__c(MUSW__Parcel__c=par.Id, RecordTypeId='012E0000000QU8l', MUSW__Type__c='Re-inspection', MUSW__Previous_Inspection__c=ins.Id);
        insert reins1;
        MUSW__Inspection__c reins2 = new MUSW__Inspection__c(MUSW__Parcel__c=par.Id, RecordTypeId='012E0000000QU8l', MUSW__Type__c='Re-inspection', MUSW__Previous_Inspection__c=ins.Id);
        insert reins2;
        Inspection_Violation__c iv1 = new Inspection_Violation__c(Inspection__c=reins1.Id, Violation__c=v.Id, Parcel__c=par.Id);
        Inspection_Violation__c iv2 = new Inspection_Violation__c(Inspection__c=reins2.Id, Violation__c=v.Id, Parcel__c=par.Id);
        insert new Inspection_Violation__c[]{iv1, iv2};
        
        MUSW__Inspection__c[] insq = [select Id from MUSW__Inspection__c where MUSW__Previous_Inspection__c = :ins.Id];
        system.assert(insq.size() == 1);
        Inspection_Violation__c[] ivq = [select Id from Inspection_Violation__c where Inspection__r.MUSW__Previous_Inspection__c = :ins.Id];
        system.assert(ivq.size() == 1);
    }
    
    static testmethod void testHighGrassAttachment()
    {
        HamptonTriggerService.setLock();
        MUSW__Parcel__c par = new MUSW__Parcel__c(MUSW__Street2__c='Test St', MUSW__Street_Number__c='14B', MUSW__City__c='Testville', MUSW__Parcel_Number2__c='1000TEST400');
        insert par;
        MUSW__Inspection__c ins = new MUSW__Inspection__c(MUSW__Parcel__c=par.Id, MUSW__Type__c='Field Observation');
        insert ins;
        
        HamptonTriggerService.releaseLock();
        Attachment a = new Attachment(Name='High_Grass_abc', parentId=ins.Id, Body=Blob.valueOf('abc'));
        insert a;
        
        par = [select Last_High_Grass_Sent_Date__c from MUSW__Parcel__c where Id = :par.Id];
        system.assert(par.Last_High_Grass_Sent_Date__c != null);
    }
    
    static testmethod void testConditionUpdateMilestone()
    {
        MUSW__Parcel__c pa = new MUSW__Parcel__c(name='asdfasfsd');
        insert pa;
        MUSW__Permit2__c p2 = new MUSW__Permit2__c(MUSW__Type__c = 'Building',MUSW__Parcel__c=pa.id, Owner_Phone_Number__c='123');
        insert p2;
        
        MUSW__milestone__c m1 = new MUSW__milestone__c(Name='Phase 1',MUSW__Due_Date__c = date.today(),MUSW__permit2__c = p2.id);
        insert (m1);
        MUSW__milestone__c m2 = new MUSW__milestone__c(Name='Phase 2',MUSW__Due_Date__c = date.today(),MUSW__permit2__c = p2.id);
        insert (m2);
        MUSW__milestone__c m3 = new MUSW__milestone__c(Name='Phase 2',MUSW__Due_Date__c = date.today(),MUSW__permit2__c = p2.id);
        insert (m3);
        
        
        MUSW__Condition__c c1 = new MUSW__Condition__c(MUSW__Status__c ='open',MUSW__Full_Description__c='test comment1', Correction_Required__c ='test required1', Milestone__c = m1.Id);
        insert c1;
        MUSW__Condition__c c2 = new MUSW__Condition__c(MUSW__Status__c ='open',MUSW__Full_Description__c='test comment2', Correction_Required__c ='test required2', Milestone__c = m1.Id);
        insert c2;
        MUSW__Condition__c c3 = new MUSW__Condition__c(MUSW__Status__c ='open',MUSW__Full_Description__c='test comment3', Correction_Required__c ='test required3', Milestone__c = m2.Id);
        insert c3;
        MUSW__Condition__c c4 = new MUSW__Condition__c(MUSW__Status__c ='open',MUSW__Full_Description__c='test comment4', Milestone__c = m3.Id);
        insert c4;        
        
        MUSW__milestone__c mil1 = [select Current_Comments__c from MUSW__milestone__c where Id =:m1.Id];
        system.assert(mil1.Current_Comments__c != null);
        MUSW__milestone__c mil2 = [select Current_Comments__c from MUSW__milestone__c where Id =:m2.Id];
        system.assert(mil2.Current_Comments__c != null);
        MUSW__milestone__c mil3 = [select Current_Comments__c from MUSW__milestone__c where Id =:m3.Id];
        system.assert(mil3.Current_Comments__c == '1. test comment4\nCorrections: Required');
    }
    
    //test boundary for blank 
    static testmethod void testConditionUpdateMilestone1()
    {
        MUSW__Parcel__c pa = new MUSW__Parcel__c(name='asdfasfsd');
        insert pa;
        MUSW__Permit2__c p = new MUSW__Permit2__c(MUSW__Type__c = 'Building',MUSW__Parcel__c=pa.id, Owner_Phone_Number__c='123');
        insert p;
        
        MUSW__milestone__c m1 = new MUSW__milestone__c(Name='Phase 1',MUSW__Due_Date__c = date.today(),MUSW__permit2__c = p.id);
        insert (m1);
             
        MUSW__Condition__c c = new MUSW__Condition__c(MUSW__Status__c ='open',Milestone__c = m1.Id);
        insert c;
        MUSW__Condition__c c1 = new MUSW__Condition__c(MUSW__Status__c ='open',Correction_Required__c ='equired test',Milestone__c = m1.Id);
        insert c1;
        
        MUSW__milestone__c mil1 = [select Current_Comments__c from MUSW__milestone__c where Id =:m1.Id];
        system.assert(mil1.Current_Comments__c == null);       
    }
    
    static testmethod void testViolationCloseInspectionTree()
    {
        Id[] ids = new Id[]{};
        
        MUSW__Parcel__c par = new MUSW__Parcel__c(MUSW__Street2__c='East Blvd', MUSW__Street_Number__c='7777', MUSW__City__c='Vancouver', MUSW__Parcel_Number2__c='2000Test400');
        insert par;
        
        MUSW__Complaint2__c com = new MUSW__Complaint2__c(MUSW__Type__c='Multiple Issues', MUSW__Origin__c='311', MUSW__Parcel__c=par.Id);
        insert com;
        
        HamptonTriggerService.setLock();
        
        MUSW__Inspection__c ins = [select name from MUSW__Inspection__c where Complaint2__r.Id = :com.Id ];
        ids.add(ins.Id);
        
        //Branch1
        MUSW__Inspection__c reins11 = new MUSW__Inspection__c(MUSW__Parcel__c=par.Id, Complaint2__c=com.Id, RecordTypeId='012E0000000QU8l', MUSW__Type__c='Re-inspection',MUSW__Previous_Inspection__c= ins.Id);
        insert reins11;
        ids.add(reins11.Id);
        ins.MUSW__Status__c = 'Completed with open violations';
        update ins;
        
        MUSW__Inspection__c reins12 = new MUSW__Inspection__c(MUSW__Parcel__c=par.Id, Complaint2__c=com.Id, RecordTypeId='012E0000000QU8l', MUSW__Type__c='Re-inspection',MUSW__Previous_Inspection__c= reins11.Id);
        insert reins12;
        ids.add(reins12.Id); 
        reins11.MUSW__Status__c = 'Completed with open violations';
        update reins11;
          
        MUSW__Inspection__c reins13 = new MUSW__Inspection__c(MUSW__Parcel__c=par.Id, Complaint2__c=com.Id, RecordTypeId='012E0000000QU8l', MUSW__Type__c='Re-inspection',MUSW__Previous_Inspection__c = reins12.Id);
        insert reins13;
        ids.add(reins13.Id);
        reins12.MUSW__Status__c = 'Completed with open violations';
        update reins12;
         
           
        //Branch 2
        MUSW__Inspection__c reins21 = new MUSW__Inspection__c(MUSW__Parcel__c=par.Id, Complaint2__c=com.Id, RecordTypeId='012E0000000QU8l', MUSW__Type__c='Re-inspection',MUSW__Previous_Inspection__c = ins.Id);
        insert reins21;
        ids.add(reins21.Id);
        
        MUSW__Inspection__c reins22 = new MUSW__Inspection__c(MUSW__Parcel__c=par.Id, Complaint2__c=com.Id, RecordTypeId='012E0000000QU8l', MUSW__Type__c='Re-inspection',MUSW__Previous_Inspection__c= reins21.Id);
        insert reins22;
        ids.add(reins22.Id); 
        reins21.MUSW__Status__c = 'Completed with open violations';
        update reins21;
          
        MUSW__Inspection__c reins23 = new MUSW__Inspection__c(MUSW__Parcel__c=par.Id, Complaint2__c=com.Id, RecordTypeId='012E0000000QU8l', MUSW__Type__c='Re-inspection',MUSW__Previous_Inspection__c = reins22.Id);
        insert reins23;
        ids.add(reins23.Id);
        reins22.MUSW__Status__c = 'Completed with open violations';
        update reins22;
        
        HamptonTriggerService.releaseLock();
        //Check if the ins Inspection_Chain_Closed__c = false
        MUSW__Inspection__c insBefore = [select Inspection_Chain_Closed__c from MUSW__Inspection__c where Id = :ins.Id ]; 
        system.assert(insBefore.Inspection_Chain_Closed__c == false);
        
        //Close one leaf
        reins13.MUSW__Status__c = 'Closed';
        update reins13;
        MUSW__Inspection__c[] insClosedOneLeaf = [select IsClosed__c, Inspection_Chain_Closed__c from MUSW__Inspection__c where Id in:ids and Inspection_Chain_Closed__c = true]; 
        
        system.debug('###inspections '+insClosedOneLeaf);
        system.assert(insClosedOneLeaf.size()==3, 'size: '+insClosedOneLeaf.size());
        
        //Close both leaves
        reins23.MUSW__Status__c = 'Closed';
        update reins23;
        MUSW__Inspection__c[] insClosedBoth = [select Inspection_Chain_Closed__c from MUSW__Inspection__c where Id in:ids and Inspection_Chain_Closed__c = true]; 
        
        //system.debug('###inspections '+insClosedBoth);
        system.assert(insClosedBoth.size()==7, 'size: '+insClosedBoth.size());
    }
}