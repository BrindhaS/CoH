@istest public with sharing class CaseTriggerTestfl{
    public static testmethod void testCaseTrigger()
    {
        //When a new case (First Case) is created
        case cs = new case();
        cs.Subject= 'Testing';
        cs.Origin='Phone';
        cs.Service_Request_Type__c = 'Alarms:  City Offices';
        cs.Description = 'FL Testing Triggers calls';
        cs.Status ='Open';
        cs.Lucity_Public_Works_valid__c='True';
        cs.Location_Format__c='Street Address';
        cs.Street_Name__c='LINCOLN ST';
        cs.Street_Number__c='230';
        //cs.Send_Case_Creation_Email_to_Contact__c=False;
        insert cs; 

        casecomment ccom = new casecomment ();
        ccom.commentBody = cs.Description;
        ccom.parentid = cs.id;
        insert ccom;
        
        try {
            ccom.CommentBody = 'Changed the Description 1';
            update ccom;
        }
        catch (Exception e) {
            
            Boolean exceptionThrown = e.getMessage().contains('Comments cannot be changed on cases being integrated with ...')? true : false;
            System.assertEquals(exceptionThrown, true);
        }
        
        try {
            delete ccom;
        }
        catch (Exception e) {
            
            Boolean exceptionThrown = e.getMessage().contains('Comments cannot be deleted on cases being integrated with ...')? true : false;
            System.assertEquals(exceptionThrown, true);
        }        
        //delete cs;    // deleting the case should trigger the LucityCaseValidation trigger
    }
}