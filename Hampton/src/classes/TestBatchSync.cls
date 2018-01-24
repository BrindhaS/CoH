@isTest
public with sharing class TestBatchSync {

    static testmethod void m1() {

        List<Case> ca = new List<Case>();
        for(integer i = 0; i<10; i++){
            Case c = new Case(Subject='testCase',Service_Request_Type__c = 'Alarms: City Offices',Lucity_Public_Works_Valid__c='yes',Lucity_WR_ID__c ='99999',status='New',Street_Number__c='230',Street_Name__c='Lincoln st'); 
            ca.add(c);
        }

        Test.StartTest();
        insert ca;
        BatchSync sync = new BatchSync();
        sync.query =  'Select Id,CaseNumber,status,Lucity_Public_Works__c,Lucity_Parks__c,Lucity_WR_ID__c from case where Lucity_WR_ID__c != NULL';
        ID batchprocessid = Database.executeBatch(sync);
        Test.StopTest();        
    }

}