public with sharing class CartSearchController
{   
    public Cart__c[] carts { get; set; }
    public Account_Contact__c virtualObj { get; set; }
    public String cartNumber { get; set; }
    private String cartFields;
    private DateTime dtNow;
    
    public CartSearchController()
    {
        virtualObj = new Account_Contact__c();
        List<Schema.FieldSetMember> fsFields = Schema.SObjectType.Cart__c.fieldSets.CartSearch.getFields();
        cartFields = 'Id';
        for (Schema.FieldSetMember fs : fsFields)
        {
            if (!cartFields.toLowerCase().contains(fs.getFieldPath().toLowerCase()))
                cartFields += ', ' + fs.getFieldPath();
        }
        dtNow = system.now();
        carts  = database.query('select ' + cartFields + ' from Cart__c where Process_DateTime__c = null and Expiration_DateTime__c > :dtNow and Fee_Total__c >0');
    }
    
    public void search()
    {
        if (virtualObj.Contact__c != null)
        {
            Contact c = [select Id, AccountId, (select Account__c from Account_Contacts__r) from Contact where Id=:virtualObj.Contact__c];
            Id[] aIds = new Id[]{c.AccountId};
            dtNow = system.now();
            for (Account_Contact__c ac : c.Account_Contacts__r)
            {
                aIds.add(ac.Account__c);
            }           
            carts  = database.query('select ' + cartFields + ' from Cart__c where Process_DateTime__c = null and Expiration_DateTime__c > :dtNow and Fee_Total__c >0 and Account__c in:aIds');
        }
        else if (cartNumber != null || cartNumber != '')
        {            
            carts  = database.query('select ' + cartFields + ' from Cart__c where Process_DateTime__c = null and Expiration_DateTime__c > :dtNow and Fee_Total__c >0 and Name =: cartNumber');
        }
        else
        {
            carts  = database.query('select ' + cartFields + ' from Cart__c where Process_DateTime__c = null and Expiration_DateTime__c > :dtNow and Fee_Total__c >0');
        }
    }
    
    public pageReference cancel()
    {
        pageReference pr = new pageReference('/home/home.jsp');
        pr.setRedirect(true);
        return pr;
    }
    
    @isTest(seeAllData=true)
    private static void testController()
    {
        BGBK.RulesEngineState.setLock();
        
        Contact c = new Contact(FirstName='First',LastName='LastName', email='productrelease@basicgov.com');
        insert c;
        Contact cq = [select AccountId from Contact where Id = :c.Id];
        
        Cart__c cart = new Cart__c(Name='System Number', Fee_Total__c=120, Account__c=cq.AccountId);
        
        /*MUSW__Permit2__c perm = new MUSW__Permit2__c(MUSW__Type__c='Building', MUSW__Parcel__c=par.Id);
        insert perm;
        MUSW__Submission__c s = new MUSW__Submission__c(MUSW__Permit2__c=perm.Id);
        insert s;*/
        
        BGBK.RulesEngineState.releaseLock();
        
        pageReference p = Page.CartSearch;
        Test.setCurrentPage(p);
        
        CartSearchController csc = new CartSearchController();
        csc.virtualObj.Contact__c = c.Id;
        csc.search();
        csc.cancel();
    }
}