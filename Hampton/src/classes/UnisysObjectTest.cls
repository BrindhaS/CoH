@isTest
private class UnisysObjectTest {
  class TestObject extends UnisysObject {
    
  }

    static testMethod void messageTest()
    {
      TestObject xo = new TestObject();
      
      system.assertEquals(0, ApexPages.getMessages().size());
      
      xo.addInfoMessage('{0}', 1);
      system.assertEquals(1, ApexPages.getMessages().size());
      system.assert(ApexPages.getMessages()[0].getDetail().startsWith('Class.UnisysObjectTest.'));
      
      system.assertEquals('1', xo.addInfoMessage('{0}', 1));
      system.assertEquals('1,2', xo.addInfoMessage('{0},{1}', 1, 2));
      system.assertEquals('1,2,3', xo.addInfoMessage('{0},{1},{2}', 1, 2, 3));
    }
    
    static testMethod void dependentTest()
    {
      TestObject xo1 = new TestObject();
      TestObject xo2 = new TestObject();
      
      system.assertEquals(0, xo1.getDependents().size());
      xo1.addDependent(xo2);
      system.assertEquals(1, xo1.getDependents().size());
      xo1.removeDependent(xo2);
      system.assertEquals(0, xo1.getDependents().size());
    }
    
    static testMethod void convenienceMethodsTest()
    {
      TestObject xo = new TestObject();
      
      system.assertEquals('\'test\'', xo.singleQuote('test'));
      system.assertEquals('two', xo.coalesce((string) null, 'two'));      
    }
    
    static testMethod void coalesceTest()
    {
      TestObject xo = new TestObject();
      
      system.assertEquals(Date.Today(), xo.coalesce(Date.Today(), Date.Today().addDays(1)));
      system.assertEquals(Date.Today(), xo.coalesce(null, Date.Today()));
      
      system.assertEquals('Hello', xo.coalesce('Hello', 'World'));
      system.assertEquals('World', xo.coalesce((string) null, 'World'));
      system.assertEquals('Neither', xo.coalesce(null, null, 'Neither'));
      
      system.assertEquals(1.0, xo.coalesce(1.0, 2.0));
      system.assertEquals(2.0, xo.coalesce(null, 2.0));
    }
}