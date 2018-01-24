@isTest
public with sharing class CaseGeocodeControllerTest {

    static testMethod void testGetRecentCases(){
        HamptonTestData testData = new HamptonTestData();
        testData.esriConfig();
        
        testData.threeCases();
        list<Case> threeCases = [select id, CaseNumber from Case];
        system.assertEquals(3, threeCases.size());

        list<Case> caseList = CaseGeocodeController.GetRecentCases(10, threeCases[0].id);
        
        system.assertEquals(2, caseList.size());
    }

    static testMethod void testRelateAndClose(){
        HamptonTestData testData = new HamptonTestData();
        testData.esriConfig();
        
        system.assertEquals('Both old and new cases were not found.', CaseGeocodeController.RelateCaseAndClose(null, null));
        
        testData.threeCases();
        list<Case> threeCases = [select id, CaseNumber from Case];
        system.assertEquals(3, threeCases.size());
        
        string result = CaseGeocodeController.RelateCaseAndClose(threeCases[0].Id, threeCases[1].Id);
        
        Case childCase = [select id, status, reason, parentId, CaseNumber from Case where Id = :threeCases[1].Id];
        
        system.assertEquals('Closed', childCase.status);
        system.assertEquals('Duplicate', childCase.reason);
        system.assertEquals(threeCases[0].Id, childCase.parentId);
        
        system.assertEquals('Made ' + threeCases[0].caseNumber + ' parent and closed ' + childCase.caseNumber + '.', result);
        
    }
    
    static testMethod void testAddressGeocode(){
        HamptonTestData testData = new HamptonTestData();
        testData.esriConfig();
        
        testData.threeCases();
        list<Case> threeCases = [select id, CaseNumber, Street__c from Case];
        system.assertEquals(3, threeCases.size());
        
        threeCases[0].Street__c = '150 dexter ct';
        threeCases[1].Street__c = null;
        
        update threeCases;

        threeCases = [select id, CaseNumber, Street__c from Case];

        system.assertEquals('150 dexter ct', threeCases[0].Street__c);
        system.assertEquals(null, threeCases[1].Street__c);

        system.assertNotEquals(null, CaseGeocodeController.AddressGeocode(threeCases[0].Id, ''));
        //threeCases[1] has no street address, so we expect this to return null
        system.assertEquals(null, CaseGeocodeController.AddressGeocode(threeCases[1].Id, ''));
    }
    
    static testMethod void testCaseGeocodeController(){
        HamptonTestData testData = new HamptonTestData();
        testData.esriConfig();
        
        PageReference ref = Page.Blank;
        CaseGeocodeController controller = new CasegeocodeController(new ApexPages.StandardController(new Case()));
        
        controller.geocode();
        controller.getName();
        
        Test.SetCurrentPage(ref);
    }
}