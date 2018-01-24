/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class aaaTST_MonexaServices {

    private class WsCreateSubMockImpl implements WebServiceMock {
       private Object responseObj;
       public WsCreateSubMockImpl(Object o) {
            responseObj = o;
       }
       public void doInvoke(
               Object stub,
               Object request,
               Map<String, Object> response,
               String endpoint,
               String soapAction,
               String requestName,
               String responseNS,
               String responseName,
               String responseType) {          
           response.put('response_x', responseObj); 
       }        
    }
    static testMethod void lookupPlanTest() {
        MonexaAPI.Response_LOOKUP_PLAN_element repObj = new MonexaAPI.Response_LOOKUP_PLAN_element();
        repObj.Plan = new MonexaAPI.REP_LOOKUP_PLAN_PLAN_TYPE();
        repObj.Plan.provider_id = '177';
        repObj.Plan.Plan_Service = new List<MonexaAPI.REP_LOOKUP_PLAN_PLAN_SERVICE_TYPE>();
        
        MonexaAPI.REP_LOOKUP_PLAN_PLAN_SERVICE_TYPE ppsType = new MonexaAPI.REP_LOOKUP_PLAN_PLAN_SERVICE_TYPE();
        repObj.Plan.Plan_Service.add(ppsType);
        ppsType.Service_Group = new List<MonexaAPI.REP_LOOKUP_PLAN_SERVICE_GROUP_TYPE>();
        MonexaAPI.REP_LOOKUP_PLAN_SERVICE_GROUP_TYPE psg = new MonexaAPI.REP_LOOKUP_PLAN_SERVICE_GROUP_TYPE();
        MonexaAPI.REP_LOOKUP_PLAN_SERVICE_TYPE pst = new MonexaAPI.REP_LOOKUP_PLAN_SERVICE_TYPE();
        pst.service_id = '111';
        psg.Service = new List<MonexaAPI.REP_LOOKUP_PLAN_SERVICE_TYPE>();
        psg.Service.add(pst); 
        ppsType.Service_Group.add(psg);
        psg.summary = 'test';
        
        Test.setMock(WebServiceMock.class, new WsCreateSubMockImpl(repObj));
        MonexaServices.Client mxClient = new MonexaServices.Client();
        mxClient.Authentication = new MonexaServices.AuthenticationElement();
        mxClient.Authentication.administrator_login_name = 'Test';
        mxClient.Authentication.password = 'Password';
        
        MonexaServices.ResponseLookupPlanPlanType response = mxClient.lookupPlan('provider_id', 'plan_id', 'full', true, true, true);
        MonexaServices.LookupPlanPlanServiceType planServType = response.Plan_Service.get(0);
        system.assert(planServType.Service_Group.get(0).summary == 'test');
    }
    static testMethod void searchSubscriberTest() {
        MonexaAPI.Response_SEARCH_SUBSCRIBER_element repObj = new MonexaAPI.Response_SEARCH_SUBSCRIBER_element();
        repObj.result_size = 1;
        repObj.Subscriber_Information = new List<MonexaAPI.REP_SEA_SUB_SUBSCRIBER_INFORMATION_TYPE>();
        MonexaAPI.REP_SEA_SUB_SUBSCRIBER_INFORMATION_TYPE repSubInfo = new MonexaAPI.REP_SEA_SUB_SUBSCRIBER_INFORMATION_TYPE();
        MonexaAPI.REP_SEA_SUB_ACCOUNT_INFORMATION_TYPE repAcctInfo = new MonexaAPI.REP_SEA_SUB_ACCOUNT_INFORMATION_TYPE();
        MonexaAPI.REP_SEA_SUB_CONTACT_INFORMATION_TYPE repConInfo = new MonexaAPI.REP_SEA_SUB_CONTACT_INFORMATION_TYPE();
        
        repAcctInfo.office_id = '111';
        repConInfo.first_name = 'Steve';
        repConInfo.last_name = 'Powell';
        
        repSubInfo.Contact_Information = repConInfo;
        repSubInfo.Account_Information = repAcctInfo;
        repObj.Subscriber_Information.add(repSubInfo);
        
        Test.setMock(WebServiceMock.class, new WsCreateSubMockImpl(repObj));
        MonexaServices.Client mxClient = new MonexaServices.Client();
        mxClient.Authentication = new MonexaServices.AuthenticationElement();
        mxClient.Authentication.administrator_login_name = 'Test';
        mxClient.Authentication.password = 'Password';
        
        List<MonexaServices.SearchSubscriberInformationElement> response = mxClient.searchSubscriber('one','two','three','four',null,null,'seven',null,null,'ten',null,null,null,null,'fifteen',null);
        
        System.assert(response.size() == 1);    
    }
    static testMethod void lookupSubscriberTest() {
        MonexaAPI.Response_LOOKUP_SUBSCRIBER_element repObj = new MonexaAPI.Response_LOOKUP_SUBSCRIBER_element();

        MonexaAPI.REP_LOOK_SUB_SUBSCRIBER_INFORMATION_TYPE repSubInfo = new MonexaAPI.REP_LOOK_SUB_SUBSCRIBER_INFORMATION_TYPE(); 
        repObj.Subscriber_Information = new List<MonexaAPI.REP_LOOK_SUB_SUBSCRIBER_INFORMATION_TYPE>();
        repObj.Subscriber_Information.add(repSubInfo);
        
        MonexaAPI.REP_LOOK_SUB_ACCOUNT_INFORMATION_TYPE repAccountInfo = new MonexaAPI.REP_LOOK_SUB_ACCOUNT_INFORMATION_TYPE();
        MonexaAPI.REP_LOOK_SUB_BILLING_INFORMATION_TYPE repBillInfo = new MonexaAPI.REP_LOOK_SUB_BILLING_INFORMATION_TYPE();
        MonexaAPI.REP_LOOK_SUB_CONTACT_INFORMATION_TYPE repConInfo = new MonexaAPI.REP_LOOK_SUB_CONTACT_INFORMATION_TYPE();
        
        repSubInfo.Account_Information = repAccountInfo;
        repSubInfo.Billing_Information = repBillInfo;
        repSubInfo.Contact_Information = repConInfo;
        
        repAccountInfo.office_name = 'Test Office';
        MonexaAPI.REP_LOOK_SUB_ACT_PLAN_TYPE pType = new MonexaAPI.REP_LOOK_SUB_ACT_PLAN_TYPE();
        pType.provider_id = '111';
        pType.Plan_Discount_Type = new MonexaAPI.REP_LOOK_SUB_PLAN_DISCOUNT_TYPE();
        pType.Plan_Discount_Type.discount_type_id = '1932';
        pType.Plan_Service = new List<MonexaAPI.REP_LOOK_SUB_PLAN_SERVICE_TYPE>();
        MonexaAPI.REP_LOOK_SUB_PLAN_SERVICE_TYPE subPlanService = new MonexaAPI.REP_LOOK_SUB_PLAN_SERVICE_TYPE();
        MonexaAPI.REP_LOOK_SUB_SERVICE_GROUP_TYPE gType = new MonexaAPI.REP_LOOK_SUB_SERVICE_GROUP_TYPE(); 
        subPlanService.Service_Group = gType;
        gType.description = 'Test';
        pType.Plan_Service.add(subPlanService);
        repAccountInfo.Plan = pType;

        Test.setMock(WebServiceMock.class, new WsCreateSubMockImpl(repObj));
        MonexaServices.Client mxClient = new MonexaServices.Client();
        mxClient.Authentication = new MonexaServices.AuthenticationElement();
        mxClient.Authentication.administrator_login_name = 'Test';
        mxClient.Authentication.password = 'Password';

        List<MonexaServices.LookupSubscriberInformationElement> response = mxClient.lookupSubscriber('111',null,null);
        system.assert(response.size() == 1);
    }
    static testMethod void getSessionKeyTest() {
        MonexaAPI.Response_GET_SESSION_KEY_element repObj = new MonexaAPI.Response_GET_SESSION_KEY_element();       
        repObj.Session_Key = new MonexaAPI.Session_Key_element();
        repObj.Session_Key.account_id = 'account';
        repObj.Session_Key.session_information = 'payment_method=CC';
        repObj.Session_Key.session_type = 'session_type';
        repObj.Session_Key.session_key_expiry_minutes = '2';
        
        Test.setMock(WebServiceMock.class, new WsCreateSubMockImpl(repObj));
        MonexaServices.Client mxClient = new MonexaServices.Client();
        mxClient.Authentication = new MonexaServices.AuthenticationElement();

        MonexaServices.SessionKeyElement resp = mxClient.getSessionKey('account',null,'1','2');
        
        System.assert(resp.account_id == 'account');        
        
    }
    static testMethod void lookupTransactionTest() {
        MonexaAPI.Response_LOOKUP_TRANSACTION_element repObj = new MonexaAPI.Response_LOOKUP_TRANSACTION_element();
        repObj.account_id = '1234567890';
        repObj.Transaction_Information = new MonexaAPI.Transaction_Information_element();
        repObj.Transaction_Information.Transaction_x = new MonexaAPI.Transaction_element();
        MonexaAPI.Transaction_element ele = repObj.Transaction_Information.Transaction_x;
        ele.Applied_To_Invoice_Date = new MonexaAPI.Applied_To_Invoice_Date_element();
        ele.Applied_To_Invoice_Date.Date_x = MXA_APIHelper.convertDate(Date.newInstance(2012,12,25));
        ele.response_code = '0';
        ele.Subscriber_Information = new MonexaAPI.Subscriber_Information_Type();
        ele.Subscriber_Information.Contact_Information = new MonexaAPI.Contact_Information_Type();
        ele.Subscriber_Information.Account_Information = new MonexaAPI.Account_Information_Type();
        
        
        
        Test.setMock(WebServiceMock.class, new WsCreateSubMockImpl(repObj));
        MonexaServices.Client mxClient = new MonexaServices.Client();
        mxClient.Authentication = new MonexaServices.AuthenticationElement();
        
        MonexaServices.ResponseLookupTransactionElement resp = mxClient.lookupTransaction('1234567890', null, 'Full', 'X12345');
        system.assert(resp.account_id == '1234567890');

        
    }
    static testMethod void searchTransactionTest() {
        MonexaAPI.Response_SEARCH_TRANSACTION_element repObj = new MonexaAPI.Response_SEARCH_TRANSACTION_element();
        
        MonexaAPI.Transaction_element trans = new MonexaAPI.Transaction_element();
        trans.comment = 'Hello';
        trans.amount = '99.99';
        trans.Subscriber_Information = new MonexaAPI.Subscriber_Information_Type();
        trans.Subscriber_Information.Contact_Information = new MonexaAPI.Contact_Information_Type();
        trans.Subscriber_Information.Account_Information = new MonexaAPI.Account_Information_Type();
        repObj.Transaction_x = new List<MonexaAPI.Transaction_element>();
        repObj.Transaction_x.add(trans);    

        Test.setMock(WebServiceMock.class, new WsCreateSubMockImpl(repObj));
        MonexaServices.Client mxClient = new MonexaServices.Client();
        mxClient.Authentication = new MonexaServices.AuthenticationElement();
        
        
        List<MonexaServices.TransactionElement> resp = mxClient.searchTransaction('provider', 'account', null, 
            'auth', null, 'CASH', null,
            Date.newInstance(2012,1,1), Date.newInstance(2012,12,31),Date.newInstance(2012,1,1), Date.newInstance(2012,12,31), 'Alive');
        System.assert(resp.size() == 1);
        MonexaServices.TransactionElement e = resp.get(0);
        System.assert(e.comment == 'Hello');
    }
    static testMethod void searchInvoiceTest() {
        MonexaAPI.Response_SEARCH_INVOICE_element repObj = new MonexaAPI.Response_SEARCH_INVOICE_element();
        MonexaAPI.Invoice_Information_element ele = new MonexaAPI.Invoice_Information_element();
        ele.Invoice = new MonexaAPI.Invoice_element();
        ele.Invoice.applied_amount = '10.00';
        repObj.Invoice_Information = new List<MonexaAPI.Invoice_Information_element>();
        repObj.Invoice_Information.add(ele);

        Test.setMock(WebServiceMock.class, new WsCreateSubMockImpl(repObj));
        MonexaServices.Client mxClient = new MonexaServices.Client();
        mxClient.Authentication = new MonexaServices.AuthenticationElement();
        mxClient.Authentication.administrator_login_name = 'Test';
        mxClient.Authentication.password = 'Password';

        List<MonexaServices.InvoiceInformationElement> resp = mxClient.searchInvoice('279', '1122', null,
            'Summary', 'Ok', 'XXX', Date.newInstance(2012,1,1), Date.newInstance(2012,12,31));      
        System.assert(resp.size() == 1);
    }    
    static testMethod void createSubscriberTest() {
        MonexaAPI.Response_CREATE_SUBSCRIBER_element repObj = new MonexaAPI.Response_CREATE_SUBSCRIBER_element();
        MonexaAPI.REP_CRE_SUB_SUBSCRIBER_INFORMATION_TYPE subInfo = new MonexaAPI.REP_CRE_SUB_SUBSCRIBER_INFORMATION_TYPE();
        repObj.Subscriber_Information  = subInfo;
        MonexaAPI.REP_CRE_SUB_ACCOUNT_INFORMATION_TYPE accountInfo = new MonexaAPI.REP_CRE_SUB_ACCOUNT_INFORMATION_TYPE();
        accountInfo.account_id = '100010101';
        MonexaAPI.REP_CRE_SUB_BILLING_INFORMATION_TYPE billInfo = new MonexaAPI.REP_CRE_SUB_BILLING_INFORMATION_TYPE();
        MonexaAPI.REP_CRE_SUB_CONTACT_INFORMATION_TYPE conInfo = new MonexaAPI.REP_CRE_SUB_CONTACT_INFORMATION_TYPE();
        subInfo.Contact_Information = conInfo;
        subInfo.Account_Information = accountInfo;
        subInfo.Billing_Information = billInfo;
    
    
        Test.setMock(WebServiceMock.class, new WsCreateSubMockImpl(repObj));
        MonexaServices.Client mxClient = new MonexaServices.Client();
        mxClient.Authentication = new MonexaServices.AuthenticationElement();
        mxClient.Authentication.administrator_login_name = 'Test';
        mxClient.Authentication.password = 'Password';
        
        MonexaServices.CreateSubscriberAccountInformationElement acctInfo = new MonexaServices.CreateSubscriberAccountInformationElement();
        acctInfo.login_id = 'Hello';
        acctInfo.external_group_id = 'Hello';
        acctInfo.invoice_notify_flag = 'Sure';
        acctInfo.promo_code = 'FREESTUFF!';
        acctInfo.provider_id = '1110';
        acctInfo.sales_representative_name = 'Ed';
        acctInfo.password = 'Password';
        acctInfo.account_status = 'Gold';
        acctInfo.Plan = new MonexaServices.CreateSubscriberAccountPlanType();
        acctInfo.Plan.plan_id = '111';
        
        
        
        MonexaServices.CreateSubscriberPlanServiceType subPlanServTyp = new MonexaServices.CreateSubscriberPlanServiceType();
        
        acctInfo.Plan.Plan_Service = new List<MonexaServices.CreateSubscriberPlanServiceType>();
        
        //acctInfo.Plan.Plan_Service.add(subPlanServTyp);
        
        subPlanServTyp.Service_Group= new MonexaServices.CreateSubscriberServiceGroupType();
        subPlanServTyp.Service_Group.service_group_id = 'xyz';
        subPlanServTyp.Service_Group.Service = new MonexaServices.CreateSubscriberServiceType();
        MonexaServices.CreateSubscriberServiceType subServTyp = subPlanServTyp.Service_Group.Service;
        subServTyp.addServiceParameter('hello','world');
        
        MonexaServices.CreateSubscriberBillingInformation billingInfo = new MonexaServices.CreateSubscriberBillingInformation();
        billingInfo.trial_balance = '1000.0';
        billingInfo.billing_frequency = 'daily';
        billingInfo.Credit_Card_Information = new MonexaServices.CreditCardInformationElement();
        billingInfo.Credit_Card_Information.name_on_credit_card = 'Steve Powell';
        MonexaServices.BankAccountInformationElement ba = new MonexaServices.BankAccountInformationElement();
        MonexaServices.PayPalInformationElement pp = new MonexaServices.PayPalInformationElement();
        billingInfo.Price_Book = new MonexaServices.CreateSubscriberPriceBookType();
        billingInfo.Price_Book.price_book_id = '111';
        billingInfo.Start_Date = Date.newInstance(2012,10,10);
        billingInfo.Expiry_Date = Date.newInstance(2013,1,1);
        
        MonexaServices.CreateSubscriberContactInformation contactInfo = new MonexaServices.CreateSubscriberContactInformation();
        contactInfo.first_name = 'Daryl';
        contactInfo.last_name = 'Dave';
        contactInfo.Bill_To_Address = new MonexaServices.AddressElement();
        contactInfo.Bill_To_Address.city = 'Toronto';
        contactInfo.Ship_To_Address = new MonexaServices.AddressElement();
        contactInfo.Ship_To_Address.country = 'Canada';
        
        
        String id = mxClient.createSubscriber(acctInfo, billingInfo, contactInfo);
        System.assertEquals('100010101', id);   
    }
    
}