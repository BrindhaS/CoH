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
private class TST_MonexaAPI {
    static testMethod void myUnitTest() {
		MonexaAPI.LookupPlanRequest_element e1 = new MonexaAPI.LookupPlanRequest_element();
		MonexaAPI.Statement_Date_element e2 = new MonexaAPI.Statement_Date_element();
		MonexaAPI.LIST_PLAN_RESTRICTIONS_element e3 = new MonexaAPI.LIST_PLAN_RESTRICTIONS_element();
		MonexaAPI.Invoice_Detail_Date_element e4 = new MonexaAPI.Invoice_Detail_Date_element();
		MonexaAPI.REP_LIST_PLANS_SERVICE_TYPE e5 = new MonexaAPI.REP_LIST_PLANS_SERVICE_TYPE();
		MonexaAPI.Trial_Balance_Date_element e6 = new MonexaAPI.Trial_Balance_Date_element();
		MonexaAPI.REP_LIST_PLANS_SERVICE_GROUP_TYPE e7 = new MonexaAPI.REP_LIST_PLANS_SERVICE_GROUP_TYPE();
		MonexaAPI.Last_Payment_Attempt_Date_element e8 = new MonexaAPI.Last_Payment_Attempt_Date_element();
		MonexaAPI.Response_LOOKUP_STATEMENT_element e9 = new MonexaAPI.Response_LOOKUP_STATEMENT_element();
		MonexaAPI.CreatePlanRequest_element e10 = new MonexaAPI.CreatePlanRequest_element();
		MonexaAPI.LookupProductRequest_element e11 = new MonexaAPI.LookupProductRequest_element();
		MonexaAPI.ListStatementsRequest_element e12 = new MonexaAPI.ListStatementsRequest_element();
		MonexaAPI.ProcessProformaInvoiceRequest_element e13 = new MonexaAPI.ProcessProformaInvoiceRequest_element();
		MonexaAPI.REP_CRE_SUB_SERVICE_GROUP_TYPE e14 = new MonexaAPI.REP_CRE_SUB_SERVICE_GROUP_TYPE();
		MonexaAPI.Period_End_Date_element e15 = new MonexaAPI.Period_End_Date_element();
		MonexaAPI.CHECK_PASSWORD_element e16 = new MonexaAPI.CHECK_PASSWORD_element();
		MonexaAPI.CRE_PLAN_SERVICE_GROUP_TYPE e17 = new MonexaAPI.CRE_PLAN_SERVICE_GROUP_TYPE();
		MonexaAPI.REP_LOOK_SUB_PRICE_BOOK_TYPE e18 = new MonexaAPI.REP_LOOK_SUB_PRICE_BOOK_TYPE();
		MonexaAPI.REP_LIST_OFFICES_OFFICE_TYPE e19 = new MonexaAPI.REP_LIST_OFFICES_OFFICE_TYPE();
		MonexaAPI.MonexaSvcFaultData_element e20 = new MonexaAPI.MonexaSvcFaultData_element();
		MonexaAPI.LIST_PLANS_element e21 = new MonexaAPI.LIST_PLANS_element();
		MonexaAPI.REP_LOOKUP_PLAN_SERVICE_GROUP_TYPE e22 = new MonexaAPI.REP_LOOKUP_PLAN_SERVICE_GROUP_TYPE();
		MonexaAPI.GET_ACCOUNT_BALANCE_INFO_element e23 = new MonexaAPI.GET_ACCOUNT_BALANCE_INFO_element();
		MonexaAPI.REP_LIST_PROVIDERS_PROVIDER_TYPE e24 = new MonexaAPI.REP_LIST_PROVIDERS_PROVIDER_TYPE();
		MonexaAPI.Negative_Invoice_element e25 = new MonexaAPI.Negative_Invoice_element();
		MonexaAPI.VALIDATE_SESSION_KEY_element e26 = new MonexaAPI.VALIDATE_SESSION_KEY_element();
		MonexaAPI.DeleteBillingLineItemRequest_element e27 = new MonexaAPI.DeleteBillingLineItemRequest_element();
		MonexaAPI.ListBillingLineItemsRequest_element e28 = new MonexaAPI.ListBillingLineItemsRequest_element();
		MonexaAPI.Account_Namespace_element e29 = new MonexaAPI.Account_Namespace_element();
		MonexaAPI.MANAGE_INVOICE_element e30 = new MonexaAPI.MANAGE_INVOICE_element();
		MonexaAPI.UPD_SUB_BILLING_INFORMATION e31 = new MonexaAPI.UPD_SUB_BILLING_INFORMATION();
		MonexaAPI.ValidateSessionKeyRequest_element e32 = new MonexaAPI.ValidateSessionKeyRequest_element();
		MonexaAPI.REP_CRE_SUB_PLAN_DISCOUNT_TYPE e33 = new MonexaAPI.REP_CRE_SUB_PLAN_DISCOUNT_TYPE();
		MonexaAPI.CREATE_ACCOUNT_HISTORY_element  e34 = new MonexaAPI.CREATE_ACCOUNT_HISTORY_element ();
		MonexaAPI.LIST_PROVIDERS_LIST_OFFICES_TYPE e35 = new MonexaAPI.LIST_PROVIDERS_LIST_OFFICES_TYPE();
		MonexaAPI.REP_LOOK_SUB_SERVICE_TYPE e36 = new MonexaAPI.REP_LOOK_SUB_SERVICE_TYPE();
		MonexaAPI.LIST_SERVICE_GROUPS_element e37 = new MonexaAPI.LIST_SERVICE_GROUPS_element();
		MonexaAPI.Local_Transaction_Time_element e38 = new MonexaAPI.Local_Transaction_Time_element();
		MonexaAPI.UPD_PLAN_SERVICE_GROUP_TYPE e39 = new MonexaAPI.UPD_PLAN_SERVICE_GROUP_TYPE();
		MonexaAPI.CreatePriceSheetRequest_element e40 = new MonexaAPI.CreatePriceSheetRequest_element();
		MonexaAPI.Plan_element e41 = new MonexaAPI.Plan_element();
		MonexaAPI.PROCESS_PROFORMA_INVOICE_element e42 = new MonexaAPI.PROCESS_PROFORMA_INVOICE_element();
		MonexaAPI.LOOKUP_PRODUCT_element e43 = new MonexaAPI.LOOKUP_PRODUCT_element();
		MonexaAPI.LIST_PROVIDERS_LIST_PRODUCTS_TYPE e44 = new MonexaAPI.LIST_PROVIDERS_LIST_PRODUCTS_TYPE();
		MonexaAPI.Forward_Date_element e45 = new MonexaAPI.Forward_Date_element();
		MonexaAPI.ListAccountHistoryRequest_element e46 = new MonexaAPI.ListAccountHistoryRequest_element();
		MonexaAPI.CHK_PWD_SUBSCRIBER_INFORMATION_TYPE e47 = new MonexaAPI.CHK_PWD_SUBSCRIBER_INFORMATION_TYPE();
		MonexaAPI.Plan_Restriction_element e48 = new MonexaAPI.Plan_Restriction_element();
		MonexaAPI.REP_CRE_SUB_SERVICE_TYPE e49 = new MonexaAPI.REP_CRE_SUB_SERVICE_TYPE();
		MonexaAPI.REP_SEARCH_PLAN_PLAN_SERVICE_TYPE e50 = new MonexaAPI.REP_SEARCH_PLAN_PLAN_SERVICE_TYPE();
		MonexaAPI.UPD_SUB_PLAN_SERVICE_TYPE e51 = new MonexaAPI.UPD_SUB_PLAN_SERVICE_TYPE();
		MonexaAPI.Positive_Invoice_element e52 = new MonexaAPI.Positive_Invoice_element();
		MonexaAPI.Invoice_Date_element e53 = new MonexaAPI.Invoice_Date_element();
		MonexaAPI.GetAccountBalanceInfoRequest_element e54 = new MonexaAPI.GetAccountBalanceInfoRequest_element();
		MonexaAPI.Response_LIST_SESSION_KEY_element e55 = new MonexaAPI.Response_LIST_SESSION_KEY_element();
		MonexaAPI.Service_Group_element e56 = new MonexaAPI.Service_Group_element();
		MonexaAPI.DeletePriceBookRequest_element e57 = new MonexaAPI.DeletePriceBookRequest_element();
		MonexaAPI.CreateInvoiceRequest_element e58 = new MonexaAPI.CreateInvoiceRequest_element();
		MonexaAPI.Response_LOOKUP_INVOICE_element e59 = new MonexaAPI.Response_LOOKUP_INVOICE_element();
		MonexaAPI.DELETE_BILLING_LINE_ITEM_element e60 = new MonexaAPI.DELETE_BILLING_LINE_ITEM_element();
		MonexaAPI.CREATE_PRICE_BOOK_element e61 = new MonexaAPI.CREATE_PRICE_BOOK_element();
		MonexaAPI.Billing_Line_Item_element e62 = new MonexaAPI.Billing_Line_Item_element();
		MonexaAPI.Usage_Pricing_element e63 = new MonexaAPI.Usage_Pricing_element();
		MonexaAPI.PROCESS_TRANSACTION_element e64 = new MonexaAPI.PROCESS_TRANSACTION_element();
		MonexaAPI.Earliest_Amount_Owing_Date_element e65 = new MonexaAPI.Earliest_Amount_Owing_Date_element();
		MonexaAPI.LIST_SESSION_KEY_element e66 = new MonexaAPI.LIST_SESSION_KEY_element();
		MonexaAPI.Price_Book_element e67 = new MonexaAPI.Price_Book_element();
		MonexaAPI.Applied_Date_element e68 = new MonexaAPI.Applied_Date_element();
		MonexaAPI.DELETE_PRICE_SHEET_element e69 = new MonexaAPI.DELETE_PRICE_SHEET_element();
		MonexaAPI.Response_LOOKUP_PROVIDER_element e70 = new MonexaAPI.Response_LOOKUP_PROVIDER_element();
		MonexaAPI.Price_Book_Namespace_element e71 = new MonexaAPI.Price_Book_Namespace_element();
		MonexaAPI.Local_Event_Start_Time_element e72 = new MonexaAPI.Local_Event_Start_Time_element();
		MonexaAPI.Response_LIST_STATEMENTS_element e73 = new MonexaAPI.Response_LIST_STATEMENTS_element();
		MonexaAPI.LIST_OFFICES_element e74 = new MonexaAPI.LIST_OFFICES_element();
		MonexaAPI.Response_GET_ACCOUNT_BALANCE_INFO_element e75 = new MonexaAPI.Response_GET_ACCOUNT_BALANCE_INFO_element();
		MonexaAPI.DELETE_PRICE_BOOK_element e76 = new MonexaAPI.DELETE_PRICE_BOOK_element();
		MonexaAPI.ManageInvoiceRequest_element e77 = new MonexaAPI.ManageInvoiceRequest_element();
		MonexaAPI.UPD_SUB_ACT_PLAN_TYPE e78 = new MonexaAPI.UPD_SUB_ACT_PLAN_TYPE();
		MonexaAPI.Price_Sheet_element e79 = new MonexaAPI.Price_Sheet_element();
		MonexaAPI.Response_LIST_BILLING_LINE_ITEMS_element e80 = new MonexaAPI.Response_LIST_BILLING_LINE_ITEMS_element();
		MonexaAPI.ListProductsRequest_element e81 = new MonexaAPI.ListProductsRequest_element();
		MonexaAPI.Period_Start_Date_element e82 = new MonexaAPI.Period_Start_Date_element();
		MonexaAPI.Transaction_Date_element e83 = new MonexaAPI.Transaction_Date_element();
		MonexaAPI.CREATE_BILLABLE_EVENT_element e84 = new MonexaAPI.CREATE_BILLABLE_EVENT_element();
		MonexaAPI.UPD_PLAN_TYPE e85 = new MonexaAPI.UPD_PLAN_TYPE();
		MonexaAPI.Line_Item_Date_element e86 = new MonexaAPI.Line_Item_Date_element();
		MonexaAPI.Account_Event_element e87 = new MonexaAPI.Account_Event_element();
		MonexaAPI.REP_LOOKUP_PLAN_PLAN_SERVICE_TYPE e88 = new MonexaAPI.REP_LOOKUP_PLAN_PLAN_SERVICE_TYPE();
		MonexaAPI.Discount_Info_element e89 = new MonexaAPI.Discount_Info_element();
		MonexaAPI.LOOKUP_PROVIDER_LIST_PLANS_TYPE e90 = new MonexaAPI.LOOKUP_PROVIDER_LIST_PLANS_TYPE();
		MonexaAPI.Statement_element e91 = new MonexaAPI.Statement_element();
		MonexaAPI.LookupOfficeRequest_element e92 = new MonexaAPI.LookupOfficeRequest_element();
		MonexaAPI.UPD_SUB_PLAN_DISCOUNT_TYPE e93 = new MonexaAPI.UPD_SUB_PLAN_DISCOUNT_TYPE();
		MonexaAPI.SearchPlanRequest_element e94 = new MonexaAPI.SearchPlanRequest_element();
		MonexaAPI.UPD_PLAN_PLAN_SERVICE_TYPE e95 = new MonexaAPI.UPD_PLAN_PLAN_SERVICE_TYPE();
		MonexaAPI.UPD_SUB_SERVICE_TYPE e96 = new MonexaAPI.UPD_SUB_SERVICE_TYPE();
		MonexaAPI.REP_LIST_PLANS_PLAN_TYPE e97 = new MonexaAPI.REP_LIST_PLANS_PLAN_TYPE();
		MonexaAPI.LIST_ACCOUNT_HISTORY_element e98 = new MonexaAPI.LIST_ACCOUNT_HISTORY_element();
		MonexaAPI.UPD_PLAN_SERVICE_TYPE e99 = new MonexaAPI.UPD_PLAN_SERVICE_TYPE();
		MonexaAPI.DELETE_PLAN_element e100 = new MonexaAPI.DELETE_PLAN_element();
		MonexaAPI.LOOKUP_PRICE_BOOK_element e101 = new MonexaAPI.LOOKUP_PRICE_BOOK_element();
		MonexaAPI.LookupProviderRequest_element e102 = new MonexaAPI.LookupProviderRequest_element();
		MonexaAPI.UPDATE_SUBSCRIBER_element e103 = new MonexaAPI.UPDATE_SUBSCRIBER_element();
		MonexaAPI.UPDATE_PLAN_element e104 = new MonexaAPI.UPDATE_PLAN_element();
		MonexaAPI.Invoice_Detail_element e105 = new MonexaAPI.Invoice_Detail_element();
		MonexaAPI.Auto_Pay_Run_Date_element e106 = new MonexaAPI.Auto_Pay_Run_Date_element();
		MonexaAPI.Response_LIST_USAGE_DATA_element e107 = new MonexaAPI.Response_LIST_USAGE_DATA_element();
		MonexaAPI.LookupPriceBookRequest_element e108 = new MonexaAPI.LookupPriceBookRequest_element();
		MonexaAPI.Response_LIST_PLANS_element e109 = new MonexaAPI.Response_LIST_PLANS_element();
		MonexaAPI.ListSessionKeyRequest_element e110 = new MonexaAPI.ListSessionKeyRequest_element();
		MonexaAPI.UPD_SUB_SUBSCRIBER_INFORMATION_TYPE e111 = new MonexaAPI.UPD_SUB_SUBSCRIBER_INFORMATION_TYPE();
		MonexaAPI.REP_SEARCH_PLAN_PLAN_TYPE e112 = new MonexaAPI.REP_SEARCH_PLAN_PLAN_TYPE();
		MonexaAPI.ProcessTransactionRequest_element e113 = new MonexaAPI.ProcessTransactionRequest_element();
		MonexaAPI.DeletePriceSheetRequest_element e114 = new MonexaAPI.DeletePriceSheetRequest_element();
		MonexaAPI.SEARCH_PLAN_element e115 = new MonexaAPI.SEARCH_PLAN_element();
		MonexaAPI.CreateBillingLineItemRequest_element e116 = new MonexaAPI.CreateBillingLineItemRequest_element();
		MonexaAPI.Payment_element e117 = new MonexaAPI.Payment_element();
		MonexaAPI.UpdatePlanRequest_element e118 = new MonexaAPI.UpdatePlanRequest_element();
		MonexaAPI.REP_LOOKUP_PLAN_SERVICE_TYPE e119 = new MonexaAPI.REP_LOOKUP_PLAN_SERVICE_TYPE();
		MonexaAPI.UpdateSubscriberRequest_element e120 = new MonexaAPI.UpdateSubscriberRequest_element();
		MonexaAPI.LIST_PROVIDERS_element e121 = new MonexaAPI.LIST_PROVIDERS_element();
		MonexaAPI.CRE_PRICE_BOOK_TYPE e122 = new MonexaAPI.CRE_PRICE_BOOK_TYPE();
		MonexaAPI.LIST_PLAN_DISCOUNTS_element e123 = new MonexaAPI.LIST_PLAN_DISCOUNTS_element();
		MonexaAPI.CheckPasswordRequest_element e124 = new MonexaAPI.CheckPasswordRequest_element();
		MonexaAPI.Payment_Information_element e125 = new MonexaAPI.Payment_Information_element();
		MonexaAPI.Overtime_Billed_Up_To_Date_element e126 = new MonexaAPI.Overtime_Billed_Up_To_Date_element();
		MonexaAPI.LOOKUP_PLAN_element e127 = new MonexaAPI.LOOKUP_PLAN_element();
		MonexaAPI.LOOKUP_PROVIDER_LIST_PRODUCTS_TYPE e128 = new MonexaAPI.LOOKUP_PROVIDER_LIST_PRODUCTS_TYPE();
		MonexaAPI.LIST_PLAN_SERVICES_element e129 = new MonexaAPI.LIST_PLAN_SERVICES_element();
		MonexaAPI.Product_element e130 = new MonexaAPI.Product_element();
		MonexaAPI.LIST_BILLING_LINE_ITEMS_element e131 = new MonexaAPI.LIST_BILLING_LINE_ITEMS_element();
		MonexaAPI.Invoice_Due_Date_element e132 = new MonexaAPI.Invoice_Due_Date_element();
		MonexaAPI.Response_LOOKUP_OFFICE_element e133 = new MonexaAPI.Response_LOOKUP_OFFICE_element();
		MonexaAPI.Failed_Credit_element e134 = new MonexaAPI.Failed_Credit_element();
		MonexaAPI.DeletePlanRequest_element e135 = new MonexaAPI.DeletePlanRequest_element();
		MonexaAPI.Response_LIST_ACCOUNT_HISTORY_element e136 = new MonexaAPI.Response_LIST_ACCOUNT_HISTORY_element();
		MonexaAPI.UPD_SUB_ACCOUNT_INFORMATION_TYPE e137 = new MonexaAPI.UPD_SUB_ACCOUNT_INFORMATION_TYPE();
		MonexaAPI.LOOKUP_PROVIDER_LIST_SERVICE_GROUPS_TYPE e138 = new MonexaAPI.LOOKUP_PROVIDER_LIST_SERVICE_GROUPS_TYPE();
		MonexaAPI.Statement_Detail_element e139 = new MonexaAPI.Statement_Detail_element();
		MonexaAPI.CreateAccountHistoryRequest_element e140 = new MonexaAPI.CreateAccountHistoryRequest_element();
		MonexaAPI.Response_SEARCH_PLAN_element e141 = new MonexaAPI.Response_SEARCH_PLAN_element();
		MonexaAPI.Response_PROCESS_PROFORMA_INVOICE_element e142 = new MonexaAPI.Response_PROCESS_PROFORMA_INVOICE_element();
		MonexaAPI.REP_SEARCH_PLAN_SERVICE_GROUP_TYPE e143 = new MonexaAPI.REP_SEARCH_PLAN_SERVICE_GROUP_TYPE();
		MonexaAPI.ListUsageDataRequest_element e144 = new MonexaAPI.ListUsageDataRequest_element();
		MonexaAPI.REP_LOOKUP_PROVIDER_PROVIDER_TYPE e145 = new MonexaAPI.REP_LOOKUP_PROVIDER_PROVIDER_TYPE();
		MonexaAPI.Response_PING_element e146 = new MonexaAPI.Response_PING_element();
		MonexaAPI.LOOKUP_PROVIDER_element e147 = new MonexaAPI.LOOKUP_PROVIDER_element();
		MonexaAPI.CRE_PLAN_PLAN_SERVICE_TYPE e148 = new MonexaAPI.CRE_PLAN_PLAN_SERVICE_TYPE();
		MonexaAPI.Last_Payment_Date_element e149 = new MonexaAPI.Last_Payment_Date_element();
		MonexaAPI.Response_LOOKUP_PLAN_element e150 = new MonexaAPI.Response_LOOKUP_PLAN_element();
		MonexaAPI.Usage_Data_element e151 = new MonexaAPI.Usage_Data_element();
		MonexaAPI.Response_GET_ADMINISTRATOR_INFO_element e152 = new MonexaAPI.Response_GET_ADMINISTRATOR_INFO_element();
		MonexaAPI.UPD_SUB_CONTACT_INFORMATION_TYPE e153 = new MonexaAPI.UPD_SUB_CONTACT_INFORMATION_TYPE();
		MonexaAPI.Response_Status_element e154 = new MonexaAPI.Response_Status_element();
		MonexaAPI.Service_element e155 = new MonexaAPI.Service_element();
		MonexaAPI.Failed_Payment_element e156 = new MonexaAPI.Failed_Payment_element();
		MonexaAPI.Response_LOOKUP_PRODUCT_element e157 = new MonexaAPI.Response_LOOKUP_PRODUCT_element();
		MonexaAPI.REP_LIST_PLANS_PLAN_SERVICE_TYPE e158 = new MonexaAPI.REP_LIST_PLANS_PLAN_SERVICE_TYPE();
		MonexaAPI.Plan_Service_element e159 = new MonexaAPI.Plan_Service_element();
		MonexaAPI.REP_CRE_SUB_PRICE_BOOK_TYPE e160 = new MonexaAPI.REP_CRE_SUB_PRICE_BOOK_TYPE();
		MonexaAPI.REP_CRE_SUB_PLAN_SERVICE_TYPE e161 = new MonexaAPI.REP_CRE_SUB_PLAN_SERVICE_TYPE();
		MonexaAPI.Payment_Map_element e162 = new MonexaAPI.Payment_Map_element();
		MonexaAPI.Related_Invoice_element e163 = new MonexaAPI.Related_Invoice_element();
		MonexaAPI.LIST_STATEMENTS_element e164 = new MonexaAPI.LIST_STATEMENTS_element();
		MonexaAPI.Billed_Up_To_Date_element e165 = new MonexaAPI.Billed_Up_To_Date_element();
		MonexaAPI.ListProvidersRequest_element e166 = new MonexaAPI.ListProvidersRequest_element();
		MonexaAPI.CRE_SUB_PLAN_DISCOUNT_TYPE e167 = new MonexaAPI.CRE_SUB_PLAN_DISCOUNT_TYPE();
		MonexaAPI.UPD_SUB_SERVICE_GROUP_TYPE e168 = new MonexaAPI.UPD_SUB_SERVICE_GROUP_TYPE();
		MonexaAPI.REP_LOOKUP_OFFICE_OFFICE_TYPE e169 = new MonexaAPI.REP_LOOKUP_OFFICE_OFFICE_TYPE();
		MonexaAPI.Response_LIST_PERMISSIONS_element e170 = new MonexaAPI.Response_LIST_PERMISSIONS_element();
		MonexaAPI.LIST_PRICE_BOOKS_element e171 = new MonexaAPI.LIST_PRICE_BOOKS_element();
		MonexaAPI.Credit_element e172 = new MonexaAPI.Credit_element();
		MonexaAPI.LIST_USAGE_DATA_element e173 = new MonexaAPI.LIST_USAGE_DATA_element();
		MonexaAPI.LOOKUP_OFFICE_element e174 = new MonexaAPI.LOOKUP_OFFICE_element();
		MonexaAPI.REP_LOOKUP_PLAN_PLAN_TYPE e175 = new MonexaAPI.REP_LOOKUP_PLAN_PLAN_TYPE();
		MonexaAPI.LIST_PROVIDERS_LIST_SERVICE_GROUPS_TYPE e176 = new MonexaAPI.LIST_PROVIDERS_LIST_SERVICE_GROUPS_TYPE();
		MonexaAPI.Pre_Payment_element e177 = new MonexaAPI.Pre_Payment_element();
		MonexaAPI.Event_Date_element e178 = new MonexaAPI.Event_Date_element();
		MonexaAPI.REP_CRE_SUB_ACT_PLAN_TYPE e179 = new MonexaAPI.REP_CRE_SUB_ACT_PLAN_TYPE();
		MonexaAPI.Response_PROCESS_TRANSACTION_element e180 = new MonexaAPI.Response_PROCESS_TRANSACTION_element();
		MonexaAPI.CREATE_PRICE_SHEET_element e181 = new MonexaAPI.CREATE_PRICE_SHEET_element();
		MonexaAPI.LOOKUP_PROVIDER_LIST_OFFICES_TYPE e182 = new MonexaAPI.LOOKUP_PROVIDER_LIST_OFFICES_TYPE();
		MonexaAPI.Response_LIST_OFFICES_element e183 = new MonexaAPI.Response_LIST_OFFICES_element();
		MonexaAPI.LIST_PRODUCTS_element e184 = new MonexaAPI.LIST_PRODUCTS_element();
		MonexaAPI.UPD_SUB_PRICE_BOOK_TYPE e185 = new MonexaAPI.UPD_SUB_PRICE_BOOK_TYPE();
		MonexaAPI.CreateBillableEvent_element e186 = new MonexaAPI.CreateBillableEvent_element();
		MonexaAPI.CRE_PLAN_TYPE e187 = new MonexaAPI.CRE_PLAN_TYPE();
		MonexaAPI.Usage_Service_element e188 = new MonexaAPI.Usage_Service_element();
		MonexaAPI.Category_element e189 = new MonexaAPI.Category_element();
		MonexaAPI.LOOKUP_STATEMENT_element e190 = new MonexaAPI.LOOKUP_STATEMENT_element();
		MonexaAPI.Response_VALIDATE_SESSION_KEY_element e191 = new MonexaAPI.Response_VALIDATE_SESSION_KEY_element();
		MonexaAPI.LookupStatementRequest_element e192 = new MonexaAPI.LookupStatementRequest_element();
		MonexaAPI.SuccessResponse_element e193 = new MonexaAPI.SuccessResponse_element();
		MonexaAPI.CHK_PWD_ACCOUNT_INFORMATION_TYPE e194 = new MonexaAPI.CHK_PWD_ACCOUNT_INFORMATION_TYPE();
		MonexaAPI.Local_Event_End_Time_element e195 = new MonexaAPI.Local_Event_End_Time_element();
		MonexaAPI.Office_element e196 = new MonexaAPI.Office_element();
		MonexaAPI.CREATE_BILLING_LINE_ITEM_element e197 = new MonexaAPI.CREATE_BILLING_LINE_ITEM_element();
		MonexaAPI.Date_Time_element e198 = new MonexaAPI.Date_Time_element();
		MonexaAPI.CREATE_INVOICE_element e199 = new MonexaAPI.CREATE_INVOICE_element();
		MonexaAPI.LOOKUP_INVOICE_element e200 = new MonexaAPI.LOOKUP_INVOICE_element();
		MonexaAPI.LIST_PROVIDERS_LIST_PLANS_TYPE e201 = new MonexaAPI.LIST_PROVIDERS_LIST_PLANS_TYPE();
		MonexaAPI.Response_LIST_PRODUCTS_element e202 = new MonexaAPI.Response_LIST_PRODUCTS_element();
		MonexaAPI.CREATE_PLAN_element e203 = new MonexaAPI.CREATE_PLAN_element();
		MonexaAPI.ListPlansRequest_element e204 = new MonexaAPI.ListPlansRequest_element();
		MonexaAPI.CRE_PRICE_BOOK_PRICE_SHEET_TYPE e205 = new MonexaAPI.CRE_PRICE_BOOK_PRICE_SHEET_TYPE();
		MonexaAPI.CRE_PLAN_SERVICE_TYPE e206 = new MonexaAPI.CRE_PLAN_SERVICE_TYPE();
		MonexaAPI.LookupInvoiceRequest_element e207 = new MonexaAPI.LookupInvoiceRequest_element();
		MonexaAPI.Response_LOOKUP_PRICE_BOOK_element e208 = new MonexaAPI.Response_LOOKUP_PRICE_BOOK_element();
		MonexaAPI.Response_LIST_PROVIDERS_element e209 = new MonexaAPI.Response_LIST_PROVIDERS_element();
		MonexaAPI.ListOfficesRequest_element e210 = new MonexaAPI.ListOfficesRequest_element();
		MonexaAPI.CreatePriceBookRequest_element e211 = new MonexaAPI.CreatePriceBookRequest_element();
		MonexaAPI.REP_SEARCH_PLAN_SERVICE_TYPE e212 = new MonexaAPI.REP_SEARCH_PLAN_SERVICE_TYPE();
    }
}