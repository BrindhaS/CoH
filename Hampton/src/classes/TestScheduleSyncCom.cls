@isTest
private class TestScheduleSyncCom {
    static testmethod void testSyncCom() {

        Test.StartTest();       
        List<Case> cas = new List<Case>(); 
        for(integer i = 0; i<10; i++){
            Case c = new Case(Service_Request_type__c = 'Alarms/City Offices');
            cas.add(c);
        }
        String CRON_EXP = '0 0 23 * * ?'; 

        insert cas;
        ScheduleDailySyncCom sync = new ScheduleDailySyncCom();

        // Schedule the test job
        String jobId = System.schedule('testScheduledApex', CRON_EXP,sync);

        // Get the information from the CronTrigger API object
                CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

        // Verify the expressions are the same    
        System.assertEquals(CRON_EXP, ct.CronExpression);
                System.assertEquals(0, ct.TimesTriggered);
               // System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));
               

        Test.StopTest();
    }

}