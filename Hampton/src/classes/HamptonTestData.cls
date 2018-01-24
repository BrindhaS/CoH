public with sharing class HamptonTestData {
    public HamptonTestData()
    {
        data = new UnisysTestData('HamptonTestData');        
    }
    
    public ESRI_Config__c esriConfig()
    {
        ESRI_Config__c aConfig = new ESRI_Config__c(
            name = 'Default', 
            locator__c = 'https://ignore/me', 
            layer__c = 'ignore;me'
        );
        
        insert aConfig;
        aConfig = ESRI_Config__c.GetInstance(aConfig.name);
        system.assertNotEquals(null, aConfig, 'Unable to create then retrieve custom setting.');
        return aConfig;     
    }
    
    public void threeCases()
    {
        string format = data.find('ThreeCases');
        
        list<Case> aList = (list<Case>) JSON.deserialize(format, list<Case>.class);
        
        insert aList;        
    }
    
    public void threeContacts()
    {
        string format = data.find('ThreeContacts');
        
        list<Contact> aList = (list<Contact>) JSON.deserialize(format, list<Contact>.class);
        
        insert aList;        
    }
    
    UnisysTestData data;
}