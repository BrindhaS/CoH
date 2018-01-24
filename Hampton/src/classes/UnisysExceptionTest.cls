@isTest
private class UnisysExceptionTest {
    
    static testMethod void testOneArg() {
        try {
            UnisysException.Raise('one {0}', 'two');
        }
        catch (UnisysException ex)
        {
            System.assertEquals('one two', ex.getMessage());
        }
    }
    
    static testMethod void testTwoArgs() {
        try {
            UnisysException.Raise('one {0} {1}', 'two', 'three');
        }
        catch (UnisysException ex)
        {
            System.assertEquals('one two three', ex.getMessage());
        }
    }
    
    static testMethod void testThreeArgs() {
        try {
            UnisysException.Raise('one {0} {1} {2}', 'two', 'three', 'four');
        }
        catch (UnisysException ex)
        {
            System.assertEquals('one two three four', ex.getMessage());
        }
    }
    
    static testMethod void testFourArgs() {
        try {
            UnisysException.Raise('one {0} {1} {2} {3}', 'two', 'three', 'four', 'five');
        }
        catch (UnisysException ex)
        {
            System.assertEquals('one two three four five', ex.getMessage());
        }
    }
    
    static testMethod void testDivideByZero()
    {
        try {
            integer top = 10;
            integer bottom = 0;
            
            integer result = top / bottom;
        }
        catch (Exception ex) {      
            try {
                UnisysException.Raise('test exception', ex);
                System.assert(false, 'should have thrown exception');
            }
            catch (UnisysException ax) {
                System.assertEquals('test exception', ax.GetMessage());
                System.assertEquals('Divide by 0', ax.getCause().GetMessage());
            }
        }
    }
}