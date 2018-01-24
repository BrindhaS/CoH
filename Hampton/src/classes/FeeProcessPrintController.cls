public with sharing class FeeProcessPrintController
{
    public Cart__c cart { get; set; }
    public String emailAddress { get; set; }   
    public MUSW__Fee__c[] fees { get; set; }
    public MUSW__Receipt__c[] rs { get; set; }
    
    public FeeProcessPrintController()
    {
        Id cartId = System.currentPageReference().getParameters().get('cartId');
        emailAddress = System.currentPageReference().getParameters().get('email');           
       
        if (cartId != null)
        {
            List<Schema.FieldSetMember> fsFields = Schema.SObjectType.MUSW__Fee__c.fieldSets.BGBK__Fee_Basic.getFields();
            String feeFields = 'Id, MUSW__Permit2__c, MUSW__Amount__c, MUSW__Type__c, MUSW__Outstanding_Fee__c, MUSW__Amount_Paid__c';        
            for (Schema.FieldSetMember fs : fsFields)
            {
                if (!feeFields.toLowerCase().contains(fs.getFieldPath().toLowerCase()))
                    feeFields += ', ' + fs.getFieldPath();
            }
            DateTime dtNow = system.now();
            cart = database.query('SELECT Process_DateTime__c, Fee_Total__c, Account__c, (SELECT MUSW__Amount_Tendered__c,MUSW__Payment_Method__c,Card_Number__c,MUSW__Payment_Gateway_Transaction_Number__c FROM Receipts__r) ,(select ' + feeFields + ' from Fees__r) FROM Cart__c where Id= \'' + cartId + '\'');
            fees = cart.Fees__r;
            rs = cart.Receipts__r;
         }
    }
    
    @isTest(seeAllData=true)
    private static void testController()
    {
        Contact c = new Contact(Lastname='TestUser56456', Email='abc@safagve.com');
        insert c;
        
        // get Account Id from contact as next query ,so the accountId = cq.AccountId
        Contact cq = [select Id, AccountId from Contact where Id=:c.Id];
        
        Cart__c testCart = new Cart__c(Account__c = cq.AccountId, Contact__c = cq.Id , Name = 'System Number');
        insert testCart;
        String emailAddress = 'test@gamail.com';      
        
        pageReference fp = Page.FeeProcessPrint;
        fp.getParameters().put('cartId',  testCart.Id );
        fp.getParameters().put('email',  emailAddress );
        Test.setCurrentPage(fp);
        
        FeeProcessPrintController fc = new FeeProcessPrintController();        
    }
}