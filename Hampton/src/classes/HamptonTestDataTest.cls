@isTest
private class HamptonTestDataTest {

    static testMethod void myUnitTest() {
        UnisysTestData testData = new UnisysTestData('HamptonTestData');
        string csv = testData.find('ExtraContacts');
        system.assertNotEquals(null, csv);
        
        list<string> lines = csv.split('\n');
        system.assertEquals(23, lines.size());
        
        list<Contact> contactList = new list<Contact>();
        list<string> fields;
        
        for (string each : lines)
        {
            list<string> pieces = each.split(',');
            if (fields == null) {
                fields = pieces;
                continue;
            }
            
            system.assertEquals(fields.size(), pieces.size(), 'Bad number of fields in ' + pieces);
            
            Contact aContact = new Contact();
            for (integer i = 0; i < fields.size(); i++)
            {
                if (fields[i].startsWith('^') == false)
                    aContact.put(
                        fields[i].trim(), 
                        pieces[i].trim()
                    );
            }
            contactList.add(aContact);
        }

        /*insert contactList;
        for (Contact each : contactList)
            system.assertNotEquals(null, each.id); 
        
        contactList = [ select id, name from contact ];
        system.assertEquals(22, contactList.size()); */      
    }
    
    static testMethod void configTest() {
        HamptonTestData testData = new HamptonTestData();       
        ESRI_Config__c aConfig = testData.esriConfig();
        system.assertNotEquals(null, aConfig.Locator__c);
        system.assertNotEquals(null, aConfig.Layer__c);
    }
    
    static testMethod void testData(){
        HamptonTestData testData = new HamptonTestData();       
        ESRI_Config__c aConfig = testData.esriConfig();
        
        testData.threeCases();
        list<Case> threeCases = [select id from Case];
        system.assertEquals(3, threeCases.size());
        
     //   testData.threeContacts();
     //   list<Contact> threeContacts = [select id from Contact];
     //   system.assertEquals(3, threeContacts.size());
    }
}