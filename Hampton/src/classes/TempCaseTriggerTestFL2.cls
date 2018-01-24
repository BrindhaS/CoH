@istest 
public class TempCaseTriggerTestFL2 {
    static testmethod void testCaseTrigger() {
        
        test.startTest();
        Case c = new Case(Subject='testCase1',
                          Service_Request_Type__c = 'Miscellaneous:  Action Needed',
                          Lucity_Public_Works_Valid__c='yes',
                          status='New',
                          Street_Number__c='230',
                          Street_Name__c='Lincoln st');
        insert c;
        
        Case cas = new Case(Subject='testCase2',
                            Service_Request_Type__c = 'Alarms:  City Offices',
                            Lucity_User1_Type_Main__c ='Alarms: City Offices',
                            Lucity_Public_Works_Valid__c='yes',
                            status='New',
                            Street_Number__c='230',
                            Street_Name__c='Lincoln st');
        
        insert cas;  
        
        cas.parentId=c.id;
        cas.Lucity_WR_ID__c = '99999';
        update cas;
             
        //cas.status = null;
       // cas.Send_Case_Creation_Email_to_Contact__c = false;
        //cas.Parent_Case_Type__c = null;
        CaseFieldUpdate.inLucityFutureContext = false;
        //OldCase.Lucity_Status_code__c = NewCase.Lucity_Status_code__c  
        //OldCase.Lucity_Status_type__c = NewCase.Lucity_Status_type__c
        
        Try {
            update cas;
            }
        Catch(Exception ex) {
            //Assert Error Message
            System.assert(ex.getMessage().contains('Only field that can be changed on cases being integrated with Lucity is Parent Case.'),
                ex.getMessage() );
            }  

        Case cs = [select CaseNumber, Lucity_User1_Type__c,Lucity_User1_Type_Main__c, Lucity_User1_Type1__c from case where id=: cas.Id];
        String casNum = cs.CaseNumber;
        
        Try {
            update cas;
            }
        Catch(Exception ex) {
            //Assert Error Message
            System.assert(ex.getMessage().contains('Only field that can be changed on cases being integrated with Lucity is Parent Case.'),
                ex.getMessage() );
            }
         FormWrkCmt.updateParent(casNum,true); 
        //CaseFieldUpdate.inLucityFutureContext = true;
       // System.assertEquals(CaseFieldUpdate.inLucityFutureContext,true);
        
        test.stopTest();
        
        CaseFieldUpdate.inLucityFutureContext = false;
        System.assertEquals(CaseFieldUpdate.inLucityFutureContext,false);
        
        FormWrkCmt.updateParent(casNum,false);
        //System.assertEquals(casNum, cs.CaseNumber);
        
        }
}
       
          //  cs.Send_Case_Creation_Email_to_Contact__c=False;
         // NewCase.addError('Only field that can be changed on cases being integrated with Lucity is Parent Case.');