@isTest
private class UnisysControllerTest {

    static testMethod void messageTest() {
      PageReference pg = Page.blank;
      Test.setCurrentPage(pg);
      
        UnisysController xc = new UnisysController();
        
        system.assertEquals(false, xc.getHasMessages());
        
        List<UnisysController.SimpleMessage> aList = xc.getApexMessages();
        system.assertEquals(0, aList.size());
        
        xc.addErrorMessage('Error');
        aList = xc.getApexMessages();
        system.assertEquals(1, aList.size());
        
        xc.addInfoMessage('Info');
        aList = xc.getApexMessages();
        system.assertEquals(1, aList.size());
        
        xc.setCookie(pg, 'DEBUG', '');
        aList = xc.getApexMessages();
        system.assertEquals(2, aList.size());
        
        for (UnisysController.SimpleMessage each : aList) {
          system.assertEquals(each.getSummary(), each.getDetail());
          system.assertNotEquals(null, each.getSeverity());
      }
      
      system.assertEquals(true, xc.getHasMessages());
    }
    
    static testMethod void redrawTest() {
      PageReference pg = Page.blank;
      pg.getParameters().put('test', 'value');
      Test.setCurrentPage(pg);
      
        UnisysController xc = new UnisysController();
        
        PageReference newPg = xc.redrawCurrentPage();
        system.assertEquals(1, newPg.getParameters().size());
        system.assertEquals('value', newPg.getParameters().get('test'));  
        
        xc.addWarningMessage('warn');
        system.assertEquals(null, xc.redrawCurrentPage(), 'no redraw if messages exist');      
    }
    
    static testMethod void extensionTest() {
      PageReference pg = Page.blank;
      Test.setCurrentPage(pg);
      
        UnisysController xc = new UnisysController();
        UnisysController xcx = new UnisysController(xc);
        
        system.assertNotEquals(null, xcx);
    }
}