public with sharing class FeeProcessController
{
    public MUSW__Fee__c[] fees { get; set; }
    public MUSW__Receipt__c[] rs { get; set; }
    public Account a { get; set; }
    public Contact con { get; set; }
    public String activeTab { get; set; }
    public Decimal totalOwed { get; set; }
    public String confirmMsg { get; set; }
    public String parentLabel { get; private set; }
    public String trackNo { get; private set; }
    public Cart__c cart { get; set; }
    public string monexaSessionKey { get; set; }
    public boolean processSuccessful { get; set; }
    public String processResult { get; set; }
    public String processResultCode { get; set; }
    public string transactionId { get; set; }
    public String processStatus { get; private set; }
    public String cardMasked { get; set; }   
    public String accountSelected { get; set; }
    public Id feeSelected { get; set; }
    public Boolean canCreate { get; private set; }
    private IPaymentGateway gateway;
    private Sobject parent;
    private Id pid;
    private Id cartId;
    private String parentName;
    private MUSW__Fee__c[] selectedFees;
    private Account[] accountList;
    private String feeFields;
    private Cart__c[] carts;
    private List<Schema.FieldSetMember> fsFields;
    
    public FeeProcessController(ApexPages.StandardSetController c)
    {
        processSuccessful = false;
        activeTab = 'fees';
        totalOwed = 0;
        canCreate = BGBK__Payment__c.SobjectType.getdescribe().iscreateable();
        
        pid = System.currentPageReference().getParameters().get('id');
        if (pid != null)
        {
            pid = String.escapeSingleQuotes(pid);            
            Schema.Describesobjectresult ds = ((Id)pid).getSObjectType().getDescribe();            
            parentName = ds.getName();
            parentLabel = ds.getLabel();
            selectedFees = new MUSW__Fee__c[]{};                        
            
            for (MUSW__Fee__c f : (List<MUSW__Fee__c>)c.getSelected())
            {
                selectedFees.add(f);
            }
        }
        
        cartId = System.currentPageReference().getParameters().get('cartId');
        if (cartId != null) cartId = String.escapeSingleQuotes(cartId);       
    }
    
    public void initOrder()
    {
        // donot run if coming from Monexa
        if (pid == null && cartId == null && !UserInfo.getUserType().contains('CustomerSuccess')) return;
        
        // get fieldset for fees
        fsFields = Schema.SObjectType.MUSW__Fee__c.fieldSets.BGBK__Fee_Basic.getFields();
        feeFields = 'Id, MUSW__Permit2__c, MUSW__Complaint2__c, MUSW__Application2__c, MUSW__Amount__c, MUSW__Type__c, MUSW__Outstanding_Fee__c, MUSW__Amount_Paid__c, Cart__c, Cart__r.OwnerId, Cart__r.Process_DateTime__c, Cart__r.Expiration_DateTime__c';        
        for (Schema.FieldSetMember fs : fsFields)
        {
            if (!feeFields.toLowerCase().contains(fs.getFieldPath().toLowerCase()))
                feeFields += ', ' + fs.getFieldPath();
        }
        
        Boolean feeInOtherOwnerCart = false; // check if this selected fee is in other owner cart        
        
        if (pid != null)
        {             
            // get account and contact 
            String applicantApi = (parentName == 'MUSW__Complaint2__c') ? 'MUSW__Primary_Contact__r' : 'MUSW__Applicant__r';
            parent = database.query('select Id, Name, ' + applicantApi.replace('__r', '__c') + ', ' + applicantApi + '.Name, ' + applicantApi + '.FirstName, ' + applicantApi + '.LastName, ' + applicantApi + '.Phone, ' + applicantApi + '.Fax, ' + applicantApi + '.MUSW__DBA_Name__c, ' + applicantApi + '.MUSW__Confidential__c, ' + applicantApi + '.email, ' + applicantApi + '.MailingStreet, ' + applicantApi + '.MailingCity, ' + applicantApi + '.MailingState, ' + applicantApi + '.MailingPostalCode, ' + applicantApi + '.MailingCountry, ' + applicantApi + '.Account.Name, ' + applicantApi + '.Account.billingStreet, ' + applicantApi + '.Account.billingCity, ' + applicantApi + '.Account.billingState, ' + applicantApi + '.Account.billingCountry, ' + applicantApi + '.Account.billingPostalCode from ' + parentName + ' where id = :pid');
            trackNo = String.valueOf(parent.get('Name'));
            String applicantId = (String)parent.get(applicantApi.replace('__r', '__c'));           
            if (parent.getSObject(applicantApi) == null)
            {
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Applicant or Contact required. Return back to prior page to fill in.');
                 ApexPages.addMessage(myMsg);
                 return;
            }
            con = (Contact)parent.getSObject(applicantApi);           
            if (con == null) con = new Contact();            
            // replace Citizen
            a = MUSW.Associate.getPersonAccount(con, null, true, false);
            
            // get selected fees that are not in cart 
            Id[] selIds = new Id[]{};
            for (Integer i=selectedFees.size()-1; i>=0; i--)
            {
                selIds.add(selectedFees[i].Id);
            }
            
            // query all fees from selected
            fees = database.query('select ' + feeFields + ' from MUSW__Fee__c where MUSW__Outstanding_Fee__c > 0 and Id in :selIds');

            // filter out the fees that are already in an open unexpired cart
            for (Integer i=0; i< fees.size(); i++)
            {
                if (fees[i].Cart__c != null && fees[i].Cart__r.Process_DateTime__c == null && (fees[i].Cart__r.Expiration_DateTime__c >= system.now() || fees[i].Cart__r.Expiration_DateTime__c == null))
                {
                    if (fees[i].Cart__r.OwnerId != userInfo.getUserId())
                    {
                        feeInOtherOwnerCart = true;
                    }
                    fees.remove(i);
                    i--;
                }
            }
        }
        
        // get cart
        DateTime dtNow = system.now();
        String whereFilter = 'Process_DateTime__c = null and (Expiration_DateTime__c >= :dtNow or Expiration_DateTime__c = null)';
        if (pid != null)
        {
            // cart query based on the contact not account any more
            whereFilter += ' and Contact__c = \'' + con.Id + '\' and OwnerId = \'' + userInfo.getUserId() + '\'';            
        }
        else if (cartId != null)
        {
            whereFilter += ' and Id =:cartId';
        }
        else if(cartId == null && UserInfo.getUserType().contains('CustomerSuccess'))
        {
            whereFilter +=' and OwnerId = \'' + userInfo.getUserId() + '\'';
        }
        carts = database.query('select Id, Process_DateTime__c, Name, Account__c, Account__r.Name, Account__r.billingStreet, Account__r.billingCity, Account__r.billingCountry, Account__r.billingPostalCode, Account__r.billingState, Contact__c, Contact__r.Name, Contact__r.email, (select ' + feeFields + '  from Fees__r where MUSW__Outstanding_Fee__c > 0) from Cart__c where ' + whereFilter );

        if (carts.size() == 0 ) // this is only for cart from permit without any cart then create a new cart
        {
            if (a != null && con != null)
            {
                cart = new Cart__c(Account__c = a.Id,Contact__c = con.Id, Name = 'System Number');
                cart.Expiration_DateTime__c = MUSW.UtilityDate.addBusinessDayHours(system.now(), 24);
                insert cart;
                cart.Name = [select Name from Cart__c where Id=:cart.Id].Name;
            }
            else
            {
                throw new MUSW.BGException('Account and Contact is required on the Permit (ID ' + pid + ').', true);
            }
        }
        else if (carts.size() == 1)
        {
            cart = carts[0];
            con = cart.Contact__r;
            a = cart.Account__r;
        }
        else if (carts.size() > 1) // we only will have one cart for one contact for current user
        {             
            throw new MUSW.BGException('Too many active Carts found.', true);
        }
        
        if (pid != null)
        {
            if (fees.size() > 0)
            {
                // add selected fees to cart
                for (MUSW__Fee__c f : fees)
                {
                    f.Cart__c = cart.Id;                    
                }
                update fees;
            }
            
            if (feeInOtherOwnerCart)
            {
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Some of your selected Fees are already checked out by another user. Your current Cart is shown below.');
                 ApexPages.addMessage(myMsg);        
            }
            else if (selectedFees.size() > fees.size())
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Some of your selected Fees are either already in the Cart or paid. Your current Cart is shown below.');
                ApexPages.addMessage(myMsg);
            }
            else if (fees.size() == 0 && cart.Fees__r.size() > 0) // there is cart ,the cart size >0 but did not select new fees adding to cart
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'No unpaid Fees were selected. Your current Cart is shown below.');
                ApexPages.addMessage(myMsg);
            }
            else if (fees.size() == 0 && cart.Fees__r.size() == 0) //there is no cart ,cart size =0 and did not select fees
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'No unpaid Fees were selected. Click Cancel to go back and select Fees.');
                ApexPages.addMessage(myMsg);
            }
            
            // combine cart fees with selected fees to show on the page            
            if (cart.Fees__r != null) fees.addAll(cart.Fees__r);
        
        }
        else if (cartId != null)// get from cart search
        {
            fees = cart.Fees__r;
            trackno = a.Name;
            parentLabel = 'Cart';
        }
        
        for (MUSW__Fee__c f : fees) totalOwed += f.MUSW__Outstanding_Fee__c;
        cart.Fee_Total__c = totalOwed;
        update cart;
        
        rs = new MUSW__Receipt__c[]{};
        addReceipt();
        rs[0].MUSW__Payment_Method__c = 'Check';
    }
    
    public List<SelectOption> accounts
    {
        get
        {
            if(accounts == null)
            {
                accounts = new List<SelectOption>();
                accountList = new Account[]{};
                
                // get the array of accounts from account_contact
                Account_Contact__c[] accountContacts = [select Account__c, Account__r.Name, Account__r.billingStreet, Account__r.billingCity, Account__r.billingCountry, Account__r.billingPostalCode, Account__r.billingState, Contact__c from  Account_Contact__c where Account__c != null and Contact__c=:con.Id];
                
                // if accounts in account_contact more than 0 then add none to list to choose accounts
                if (accountContacts.size() > 0)
                {               
                    accounts.add(new selectOption('', '- None -'));
                }
                       
                // add the Account to list
                Contact cq = [select AccountId, Account.Name, Account.billingStreet, Account.billingCity, Account.billingCountry, Account.billingPostalCode, Account.billingState from Contact where Id=:con.Id];
                a = cq.Account;
                String add = (a.billingStreet!= null) ? ' / ' + a.billingStreet: '';
                if (String.isBlank(a.billingCountry)) a.billingCountry = 'US';
                accounts.add(new SelectOption(String.valueOf(a.Id), a.Name + add));               
                accountList.add(a);
                
                // add the accouns from account_contact to list
                for (Account_Contact__c accCon : accountContacts)
                {            
                    String addr = (accCon.Account__r.billingStreet!= null) ? ' / ' + accCon.Account__r.billingStreet: '';
                    accounts.add(new SelectOption(String.valueOf(accCon.Account__c), accCon.Account__r.Name + addr));
                    accountList.add(accCon.Account__r);
                }            
            }
            return accounts;
        }
        set;
    }
    
    public void removeFee()
    {       
        for (Integer i=0; i<fees.size(); i++)
        {            
            if (fees[i].Id == feeSelected)
            {
                totalOwed = totalOwed - fees[i].MUSW__Outstanding_Fee__c;
                
                // remove the selected fee from the cart
                MUSW__Fee__c remFee = fees.remove(i);
                remFee.cart__c = null;
                update remFee;
                
                cart.Fee_Total__c = totalOwed;
                update cart;
                break;
            }
        }
    }
    
    public void accountChanged()
    {
        for (Account acc : accountList)
        {                
            if (acc.Id == accountSelected)
            {   
                a = acc;
                break;
            }
        }
    }
    
    public void checkout()
    {       
        if (accountSelected == null || accountSelected =='')
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select an Account first.');
            ApexPages.addMessage(myMsg);
            return;
        }
        
        activeTab = 'checkout';
        
        // by default use one Receipt
        rs[0].MUSW__Amount_Tendered__c = totalOwed;
        totalBalance = 0;
    }
    
    public void review()
    {       
        if (accountSelected == null || accountSelected =='')
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select an Account first.');
            ApexPages.addMessage(myMsg);
            return;
        }
        
        activeTab = 'review';
        
        for (MUSW__Receipt__c r : rs)
        {
            if (r.MUSW__Payment_Method__c == 'Credit Card' && !Test.isRunningTest())
            {
                gateway = new PaymentGateway();
                Boolean validLogin = gateway.authenticate(a.Id);
                if (!validLogin)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid login credentials for the Payment Gateway.'));
                }
                monexaSessionKey = gateway.getSessionKey(r.MUSW__Amount_Tendered__c);
            }
        }
    }
    
    public void addReceipt()
    {
        rs.add(
            new MUSW__Receipt__c(MUSW__Paid_By__c=a.Id, MUSW__Receipt_Paid_by__c=con.Id, Cart__c=cart.Id));
    }
    
    public void process()
    {
        if (totalBalance > 0)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Insufficient funds. Tender at least the Amount owing.'));
            return;
        }
        if (String.isBlank(accountSelected))
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select an Account first.'));
            return;
        }
        
        activeTab = 'confirm';
        
        processSuccessful = createReceipts();
        if (processSuccessful)
        {
            updateCart();
            createPayments();
        }
    }
    
    public void sendPdf()
    {
        if (!processSuccessful) return;
        
        pageReference pr = Page.FeeProcessPrint;
        pr.getParameters().put('cartId', cart.Id);       
        pr.getParameters().put('email', con.email);
     
        // the contents of the attachment from the pdf
        Blob body;
        if (!Test.isRunningTest()) body = pr.getContent();
        else body = Blob.valueOf('test');
        
        // insert attachment on cart 
        attachment at = new attachment(parentid = cart.Id, Name = 'Payment Receipt.pdf');      
        at.body = body;  
        insert at;
        
        if (con.email != null)
        {
            // NOTE: update contact to store email address (needed for Email Template)        
            update con;
         
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType('application/pdf');
            attach.setFileName('PaymentReceipt.pdf');
            attach.setInline(false);
            attach.setBody(body);
         
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setToAddresses(new String[] { con.email });
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
            EmailTemplate t = [select Id from EmailTemplate where Name = 'Payment Receipt'];
            mail.setTemplateId(t.Id);
            mail.setWhatId(cart.Id);
            mail.setTargetObjectId(con.Id);
    
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
    public pageReference cancel()
    {
        return getPageReference();
    }
    
    public Decimal totalBalance
    {
        get
        {
            Decimal totalr = 0;
            for (MUSW__Receipt__c r : rs)
            {
                Decimal ramt = (r.MUSW__Amount_Tendered__c != null) ? r.MUSW__Amount_Tendered__c : 0;
                totalr += ramt;
            }
            totalBalance = totalOwed - totalr;
            return totalBalance;
        }
        set;
    }
    
    /** Insert Receipts. Return false if Credit Card processing failed, else true **/
    private Boolean createReceipts()
    {
        Boolean isOk = true;
        for (MUSW__Receipt__c r : rs)
        {
            r.MUSW__Paid_By__c = accountSelected;
            if (r.MUSW__Payment_Method__c == 'Credit Card')
            {
                r.Card_Number__c = cardMasked;               
                if (processResult == 'process_transaction_action_successful')
                {
                    r.MUSW__Payment_Gateway_Transaction_Number__c = transactionId;
                }
                else
                {
                    isOk = false;
                    break;
                }
            }
            else if (r.MUSW__Payment_Method__c == 'Cash')
            {
                r.MUSW__Amount_Tendered__c += totalBalance;
            }
        }
        if (isOk) insert rs;
        
        return isOk;
    }
    
    private void updateCart()
    {
        cart.Process_DateTime__c = system.now();
        cart.Account__c = accountSelected;
        cart.OwnerId = UserInfo.getUserId();
        update cart;
    }
    
    /**
      * Create payments and fee payments
      *
      * Example: 3 Permits & 2 Receipts:
      * P1: 20  }------ PMT1: 20 ------{ R1: 130
      *             /-- PMT2: 110 ----/
      * P2: 120 }--|
      *             \-- PMT3: 10 ------{ R2: 70
      * P3: 60  }------ PMT4: 60 -----/
      */
    private void createPayments()
    {
        // build a map of parent-fees
        Map<Id, MUSW__Fee__c[]> pFeesMap = new Map<Id, MUSW__Fee__c[]>();
        Map<Id, Decimal> psBalanceMap = new Map<Id, Decimal>();
        for (MUSW__Fee__c f : fees)
        {
            Id parId = (f.MUSW__Complaint2__c != null ? f.MUSW__Complaint2__c : (f.MUSW__Application2__c != null ? f.MUSW__Application2__c : f.MUSW__Permit2__c));
            if (pFeesMap.containsKey(parId)) pFeesMap.get(parId).add(f);
            else pFeesMap.put(parId, new MUSW__Fee__c[]{f});
            
            if (psBalanceMap.containsKey(parId)) psBalanceMap.put(parId, psBalanceMap.get(parId)+f.MUSW__Outstanding_Fee__c);
            else psBalanceMap.put(parId, f.MUSW__Outstanding_Fee__c);
        }
        
        Map<MUSW__Fee__c, Decimal> feesMap = new Map<MUSW__Fee__c, Decimal>();
        for (MUSW__Fee__c f : fees) feesMap.put(f, f.MUSW__Outstanding_Fee__c);
        Map<MUSW__Receipt__c, Decimal> rsMap = new Map<MUSW__Receipt__c, Decimal>();
        for (MUSW__Receipt__c r : rs) rsMap.put(r, r.MUSW__Amount_Tendered__c);
        
        // keep track of receipt+parent to payments (used by FeePayments to find their Payment)
        Map<String, BGBK__Payment__c> recParPmtMap = new Map<String, BGBK__Payment__c>();
        for (MUSW__Receipt__c r : rsMap.keySet())
        {
            for (Id pid : pFeesMap.keySet())
            {
                // skip paid parents
                if (psBalanceMap.get(pid) == 0) continue;
                
                // create payment
                system.debug('****X: '+psBalanceMap.get(pid)+' / '+rsMap.get(r));
                Decimal pmtAmt = Math.min(rsMap.get(r), psBalanceMap.get(pid));
                BGBK__Payment__c pmt = new BGBK__Payment__c(BGBK__Receipt__c = r.Id, BGBK__Amount__c = pmtAmt, BGBK__Type__c = 'Allocation');
                pmt.put(String.valueOf(pid.getSobjectType()).replace('MUSW__', 'BGBK__'), pid);
                
                recParPmtMap.put(r.Id + ':' + pid, pmt);
                
                // update outstanding amounts to keep track of changes
                rsMap.put(r, rsMap.get(r) - pmtAmt);
                psBalanceMap.put(pid, psBalanceMap.get(pid) - pmtAmt);
                
                // move to next receipt if fully used up
                if (rsMap.get(r) == 0) break;
            }
        }
        insert recParPmtMap.values();
        
        MUSW__Fee_Payment__c[] fpmts = new MUSW__Fee_Payment__c[]{};
        for (MUSW__Receipt__c r : rsMap.keySet())
        {
            for (Id pid : pFeesMap.keySet())
            {
                BGBK__Payment__c pmt = recParPmtMap.remove(r.Id + ':' + pid);
                
                // is there a payment from the receipt for this permit?
                if (pmt != null)
                {
                    // create feepayments
                    Decimal pmtAmtLeft = pmt.BGBK__Amount__c;
                    for (MUSW__Fee__c f : pFeesMap.get(pid))
                    {
                        // skip paid fees
                        if (feesMap.get(f) == 0) continue;
                        
                        Decimal amtToPay = Math.min(feesMap.get(f), pmtAmtLeft);
                        //trunk to 2 decimal
                        amtToPay = amtToPay.setScale(2);
                        
                        MUSW__Fee_Payment__c fpmt = new MUSW__Fee_Payment__c(
                            MUSW__Fee__c = f.Id,
                            MUSW__Fee_Amount__c = f.MUSW__Amount__c,
                            MUSW__Paid_Date__c = Date.today(),
                            BGBK__Payment__c = pmt.Id,
                            MUSW__Payment_Amount__c = amtToPay,
                            MUSW__Receipt__c = r.Id,
                            MUSW__Receipt_Amount_Tendered__c = r.MUSW__Amount_Tendered__c);
                        fpmts.add(fpmt);
                        
                        // update outstanding amount to keep track of changes
                        feesMap.put(f, feesMap.get(f) - amtToPay);
                        pmtAmtLeft -= amtToPay;
                        
                        // move to next receipt if payment fully used up
                        if (pmtAmtLeft == 0) break;
                    }
                }
            }
        }
        insert fpmts;
        
        // query fees again
        fees = database.query('select ' + feeFields + ' from MUSW__Fee__c where MUSW__Fee__c.Cart__c = \'' + cart.Id + '\'');
    }
    
    private pageReference getPageReference()
    {
        pageReference pr;
        if (pid != null)
        {
            pr = new pageReference('/'+ parent.Id);
        }
        else
        {
             pr = new pageReference('/apex/CartSearch');
        }
        pr.setredirect(true);
        return pr;
    }
    
    @isTest(seeAllData=true)
    private static void testFromPerm()
    {
        HamptonTriggerService.setLock();
                
        Contact c = new Contact(Lastname='TestUser123');
        insert c;
        
         // get Account Id from contact as next query ,so the accountId = cq.AccountId
        Contact cq = [select AccountId from Contact where Id=:c.Id];    
        
        MUSW__Parcel__c par = new MUSW__Parcel__c(Name='xyz123abc');
        insert par;

        MUSW__Permit2__c perm = new MUSW__Permit2__c(MUSW__Type__c='Building', MUSW__Parcel__c=par.id, MUSW__Applicant__c=c.Id);
        insert perm;
                
        MUSW__Fee__c f1 = new MUSW__Fee__c(MUSW__Amount__C=20, MUSW__Permit2__c=perm.Id);
        MUSW__Fee__c f2 = new MUSW__Fee__c(MUSW__Amount__C=120, MUSW__Permit2__c=perm.Id);
        MUSW__Fee__c[] fees = new MUSW__Fee__c[]{f1,f2};
        insert fees;
        
        // set page 
        pageReference fp = Page.FeeProcess;
        fp.getParameters().put('id', perm.Id);
        Test.setCurrentPage(fp);
        
        // this is initial the standardSetController and pass to FeeProcessController
        ApexPages.StandardSetController mm = new ApexPages.StandardSetController(fees);
        mm.setSelected(fees);
        FeeProcessController fc = new FeeProcessController(mm );
        fc.initOrder();
        List<SelectOption> accs = fc.accounts;
        system.assert(fc.rs[0].MUSW__Receipt_Paid_by__c == c.Id);
        fc.rs[0].MUSW__Payment_Method__c = 'Credit Card';
        fc.feeSelected = fees[0].Id;
        fc.removeFee();        
        fc.accountSelected = cq.AccountId ;
        fc.checkout();
        fc.review();
        fc.processResult = 'process_transaction_action_successful';
        
        HamptonTriggerService.releaseLock();
        
        fc.process();
        fc.sendPdf();
        fc.cancel();
        fc.accountChanged();
    }
    
    @isTest(seeAllData=true)
    private static void testFromAccount()
    {
        HamptonTriggerService.setLock();                
        
        Contact c = new Contact(Lastname='TestUser56456', Email='abc@safagve.com');
        insert c;
        
        // get Account Id from contact as next query ,so the accountId = cq.AccountId
        Contact cq = [select Id, AccountId from Contact where Id=:c.Id];
        
        MUSW__Parcel__c par = new MUSW__Parcel__c(Name='xyz123def');
        insert par;

        MUSW__Permit2__c perm = new MUSW__Permit2__c(MUSW__Type__c='Building', MUSW__Parcel__c=par.id, MUSW__Applicant__c=c.Id);
        insert perm;
        
        // insert cart that account look up equals contact's accountId
        Cart__c testCart = new Cart__c(Account__c = cq.AccountId, Contact__c = cq.Id , Name = 'System Number');
        insert testCart;
        
        // add the fees look up carts  
        MUSW__Fee__c f1 = new MUSW__Fee__c(MUSW__Amount__C=20, MUSW__Permit2__c=perm.Id,Cart__c = testCart.Id);
        MUSW__Fee__c f2 = new MUSW__Fee__c(MUSW__Amount__C=120, MUSW__Permit2__c=perm.Id,Cart__c = testCart.Id);
        MUSW__Fee__c[] fees = new MUSW__Fee__c[]{f1,f2};
        insert fees;
        
        // set page 
        pageReference fp = Page.FeeProcess;
        fp.getParameters().put('cartId',  testCart.Id );
        Test.setCurrentPage(fp);
        
        FeeProcessController fc = new FeeProcessController(null);
        
        fc.initOrder();
        system.assert(fc.cart.Fee_Total__c == 140);
        List<SelectOption> accs = fc.accounts;
        fc.rs[0].MUSW__Payment_Method__c = 'Credit Card';
        fc.accountSelected = cq.AccountId ;
        fc.feeSelected  = fees[0].Id;
        fc.checkout();
        fc.removeFee();       
        fc.review();
        fc.processResult = 'process_transaction_action_successful';
        
        HamptonTriggerService.releaseLock();
        
        fc.process();
        try { fc.sendPdf(); }
        catch (EmailException e) { if (e.getMessage().contains('Single email must be enabled')) {} }
        fc.cancel();
        fc.accountChanged();        
        system.assert(fc.cart.Process_DateTime__c != null);
    }
    
    @isTest(seeAllData=true)
    private static void testManyPermitsPayments()
    {
        HamptonTriggerService.setLock();                
        
        Contact c = new Contact(Lastname='TestUser56456', Email='abc@safagve.com');
        insert c;
        
        Contact cq = [select Id, AccountId from Contact where Id=:c.Id];
        
        MUSW__Parcel__c par = new MUSW__Parcel__c(Name='xyz123def');
        insert par;
        
        MUSW__Permit2__c[] perms = new MUSW__Permit2__c[]{};
        for (Integer i=0; i<20; i++)
        {
            MUSW__Permit2__c perm = new MUSW__Permit2__c(MUSW__Type__c='Building', MUSW__Parcel__c=par.id, MUSW__Applicant__c=c.Id);
            perms.add(perm);
        }
        insert perms;
        
        Cart__c testCart = new Cart__c(Account__c = cq.AccountId, Contact__c = cq.Id , Name = 'System Number');
        insert testCart;
        
        MUSW__Fee__c[] fees = new MUSW__Fee__c[]{};
        for (MUSW__Permit2__c p : perms)
        {
            MUSW__Fee__c f1 = new MUSW__Fee__c(MUSW__Amount__C=20, MUSW__Permit2__c=p.Id, Cart__c = testCart.Id);
            fees.add(f1);
        }
        insert fees;
        
        // set page 
        pageReference fp = Page.FeeProcess;
        fp.getParameters().put('cartId',  testCart.Id );
        Test.setCurrentPage(fp);
        
        FeeProcessController fc = new FeeProcessController(null);
        
        fc.initOrder();
        system.assert(fc.cart.Fee_Total__c == 400);
        List<SelectOption> accs = fc.accounts;
        //add another receipt for multiple payments
        fc.addReceipt();        
        fc.rs[0].MUSW__Payment_Method__c = 'Cash';
        fc.rs[1].MUSW__Payment_Method__c = 'Credit Card';
        fc.rs[0].MUSW__Amount_Tendered__c = 300;
        fc.rs[1].MUSW__Amount_Tendered__c = 100;
        fc.accountSelected = cq.AccountId;
        fc.checkout();
        fc.review();
        fc.processResult = 'process_transaction_action_successful';
        
        HamptonTriggerService.releaseLock();
        
        fc.process();
        system.assert(fc.cart.Process_DateTime__c != null);
        MUSW__Receipt__c[] rec = [select Id, Name from MUSW__Receipt__c where Cart__c =: testCart.Id];
        Map<Id, MUSW__Receipt__c> recMap = new Map<Id, MUSW__Receipt__c>(rec);
        
        BGBK__Payment__c[] paym = [select Name from BGBK__Payment__c where BGBK__Receipt__c in : recMap.keySet()];
        system.assert(paym.size() > 0);
    }
}