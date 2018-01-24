@isTest
private class UnisysTestDataTest {
  
  static testMethod void GetTestData() {
      UnisysTestData data = new UnisysTestData('UnisysTestData');
      string aString = data.find('getPropertySchedule');
      
      Dom.Document doc = new Dom.Document();
      doc.load(aString);
      Dom.XmlNode root = doc.getRootElement();
      Dom.XmlNode dataNode = root.getChildElement('data', 'urn:schemas-microsoft-com:rowset');
        
    system.assertEquals(3, dataNode.getChildElements().size());
  }
}