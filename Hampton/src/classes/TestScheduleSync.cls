@isTest
private class TestScheduleSync {
    static testmethod void testSync() {

        Test.StartTest();
        List<Case> ca = new List<Case>();
        for(integer i = 0; i<10; i++){
            Case c = new Case(Subject='testCase',Service_Request_Type__c = 'Alarms: City Offices'); 
            ca.add(c);
        }

        String CRON_EXP = '0 0 23 * * ?'; 

        insert ca;
        scheduleDailySync sync = new scheduleDailySync();

        // Schedule the test job
        String jobId = System.schedule('testBasicScheduledApex', CRON_EXP,sync);

        // Get the information from the CronTrigger API object
                CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

        // Verify the expressions are the same    
        System.assertEquals(CRON_EXP, ct.CronExpression);
                System.assertEquals(0, ct.TimesTriggered);
               // System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));
               

        Test.StopTest();
    }

}