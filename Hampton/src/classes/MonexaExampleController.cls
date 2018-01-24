public with sharing class MonexaExampleController {
	private MonexaServices.Client mxClient;

	private void addInfo(String msg) {
      	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, msg));
    }	
    private void addError(String msg) {
    	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));
    }
    private void addError(String msg, Exception ex) {
    	msg += ' Message: ' + ex.getMessage();
    	
    	msg += ' Stack Trace: ' + ex.getStackTraceString();
    	
    	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));
    }

	public MonexaServices.SubscriberInformationType subscriber { get; set; }
	
	
	public MonexaExampleController() {
		getKey_session_info = 'process_transaction_action=Y,update_account_action=N,payment_method=CC,payment_action=auth_and_capture,' +
				'amount=8.0,success_redirect_url=https://www.google.ca/search?q=sucess;sfdc.override=1,failure_redirect_url=https://www.google.ca/search?q=failure';
		getKey_session_type = 'SILENT_ORDER_POST';	
		seaInv_information_type = 'summary';
		lookTrans_information_type = 'full';
		lookInv_information_type = 'full';
		creSubAssignDefaults();
	}
	
	
	// LOGIN:		
	public String administratorLoginName {get; set;}
	public String adminPassword {get; set;}
	public String version {get; set;}
	
	public PageReference doLogin() {
		mxClient = new MonexaServices.Client();
		mxClient.Authentication = new MonexaServices.AuthenticationElement();
		mxClient.Authentication.administrator_login_name = administratorLoginName;
		mxClient.Authentication.password = adminPassword;
		try {
			version = mxClient.pingServer();
		} catch (CallOutException ex) {
			version = null;
		}
		if(version != null) {
			addInfo('Login successful. Monexa API version is ' + version);
		} else {
			addError('Login failed. Pleas try again.');
		}
		
		return null;
	}
	// End LOGIN
	
	// Search Subscriber:
	public String seaSub_account_id {get; set;}
	public String seaSub_first_name {get; set;}
	public String seaSub_last_name {get; set;}
	public String seaSub_company {get; set;}
	public String seaSub_phone_number_1 {get; set;}
	public String seaSub_external_account_id {get; set;}
	
	public List<MonexaServices.SearchSubscriberInformationElement> searchSubs {get; set;}
	// End Search Subscriber
	
	public void doSearchSubscribers() {
		try {
			if(seaSub_account_id == '') seaSub_account_id = null;
			if(seaSub_first_name == '') seaSub_first_name = null;
			if(seaSub_last_name == '') seaSub_last_name = null;
			if(seaSub_company == '') seaSub_company = null;
			if(seaSub_phone_number_1 == '') seaSub_phone_number_1 = null;
			if(seaSub_external_account_id == '') seaSub_external_account_id = null;
			
			searchSubs = mxClient.searchSubscriber(seaSub_account_id, null, 
        		null, seaSub_first_name, seaSub_last_name, seaSub_company, seaSub_external_account_id, 
        		seaSub_phone_number_1, null, null, null, 
        		null, null, null, null,null);
        	if(searchSubs != null)
        		addInfo('Search found ' + searchSubs.size() + ' subscribers.');
       	} catch (CallOutException ex) {
       		searchSubs = null;
       		addError('Search failed.');
       	}		
	}
	// LOOKUP Sub
	public String lookSub_account_id {get; set;}
	public MonexaServices.LookupSubscriberInformationElement lookupSub {get; set;}
	public void doLookupSubscriber() {
		lookupSub = null;
		try {
			List<MonexaServices.LookupSubscriberInformationElement> lookups;
			lookups = mxClient.lookupSubscriber(lookSub_account_id,null,null);
			if(lookups.size() > 0) {
				lookupSub = lookups.get(0);
			}		
		} catch (CallOutException ex) {
       		searchSubs = null;
       		addError('Lookup failed.');
       	}
	}
	// End Lookup SUB
    
    // SOP:
    public String getKey_session_info {get; set;}
    public String getKey_account_id {get; set;}
    public String getKey_session_type {get; set;}
    public MonexaServices.SessionKeyElement getKey_SessionKey {get; set;}
    public void doGetSessionKey() {
    	try {
	    	if(getKey_account_id == null || getKey_account_id == '') {
	    		addError('Missing Account ID.');
	    		return;
	    	}
	    	if(getKey_session_info == null || getKey_session_info == '') {
	    		addError('Missing Session Info.');
	    		return;
	    	}
	    	getKey_SessionKey = mxClient.getSessionKey(getKey_account_id, null, getKey_session_info, getKey_session_type);
	    	
    	} catch (CallOutException ex) {
    		addError('GetSessionKey failed.',ex);
    	}
    }	
	// End SOP
	
	// Search Transaction				   
	public String  seaTrans_provider_id {get; set;}
	public String  seaTrans_account_id {get; set;}
	public String  seaTrans_transaction_type {get; set;}
	public String  seaTrans_further_action {get; set;}
	public String  seaTrans_payment_method {get; set;}
	public String  seaTrans_transaction_token {get; set;}
	public Date  seaTrans_Start_Date {get; set;}
	public Date  seaTrans_End_Date {get; set;}
	public Date  seaTrans_Last_Updated_Start_Date {get; set;}
	public Date  seaTrans_Last_Updated_End_Date {get; set;}
	public String  seaTrans_status {get; set;}
	public List<MonexaServices.TransactionElement> seaTrans_Transactions {get; set;}
	
	public void doSearchTransaction() {
		seaTrans_Transactions = null;
		try {		
		
			if(seaTrans_provider_id == '') seaTrans_provider_id = null;
			if(seaTrans_account_id == '') seaTrans_account_id = null;
			if(seaTrans_transaction_type == '') seaTrans_transaction_type = null;
			if(seaTrans_further_action == '') seaTrans_further_action = null;
			if(seaTrans_payment_method == '') seaTrans_payment_method = null;
			if(seaTrans_transaction_token == '') seaTrans_transaction_token = null;
	//		if(seaTrans_Start_Date == '') seaTrans_Start_Date = null;
	//		if(seaTrans_End_Date == '') seaTrans_End_Date = null;
	//		if(seaTrans_Last_Updated_Start_Date == '') seaTrans_Last_Updated_Start_Date = null;
	//		if(seaTrans_Last_Updated_End_Date == '') seaTrans_Last_Updated_End_Date = null;
			if(seaTrans_status == '') seaTrans_status = null;
			
			seaTrans_Transactions = mxClient.searchTransaction(seaTrans_provider_id,seaTrans_account_id,null,seaTrans_transaction_type,seaTrans_further_action,seaTrans_payment_method,seaTrans_transaction_token,seaTrans_Start_Date,seaTrans_End_Date,seaTrans_Last_Updated_Start_Date,seaTrans_Last_Updated_End_Date,seaTrans_status);
		} catch(Exception ex) {
			addError('SearchTransaction failed.', ex);
		}
	}
	// End Search Transaction
	
	// Process Transaction
	// Note: if procTrans_amount is null than procTrans_apply_outstanding_amounts is used but if
	// procTrans_amount isn't null than procTrans_apply_outstanding_amounts is ignored.
	public String procTrans_account_id {get; set;}
	public String procTrans_monexa_transaction_id {get; set;}
	public String procTrans_transaction_type {get; set;}
	public String procTrans_amount {get; set;}
	public String procTrans_apply_outstanding_amounts {get; set;}
	public String procTrans_comment {get; set;}
	public MonexaServices.ResponseProcessTransactionElement procTrans_response {get; set;}	
	public void doProcessTransaction() {
		try {
			if(procTrans_amount != null && procTrans_amount == '')
				procTrans_amount = null;		
			
			procTrans_response = mxClient.processTransaction(procTrans_account_id, null, procTrans_monexa_transaction_id, null,
											procTrans_transaction_type, procTrans_amount == null ? procTrans_apply_outstanding_amounts : null, procTrans_amount, 
											null, null, procTrans_comment);
			addInfo('ProcessTransaction suceeded. Response code: ' + procTrans_response.response_code);
		} catch(Exception ex) {
			addError('ProcessTransaction failed.', ex);
		}		
	}
	// End Process Transaction
	
	// Create Subscriber
	
	public MonexaServices.CreateSubscriberAccountInformationElement creSub_AccountInfo {get; set;}
	public MonexaServices.CreateSubscriberBillingInformation creSub_BillingInfo {get; set;}
	public MonexaServices.CreateSubscriberContactInformation creSub_ContactInfo {get; set;}
	
	public void creSubAssignDefaults() {
			creSub_AccountInfo = new MonexaServices.CreateSubscriberAccountInformationElement();
			creSub_BillingInfo = new MonexaServices.CreateSubscriberBillingInformation();
			creSub_ContactInfo = new MonexaServices.CreateSubscriberContactInformation();

			// TODO Review
			creSub_AccountInfo.Plan.plan_id = 'default'; //'recurring';//'bronze';
						
			String login_id = 'test_login_';
			login_id = login_id + String.valueOf(Math.roundToLong(Math.random() * 10000));
			creSub_AccountInfo.login_id = login_id;
			
			// TODO Review
			creSub_AccountInfo.provider_id = '281'; // adminInfo.provider_id; - this gives 111 which doesn't work (no plan).
			creSub_AccountInfo.office_id = '3284'; //adminInfo.office_id;
			creSub_AccountInfo.external_group_id = String.valueOf(Math.roundToLong(Math.random() * 10000)); // We need this but what should it be?
			creSub_AccountInfo.sales_representative_name = UserInfo.getName();
			
			
			Blob blobKey = crypto.generateAesKey(128);
			String strKey = EncodingUtil.base64Encode(blobKey);
			Pattern p = Pattern.compile('[^0-9^A-Z^a-z]');
			Matcher m = p.matcher(strKey);
			strKey = m.replaceAll('');
			creSub_AccountInfo.password = strKey.left(12);
						
			
			creSub_BillingInfo.payment_method = 'OTHER';
			
			
			creSub_ContactInfo.company = 'Numbered Corporation: ' + String.valueOf(Math.roundToLong(Math.random() * 1000));
			creSub_ContactInfo.first_name = 'John';
			creSub_ContactInfo.last_name = 'Smith';
			creSub_ContactInfo.phone_number_1 = '123-456-7890';
			creSub_ContactInfo.external_account_id = 'ID' + String.valueOf(Math.roundToLong(Math.random() * 10000));
	}
	public void doCreateSubscriber() {
		try {
			if(creSub_accountInfo.login_id == '') creSub_accountInfo.login_id = null;
			if(creSub_accountInfo.external_group_id == '') creSub_accountInfo.external_group_id = null;
			if(creSub_accountInfo.provider_id == '') creSub_accountInfo.provider_id = null;
			if(creSub_accountInfo.password == '') creSub_accountInfo.password = null;
			if(creSub_accountInfo.office_id == '') creSub_accountInfo.office_id = null;
			if(creSub_accountInfo.account_status == '') creSub_accountInfo.account_status = null;
			if(creSub_accountInfo.invoice_notify_flag == '') creSub_accountInfo.invoice_notify_flag = null;
			if(creSub_accountInfo.statement_notify_flag == '') creSub_accountInfo.statement_notify_flag = null;
			if(creSub_accountInfo.sales_representative_name == '') creSub_accountInfo.sales_representative_name = null;
			if(creSub_accountInfo.sales_representative_email == '') creSub_accountInfo.sales_representative_email = null;
			if(creSub_accountInfo.promo_code == '') creSub_accountInfo.promo_code = null;

			if(creSub_ContactInfo.company == '') creSub_ContactInfo.company = null;
			if(creSub_ContactInfo.first_name == '') creSub_ContactInfo.first_name = null;
			if(creSub_ContactInfo.last_name == '') creSub_ContactInfo.last_name = null;
			if(creSub_ContactInfo.phone_number_1 == '') creSub_ContactInfo.phone_number_1 = null;
			if(creSub_ContactInfo.external_account_id == '') creSub_ContactInfo.external_account_id = null;


			system.debug('****Z creSub_accountInfo: '+creSub_accountInfo);
            system.debug('****Z creSub_BillingInfo: '+creSub_BillingInfo);
            system.debug('****Z creSub_ContactInfo: '+creSub_ContactInfo);
			String response = mxClient.createSubscriber(creSub_accountInfo, creSub_BillingInfo, creSub_ContactInfo);
			addInfo('Created subscriber with ID: ' + response);
			creSubAssignDefaults();
		} catch(Exception ex) {
			addError('Create subscriber failed.', ex);
		}		

	}
	// End Create Subscriber
	
	
	// Search Invoices
	public String seaInv_provider_id {get; set;}
	public String seaInv_account_id {get; set;}
    public String seaInv_information_type {get; set;}
    public String seaInv_invoice_status {get; set;}
    public String seaInv_external_invoice_number {get; set;}
	public List<MonexaServices.InvoiceInformationElement> seaInv_Invoices {get; set;}
	public void doSearchInvoice() {
		seaInv_Invoices = null;
		
		if(seaInv_provider_id == '') seaInv_provider_id = null;
		if(seaInv_account_id == '') seaInv_account_id = null;
		if(seaInv_information_type == '') seaInv_information_type = null;
		if(seaInv_invoice_status == '') seaInv_invoice_status = null;
		if(seaInv_external_invoice_number == '') seaInv_external_invoice_number = null;
		try {	
			seaInv_Invoices = mxClient.searchInvoice(seaInv_provider_id, seaInv_account_id, null,
	        	seaInv_information_type, seaInv_invoice_status, seaInv_external_invoice_number, null,null);	        
	    } catch(Exception ex) {
			addError('Search invoices failed.', ex);
		}   
	}
	// End Search Invoices
	// Lookup Transaction
	public String lookTrans_account_id {get; set;}
	public String lookTrans_information_type {get; set;}
	public String lookTrans_monexa_transaction_id {get; set;}
	public MonexaServices.ResponseLookupTransactionElement lookTrans_Transaction {get; set;}
	public void doLookupTransaction() {
		lookTrans_Transaction = null;
		try {		
			lookTrans_Transaction = mxClient.lookupTransaction(lookTrans_account_id, null, lookTrans_information_type, lookTrans_monexa_transaction_id);
	    } catch(Exception ex) {
			addError('Lookup transaction failed.', ex);
		}   
	}
	// End Lookup Transaction
	// Lookup Invoice
	public String lookInv_account_id {get; set;}
	public String lookInv_information_type {get; set;}
	public String lookInv_invoice_number {get; set;}
	public MonexaServices.InvoiceElement lookInv_Invoice {get; set;}
	public void doLookupInvoice() {
	
		try {
			MonexaServices.ResponseLookupInvoiceElement resp = mxClient.lookupInvoice(lookInv_account_id, null, lookInv_information_type, lookInv_invoice_number);
			lookInv_Invoice = resp.Invoice_Information.Invoice;
			
	    } catch(Exception ex) {
			addError('Lookup invoice failed.', ex);
		}   
		
	}
	// End Loookup Invoice
	
}