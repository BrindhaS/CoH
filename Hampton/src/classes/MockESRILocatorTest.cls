@isTest
public with sharing class MockESRILocatorTest {
    static testMethod void testMockmethods(){
        HamptonTestData testData = new HamptonTestData();
        testData.esriConfig();
        
        MockESRILocator mockInstance = MockESRILocator.NewInstance();
        MockESRILocator mockInstance2 = MockESRILocator.NewInstance('Default');

    }
}