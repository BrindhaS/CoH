@isTest
public with sharing class CaseTest {
    static testMethod void testInsertCase(){
        HamptonTestData testData = new HamptonTestData();
        testData.esriConfig();

        case testCase = new Case(Street__c='150 dexter ct.');
        
        insert testCase;
        
        //This is actually assigned in a future method
        //system.assertNotEquals(null, testCase.Address_X__c);
        //system.assertNotEquals(null, testCase.Address_Y__c);
        
        
    }
    
    static testMethod void testGeocodeBlankId(){
        HamptonTestData testData = new HamptonTestData();
        testData.esriConfig();
        
        CaseModel.Geocode('', 'test'); //empty id
        CaseModel.Geocode('test', ''); //empty address
    }
}