@isTest
public with sharing class TestBatchSyncCom {

    static testmethod void m1Com() {

        List<Case> cas = new List<Case>(); 
        for(integer i = 0; i<10; i++){
            Case c = new Case(Subject='testCase',Service_Request_Type__c = 'Alarms: City Offices',Lucity_Public_Works_Valid__c='yes',Lucity_WR_ID__c ='99999',status='New',Street_Number__c='230',Street_Name__c='Lincoln st'); 
            cas.add(c);
        }

        Test.StartTest();
        insert cas;
        BatchSyncCom sync = new BatchSyncCom();
        sync.query = 'Select id,casenumber,Lucity_public_works__c,Lucity_parks__c,Lucity_WR_Id__c from Case where Lucity_WR_Id__c != NULL and status!=\'Closed\'';
        ID batchprocessid = Database.executeBatch(sync);
        Test.StopTest();        
    }

}