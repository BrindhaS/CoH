/*
execute the following in an anonymous block for Elgin

ESRILocator aHelper = new ESRILocator('https://www.cityofelgin.com/arcgis/rest/services/LXElginGeocoder/GeocodeServer');
system.debug(aHelper.findAddressCandidates('150 dexter ct., elgin, il 60120'));
system.debug(aHelper.findAddressCandidates('3435', '150 dexter ct., elgin, il  60120'));

ESRILocator aHelper = new ESRILocator('http://tasks.arcgisonline.com/arcgis/rest/services/Locators/TA_Address_NA_10/GeocodeServer');
system.debug(aHelper.findAddressCandidates('150 dexter ct., elgin, il 60120'));

It may also be instructive to try the google geolocating service.
http://maps.googleapis.com/maps/api/geocode/json?address=50+w+big+beaver,+troy,+mi++48084&sensor=false
*/

@isTest
private class ESRILocatorTest {

    static testMethod void creationTest() {
        HamptonTestData testData = new HamptonTestData();
        testData.esriConfig();
        
        system.assertNotEquals(null, ESRILocator.NewInstance());
        system.assertNotEquals(null, ESRILocator.NewInstance('Default'));
    }
    
    static testMethod void findAddressTest() {
        HamptonTestData testData = new HamptonTestData();
        testData.esriConfig();
        
        ESRILocator.FindAddressResponse response = ESRILocator.FindAddress('150 dexter ct, elgin, il  60120');
        system.assertEquals(false, response.isEmpty());
        system.assertNotEquals(0, response.size());
        system.assertNotEquals(null, response.spatialReference);
        system.assertNotEquals(null, response.candidates);
        
        ESRILocator mockLocator = ESRILocator.newInstance();
        
        ESRILocator.FindAddressResponse response2 = mockLocator.findAddressCandidates('150 dexter ct', 'elgin', 'il', '60120', 'US');
        system.assertEquals(false, response.isEmpty());
        system.assertNotEquals(0, response.size());
        system.assertNotEquals(null, response.spatialReference);
        system.assertNotEquals(null, response.candidates);      
    }
    
    static testMethod void testServices(){
        HamptonTestData testData = new HamptonTestData();
        testData.esriConfig();
        
        ESRILocator mockLocator = ESRILocator.newInstance();
        system.assertNotEquals(null, mockLocator.services());
    }
}