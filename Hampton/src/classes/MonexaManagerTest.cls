@isTest(seeAllData=true)
public class MonexaManagerTest
{
    @isTest(seeAllData=true)
    static void testMonexaManager()
    {
        Account a = new Account(Name = 'basicgovTest');
        insert a;
        MonexaManager mm = new MonexaManager(a.Id);
        String monexaid = mm.monexaAccountId;
        MonexaManager.getMessage('Error');
    }
}