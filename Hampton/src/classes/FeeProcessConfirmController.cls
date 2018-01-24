public with sharing class FeeProcessConfirmController
{
    public String processResultCode { get; set; }
    public MUSW__Receipt__c[] rs;
    public Cart__c c { get; set; }
    public MUSW__Fee__c[] fs { get; set; }
    public String email { get; set; }
    public String processStatus { get; private set; }
    public String confirmMsg { get; private set; }    
    private String feeFields;
    
    public void setRs(MUSW__Receipt__c[] recs)
    {        
        rs = recs;
        if (rs != null)
        {
            //cart = [SELECT Fee_Total__c, Account__r.Name, (SELECT MUSW__Amount_Tendered__c,MUSW__Payment_Method__c FROM Receipts__r) ,(select id, MUSW__Amount__c, MUSW__Type__c, CreatedById, CreatedDate, MUSW__Outstanding_Fee__c, MUSW__Amount_Paid__c from Fees__r) FROM Cart__c where Id=:cart.Id];
            
            Boolean allSuccess = true;
            Boolean hasCC = false;
            for (MUSW__Receipt__c r : rs)
            {
	            if (r.Card_Number__c != null)
	            {
	            	hasCC = true;
	                if (r.MUSW__Payment_Gateway_Transaction_Number__c == null)
	                {
	                    allSuccess = false;
	                }
	            }
            }
            
            if (allSuccess)
            {
            	processStatus = 'Successful';
            	confirmMsg = 'Your payment was successful.';
            	if (hasCC && email != null)
                {
                    confirmMsg  += '\nA copy of the receipt has been sent to your inbox ' + email + '.';
                    //MUSW.UtilityEmail.sendEmail('Payment_Receipt', con.Id, cart.Id);                
                }
            }
            else
            {
            	processStatus = 'Failed';
            	confirmMsg = 'There was an error processing your payment: '+ MonexaManager.getMessage(processResultCode) + '.';
            }
        }
    }
    
    public MUSW__Receipt__c[] getRs()
    {
        return rs;
    }
    
    @isTest(seeAllData=true)
    private static void testController()
    {
        MUSW__Receipt__c rec = new MUSW__Receipt__c(Card_Number__c='****0004',MUSW__Payment_Gateway_Transaction_Number__c='12345');
        String confirmMsg ='test';
        String processStatus ='successful';
        String email = 'test@basicgov.com';
        FeeProcessConfirmController fc = new FeeProcessConfirmController();
        fc.setRs(new MUSW__Receipt__c[]{rec});
        fc.getRs();
    }
    
    @isTest(seeAllData=true)
    private static void testController1()
    {
        MUSW__Receipt__c rec = new MUSW__Receipt__c();
        String confirmMsg ='test';
        String processStatus ='successful';
        String email;
        FeeProcessConfirmController fc = new FeeProcessConfirmController();
        fc.setRs(new MUSW__Receipt__c[]{rec});
        fc.getRs();
    }
}