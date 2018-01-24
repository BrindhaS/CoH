public class MonexaManager
{
    public String sessionKey { get; set; }
    private Map<string, string> responseCode = new Map<string, string>{};
    private Decimal procTrans_amount;
    private String procTrans_comment;
    private String procTrans_apply_outstanding_amounts;
    private Id accountId;
    private String monexaPlanId;
    private MonexaServices.Client mxClient;
   
    
    public MonexaManager(Id accountId)
    {
        mxClient = new MonexaServices.Client();
        this.accountId = accountId;
    }
    
    public Boolean authenticate()
    {
        MXA_Settings__c mxs = MXA_Settings__c.getInstance();
        mxClient.Authentication = new MonexaServices.AuthenticationElement();
        mxClient.Authentication.administrator_login_name = mxs.API_User_Name__c;
        mxClient.Authentication.password = mxs.API_Password__c;
        
        Boolean res = false;
        try
        {
            String version = mxClient.pingServer();
            res = true;
        }
        catch (CallOutException ex) {}
        
        return res;
    }
    
    public String refund(String transactionId, Decimal amount)
    {
        MonexaServices.ResponseProcessTransactionElement resp;
        try
        {
            resp = mxClient.processTransaction(monexaAccountId, null, transactionId, null,
                        'refund', null, amount.toPlainString(), null, null, null);
            
            addInfo('ProcessTransaction suceeded. Response code: ' + resp.response_code);
        }
        catch(CallOutException ex)
        {
            addError('ProcessTransaction failed.', ex);
            throw ex;
        } 
        
        return resp.response_code;
    }
     
    public String void(String transactionId, Decimal amount)
    {
        MonexaServices.ResponseProcessTransactionElement resp;
        try
        {
            resp = mxClient.processTransaction(monexaAccountId, null, transactionId, null,
                        'void', null, amount.toPlainString(), null, null, null);
            
            addInfo('ProcessTransaction suceeded. Response code: ' + resp.response_code);
        }
        catch(CallOutException ex)
        {
            addError('ProcessTransaction failed.', ex);
            throw ex;
        }
        
        return resp.response_code;
    }
    
    public String getSessionKey(Decimal amount)
    {
        MonexaServices.SessionKeyElement key;
        String sessionType = 'SILENT_ORDER_POST';
        
        String currURL = String.valueOf(URL.getSalesforceBaseUrl().toExternalForm());
        // LPL : release to production
        String sessionInfo = 'process_transaction_action=Y,update_account_action=N,payment_method=CC,payment_action=auth_and_capture,' +
                             'amount=' + amount.toPlainString() + ',success_redirect_url='+ currURL +'/apex/FeeProcess?q=sucess,failure_redirect_url='+ currURL +'/apex/FeeProcess?q=failure';
                             
        /*String sessionInfo = 'process_transaction_action=Y,update_account_action=N,payment_method=CC,payment_action=auth_and_capture,' +
                             'amount=' + amount.toPlainString() + ',success_redirect_url=https://c.na9.visual.force.com/apex/FeeProcess?q=sucess,failure_redirect_url=https://c.na9.visual.force.com/apex/FeeProcess?q=failure';*/
        
        
        try
        {
            key = mxClient.getSessionKey(monexaAccountId, null, sessionInfo, sessionType);
        }
        catch (CallOutException ex)
        {
            throw ex;
        }
        
        // DML has to happen after all callouts
        Account a = new Account(Id=accountId, Payment_Gateway_AccountId__c=monexaAccountId);
        update a;
        
        return key.session_key;
    }
    
    @TestVisible private String monexaAccountId
    {
        get
        {
            if (monexaAccountId == null)
            {
                Account a = [select Id, Name, Phone, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, Payment_Gateway_AccountId__c, (select Name, Email from Contacts) from Account where Id = :accountId];
                
                if (a.Payment_Gateway_AccountId__c == null)
                {
                    MXA_Settings__c mxs = MXA_Settings__c.getInstance();
                    
                    MonexaServices.CreateSubscriberBillingInformation creSub_BillingInfo = new MonexaServices.CreateSubscriberBillingInformation();
                    MonexaServices.CreateSubscriberContactInformation creSub_ContactInfo = new MonexaServices.CreateSubscriberContactInformation();
                    MonexaServices.CreateSubscriberAccountInformationElement creSub_accountInfo = new MonexaServices.CreateSubscriberAccountInformationElement();
                    
                    creSub_accountInfo.login_id = 'basicgov_user' + String.valueOf(Math.roundToLong(Math.random() * 10000));
                    creSub_AccountInfo.external_group_id = String.valueOf(Math.roundToLong(Math.random() * 10000));
                    creSub_accountInfo.provider_id = String.valueOf(mxs.Provider_ID__c.intValue());
                    creSub_accountInfo.office_id = String.valueOf(mxs.Office_ID__c.intValue());
                    creSub_accountInfo.account_status = null;
                    creSub_accountInfo.invoice_notify_flag = null;
                    creSub_accountInfo.statement_notify_flag = null;
                    creSub_accountInfo.sales_representative_name = null;
                    creSub_accountInfo.sales_representative_email = null;
                    creSub_accountInfo.promo_code = null;
                    creSub_accountInfo.Plan.plan_id = mxs.Plan_ID__c; //'recurring';
                    
                    Blob blobKey = crypto.generateAesKey(128);
                    String strKey = EncodingUtil.base64Encode(blobKey);
                    Pattern p = Pattern.compile('[^0-9^A-Z^a-z]');
                    Matcher m = p.matcher(strKey);
                    strKey = m.replaceAll('');
                    creSub_accountInfo.password = strKey.left(12) + '1';
                    
                    String subName = a.Name;
                    if (subName.length() > 20) subName = subName.substring(0, 20);
                    creSub_ContactInfo.company = subName;
                    creSub_ContactInfo.first_name = subName;
                    creSub_ContactInfo.last_name = subName;
                    
                    String ph = a.Phone;
                    if (ph != null && ph.length() > 19) ph = ph.substring(0,19);
                    creSub_ContactInfo.phone_number_1 = ph;
                    creSub_ContactInfo.external_account_id = a.Id;
                    
                    Contact con;
                    for (Contact c : a.Contacts)
                    {
                        if (c.Name == a.Name) con = c;
                    }
                    
                    String em = con.Email;
                    if (em != null && em.length() > 64 ) em = em.substring(0,64);
                    creSub_ContactInfo.contact_email = em;
                    
                    MonexaServices.AddressElement mxAddress = new MonexaServices.AddressElement();
                    
                    String street = a.BillingStreet;
                    if (street != null && street.length() > 45) street = street.substring(0,45);
                    mxAddress.address_1 = street;
                    
                    String city = a.BillingCity;
                    if (city != null && city.length() > 58) city = city.substring(0,58);
                    mxAddress.city = city;
                    
                    String pr = a.BillingState;
                    if (pr != null && pr.length() > 58) pr = pr.substring(0,58);                    
                    mxAddress.state_or_province = pr;
                    
                    String po = a.BillingPostalCode;
                    if (po != null && po.length() > 10) po = po.substring(0,10);
                    mxAddress.zip_or_postal_code = po;
                    
                    String co = a.BillingCountry;
                    if (co != null && co.length() > 2) co = co.substring(0, 2);
                    else co = 'US';
                    mxAddress.country = co;
                    
                    creSub_ContactInfo.Bill_To_Address = mxAddress;
                    
                    creSub_BillingInfo.payment_method = 'OTHER';
                    
                    try
                    {
                        if(!Test.isRunningTest()){
                            monexaAccountId = mxClient.createSubscriber(creSub_accountInfo, creSub_BillingInfo, creSub_ContactInfo);
                        }
                        
                        // update Account.Payment_Gateway_AccountId but can't do it until callouts have run!
                        // hence do it in getSessionKey()
                    }
                    catch(Exception ex)
                    {
                        throw ex;
                    }
                }
                else
                {
                    monexaAccountId = a.Payment_Gateway_AccountId__c;
                }
            }
            
            return monexaAccountId;
        }
        set;
    }
    
    public static String getMessage(String msgCode)
    {
        String msg;
        if (messageMap.containsKey(msgCode))
        {
            msg = messageMap.get(msgCode);
        }
        else
        {
            msg = 'unknown error';
        }
        return msg;
    }
    
    //JAW Review: may use array of messages instead because this class may not be used as a page controller
    private void addInfo(String msg) {
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, msg));
    }
    private void addError(String msg) {
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));
    }
    private void addError(String msg, Exception ex) {
        msg += ' Message: ' + ex.getMessage();
        
        msg += ' Stack Trace: ' + ex.getStackTraceString();
        
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));
    }
    
    private final static Map<String, String> messageMap  = new Map<String, String> {
        '0000' => 'Request was completed successfully ',
        '0001' => 'The request was successful but the system was not able to send the configured email notices',
        '0002' => 'The LOOKUP request succeeded but only a portion of the requested data was returned because the Administrator does not have full permissions for the items request',
        '0003' => 'NO LONGER IN USE - The Administrator’s password being used to submit the API requests is more than 90 days old and needs to be updated for security reasons',
        '1000' => 'https communication error',
        '1001' => 'http post error',
        '1002' => 'IP address error',
        '1100' => 'The xml request does not match the DTD',
        '1101' => 'Wrong XML version',
        '1102' => 'XML message is not a <Request>',
        '1200' => 'Error in validating the Administrator',
        '1201' => 'Error in validating the Office ID',
        '1202' => 'Error in validating Username',
        '1203' => 'Subscriber does not exist',
        '1204' => 'Error in validating Subscriber/Account holders first name',
        '1205' => 'Error in validating Subscriber/Account holders last name',
        '1206' => 'Error in validating Plan',
        '1207' => 'Error in validating Office',
        '1208' => 'Error in validating password',
        '1209' => 'Error in validating language',
        '1210' => 'Error in validating verification question',
        '1211' => 'Error in validating verification answer',
        '1212' => 'Error in validating payment method',
        '1213' => 'Invalid Credit Card information',
        '1214' => 'Invalid ECP information',
        '1215' => 'Error in validating start date',
        '1216' => 'Error in validating expiry date',
        '1217' => 'Account has been locked due to successive invalid login attempts. The Account will automatically be unlocked after 30 minutes ',
        '1218' => 'Error in validating External Account ID',
        '1219' => 'Error in validating discount type',
        '1220' => 'This error code is currently not being used',
        '1221' => 'Error in validating Master Account',
        '1222' => 'Error in validating end date',
        '1223' => 'Error in validating Receive Provider Marketing',
        '1224' => 'Error in validating Receive 3rd Party Marketing',
        '1225' => 'Error in validating Product',
        '1226' => 'Error in validating Service',
        '1227' => 'Error in validating Date Format',
        '1228' => 'Error in validating Tax Exempt 1',
        '1230' => 'Error in validating Tax Exempt 2',
        '1231' => 'Error in validating External Group ID',
        '1232' => 'Error in validating Billing Day',
        '1233' => 'Error in validating Setup Fee Flag',
        '1234' => 'Error in validating Collection Status',
        '1235' => 'Error in validating Invoice Notify Flag',
        '1236' => 'Error in validating Statement Notify Flag',
        '1237' => 'Error in validating Cancellation Reason',
        '1238' => ' Error in validating Provider ID',
        '1239' => ' Error in validating Time Zone',
        '1240' => 'Error in validating Result Order',
        '1241' => 'Error in validating Result Sort By',
        '1242' => 'Error in validating Current Balance',
        '1243' => 'Error in validating Last Payment Amount',
        '1244' => 'Error in validating Zip Code or Postal Code',
        '1245' => 'Error in validating Country',
        '1246' => 'Error in validating State or Province',
        '1247' => 'Error in validating City',
        '1248' => 'Error in validating Phone number',
        '1249' => 'Error in validating Credit Limit',
        '1250' => 'Error in validating Search Account Type',
        '1251' => 'This error code is currently not being used',
        '1252' => 'Error in validating Billing Frequency',
        '1253' => 'Error in validating Failed Payment Attempts',
        '1254' => 'Error in validating Apply Changes to Existing because when the command to update/change the Plan the apply_changes_to_existing tag was not sent/included',
        '1255' => 'When updating/deleting a Plan Services the Monexa system will verify that no Users are using the Service',
        '1256' => 'When updating a Plan billing frequency the Monexa system will verify that no Users are using the billing frequency',
        '1257' => 'Error in validating Contact Email of the Account',
        '1258' => 'Error in validating the Accounts Status',
        '1260' => 'Invalid result_set_start date for the Search Subscriber request',
        '1261' => 'Invalid quantity for CREATE_BILLING_LINE_ITEM',
        '1262' => 'Error in validating Last Payment Attempt Date',
        '1263' => 'Error in validating Billed Up To Date',
        '1264' => 'Error in validating Overtime Billed Up To Date',
        '1265' => 'Invalid transaction type for PROCESS_TRANSACTION request',
        '1266' => 'Invalid transaction amount for PROCESS_TRANSACTION request',
        '1267' => 'Error in validating the address ',
        '1268' => 'Invalid Event Start Date for CREATE_BILLABLE _EVENT',
        '1269' => 'Invalid Event End Date for CREATE_BILLABLE _EVENT',
        '1270' => 'Invalid Service for CREATE_BILLABLE _EVENT request',
        '1279' => 'Invalid Transaction Token',
        '1280' => 'Invalid Currency',
        '1281' => 'Invalid Status',
        '1282' => 'Invalid session_type.',
        '1283' => 'Missing Input Field.',
        '1284' => 'session_key is expired.',
        '1285' => 'session_key is invalid.',
        '1286' => 'Invalid further_action_type.',
        '1287' => 'Invalid monexa_transaction_id -OR- No further action is available for the transaction -OR- Invalid Amount.',
        '1288' => 'Invalid comment.',
        '1301' => 'Incomplete information in the database',
        '1401' => 'Process Transaction Failed',
        '1402' => 'Retrieve Transaction Failed',
        '2000' => 'Request is empty or cannot connect to the database',
        '2001' => 'Memory Leak',
        '2002' => 'This error code is currently not being used',
        '2003' => 'Invalid Flag',
        '2100' => 'Configuration File Error',
        '2101' => 'Configuration Buffer Size Error',
        '2102' => 'Database Initialization error',
        '2200' => 'Initialize Error',
        '2201' => 'Un-Initialize Error',
        '2202' => 'Parse Error',
        '2203' => 'Create Error',
        '2204' => 'Store Error',
        '2800' => 'Decrypt Password Error',
        '2900' => 'Unknown',
        'session_key_invalid' => 'Invalid session key',
        'session_key_expired' => 'expired session key',
        'missing_required_fields' => 'one or more required field is missing',
        'field_length_exceeded' => 'one or more field has exceeded the maximum length',
        'invalid_value' => 'one or more of the enumerated fields has an incorrect value',
        'process_transaction_action_failure' => 'process transaction failed',
        'update_account_action_failure ' => 'update account failed',
        'process_transaction_action_success_update_account_action_failure' => 'process transaction succeeded session key value but update account failed'  
    };
}