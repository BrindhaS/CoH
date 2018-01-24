global class MonexaServices {

	///////////////////////////////////////////////////////////////////////////
	// 					         Authentication                              //
	///////////////////////////////////////////////////////////////////////////

	global class AccountNamespaceElement {
		public MonexaAPI.Account_Namespace_element an;
		
		global AccountNamespaceElement() {
			an = new MonexaAPI.Account_Namespace_element();
		}
		
	}
		
	global class AuthenticationElement {
		public MonexaAPI.Authentication_element auth;
		
		
		global AuthenticationElement() {
			auth = new MonexaAPI.Authentication_element();
		}
		
        global String account_id {
        	get {
        		return auth.account_id;
        	}
        	set {
        		auth.account_id = value;
        		auth.administrator_login_name = null;
        		auth.Account_Namespace = null;
        	}
        }
        global String administrator_login_name {
        	get {
        		return auth.administrator_login_name;
        	}
        	set {
        		auth.administrator_login_name = value;
        		auth.account_id = null;
        		auth.Account_Namespace = null;
        	}
        }
        global MonexaAPI.Account_Namespace_element Account_Namespace {
        	get {
        		return auth.account_namespace;
        	}
        	set {
        		auth.administrator_login_name = null;
        		auth.account_id = null;
        		auth.Account_Namespace = value;
        	}
        }
        global String password {
        	get { return auth.password; }
        	set { auth.password = value; }        		
        }
		
	}
	///////////////////////////////////////////////////////////////////////////
	// 					      End Authentication                             //
	///////////////////////////////////////////////////////////////////////////
		

	///////////////////////////////////////////////////////////////////////////
	// 					       GET_SESSION_KEY                               //
	///////////////////////////////////////////////////////////////////////////
	
	global class SessionKeyElement extends MonexaElement {
        private MonexaAPI.Session_Key_element ske;
        
        public SessionKeyElement(MonexaAPI.Session_Key_element resp) {
        	ske = resp;
        }
        
        global String session_key {get { return ske.session_key; }}
        global String account_id {get { return ske.account_id; }}
        global String session_type {get {return ske.session_type;}}
        global String session_information {get {return ske.session_information;}}
        global Integer session_key_expiry_minutes {get {return Integer.valueOf(ske.session_key_expiry_minutes);}}
	}
	///////////////////////////////////////////////////////////////////////////
	// 					     End GET_SESSION_KEY                             //
	///////////////////////////////////////////////////////////////////////////
	
	
	///////////////////////////////////////////////////////////////////////////
	// 					      LOOKUP_SUBSCRIBER                              //
	///////////////////////////////////////////////////////////////////////////
	global class DiscountInfoElement {
		public MonexaAPI.Discount_Info_element InnerObj;
		public DiscountInfoElement(MonexaAPI.Discount_Info_element e) {
			InnerObj = e;
		}		
        global String billing_frequency { get {return InnerObj.billing_frequency;}  set {InnerObj.billing_frequency = value; }}
        global String discount_option { get {return InnerObj.discount_option;}  set {InnerObj.discount_option = value; }}
        global String discount_rate { get {return InnerObj.discount_rate;}  set {InnerObj.discount_rate = value; }}
        global String setup_fee_discount { get {return InnerObj.setup_fee_discount;}  set {InnerObj.setup_fee_discount = value; }}
        global String status { get {return InnerObj.status;}  set {InnerObj.status = value; }}
		
		
	}
	global class PlanDiscountType {
		public MonexaAPI.Plan_Discount_Type_element discountType;
				
		public PlanDiscountType() {
			discountType = new MonexaAPI.Plan_Discount_Type_element();
		}
		public PlanDiscountType(MonexaAPI.REP_LOOK_SUB_PLAN_DISCOUNT_TYPE discount_type) {
			discountType = new MonexaAPI.Plan_Discount_Type_element();
			discountType.discount_type_id = discount_type.discount_type_id;
			
			
		}
		public PlanDiscountType(MonexaAPI.Plan_Discount_Type_element discount_type) {
			discountType = discount_type;
			if(discount_type.Discount_Info != null) {
				Discount_Info = new List<DiscountInfoElement>();
				for(MonexaAPI.Discount_Info_element discount : discount_type.Discount_Info) {
					Discount_Info.add(new DiscountInfoElement(discount));
				}
			}
		}
		global string discount_type_id { 
			get {
				return discountType.discount_type_id;
			}
			set {
				
				discountType.discount_type_id = value;
			}
		}
		global List<MonexaServices.DiscountInfoElement> Discount_Info {get; set;} 
	}
	global class ServiceGroupType {
		public ServiceGroupType(MonexaAPI.REP_LOOK_SUB_SERVICE_GROUP_TYPE rlssgt) {
			service_group_id = rlssgt.service_group_id;
			description = rlssgt.description;
		}
		global String service_group_id {get; set;}
		global String description {get; set;}
		
	}
	global class PlanServiceType {
		global ServiceGroupType Service_Group {get; set;}
		
		public PlanServiceType(MonexaAPI.REP_LOOK_SUB_PLAN_SERVICE_TYPE planServType) {
			Service_Group = new MonexaServices.ServiceGroupType(planServType.Service_Group);			
		} 
	}
    global class SubscriberAccountPlan {
    	private MonexaAPI.REP_LOOK_SUB_ACT_PLAN_TYPE actPlan {get; set;}
    
    	public SubscriberAccountPlan(MonexaAPI.REP_LOOK_SUB_ACT_PLAN_TYPE aPlan) {
    		actPlan = aPlan;
    		Plan_Discount_Type = new PlanDiscountType(aPlan.Plan_Discount_Type);
    		Plan_Service = new List<MonexaServices.PlanServiceType>();
    		if(aPlan.Plan_Service != null) {
	    		for(MonexaAPI.REP_LOOK_SUB_PLAN_SERVICE_TYPE servType : aPlan.Plan_Service) {
	    			Plan_Service.add(new MonexaServices.PlanServiceType(servType));
	    		}
    		}
    		
    	}
    	
        global String provider_id { get {return actPlan.provider_id;} private set {actPlan.provider_id = value; }}
        global String plan_id { get {return actPlan.plan_id;} private set {actPlan.plan_id = value; }}
        global String name { get {return actPlan.name;} private set {actPlan.name = value; }}
        
        private MonexaServices.PlanDiscountType planDiscountType = null;
        global MonexaServices.PlanDiscountType Plan_Discount_Type {
        	get {
        		return planDiscountType;
        	} 
        	private set {
        		if(value == null) {
        			planDiscountType = null;
        			actPlan.Plan_Discount_Type = null;
        		} else {
        			planDiscountType = value;
        			actPlan.Plan_Discount_Type = new MonexaAPI.REP_LOOK_SUB_PLAN_DISCOUNT_TYPE();
        			actPlan.Plan_Discount_Type.discount_type_id = planDiscountType.discountType.discount_type_id;
        		}
        	}
        }
        global List<MonexaServices.PlanServiceType> Plan_Service {get; private set; }               
    }
	
	global class LookupSubscriberAccountInformation {
		private MonexaAPI.REP_LOOK_SUB_ACCOUNT_INFORMATION_TYPE acctInfo {get; set;}
		
		public LookupSubscriberAccountInformation(MonexaAPI.REP_LOOK_SUB_ACCOUNT_INFORMATION_TYPE aInfo) {
			acctInfo = aInfo;
			Plan = new MonexaServices.SubscriberAccountPlan(aInfo.Plan);
		}
		
        global String account_id { get {return acctInfo.account_id;} set {acctInfo.account_id = value; }}
        global String login_id { get {return acctInfo.login_id;} set {acctInfo.login_id = value; }}
        global String external_group_id { get {return acctInfo.external_group_id;} set {acctInfo.external_group_id = value; }}
        global String provider_id { get {return acctInfo.provider_id;} set {acctInfo.provider_id = value; }}
        global String provider_name { get {return acctInfo.provider_name;} set {acctInfo.provider_name = value; }}
        global String office_id { get {return acctInfo.office_id;} set {acctInfo.office_id = value; }}
        global String office_name { get {return acctInfo.office_name;} set {acctInfo.office_name = value; }}
        global MonexaServices.SubscriberAccountPlan Plan {get; set;}
        global String account_status { get {return acctInfo.account_status;} set {acctInfo.account_status = value; }}
        global String account_status_note { get {return acctInfo.account_status_note;} set {acctInfo.account_status_note = value; }}
        global String cancellation_reason { get {return acctInfo.cancellation_reason;} set {acctInfo.cancellation_reason = value; }}
        global String invoice_notify_flag { get {return acctInfo.invoice_notify_flag;} set {acctInfo.invoice_notify_flag = value; }}
        global String statement_notify_flag { get {return acctInfo.statement_notify_flag;} set {acctInfo.statement_notify_flag = value; }}
        global String sales_representative_name { get {return acctInfo.sales_representative_name;} set {acctInfo.sales_representative_name = value; }}
        global String sales_representative_email { get {return acctInfo.sales_representative_email;} set {acctInfo.sales_representative_email = value; }}
        global String promo_code { get {return acctInfo.promo_code;} set {acctInfo.promo_code = value; }}
		
	}
	global class AddressElement {
		public MonexaAPI.Address_element address_element = null;
		
		global AddressElement() {
			address_element = new MonexaAPI.Address_element();
		}
    	public AddressElement(MonexaAPI.Address_element addr) {
    		address_element = addr;
    	}
        global String address_1 { get {return address_element.address_1;}  set { address_element.address_1 = value; }}
        global String address_2 { get {return address_element.address_2;}  set { address_element.address_2 = value; }}
        global String address_3 { get {return address_element.address_3;}  set { address_element.address_3 = value; }}
        global String address_4 { get {return address_element.address_4;}  set { address_element.address_4 = value; }}
        global String city { get {return address_element.city;}  set { address_element.city = value; }}
        global String state_or_province { get {return address_element.state_or_province;}  set { address_element.state_or_province = value; }}
        global String zip_or_postal_code { get {return address_element.zip_or_postal_code;}  set { address_element.zip_or_postal_code = value; }}
        global String country { get {return address_element.country;}  set { address_element.country = value; }}
	
	}
	global class LookupSubscriberContactInformation  {
		private MonexaAPI.REP_LOOK_SUB_CONTACT_INFORMATION_TYPE contactInfo;
		public LookupSubscriberContactInformation(MonexaAPI.REP_LOOK_SUB_CONTACT_INFORMATION_TYPE conInfo) {
			contactInfo = conInfo;
			if(conInfo.Bill_To_Address != null)
				Bill_To_Address = new MonexaServices.AddressElement(conInfo.Bill_To_Address.Address);
			if(conInfo.Ship_To_Address != null)
				Ship_To_Address = new MonexaServices.AddressElement(conInfo.Ship_To_Address.Address);
		}
		 
        global String first_name { get {return contactInfo.first_name;} private set {contactInfo.first_name = value; }}
        global String last_name { get {return contactInfo.last_name;} private set {contactInfo.last_name = value; }}
        global String company { get {return contactInfo.company;} private set {contactInfo.company = value; }}
        global String contact_email { get {return contactInfo.contact_email;} private set {contactInfo.contact_email = value; }}
        global MonexaServices.AddressElement Bill_To_Address { get; private set; }
        global MonexaServices.AddressElement Ship_To_Address { get; private set; }
        global String timezone { get {return contactInfo.timezone;} private set {contactInfo.timezone = value; }}
        global String phone_number_1 { get {return contactInfo.phone_number_1;} private set {contactInfo.phone_number_1 = value; }}
        global String phone_number_2 { get {return contactInfo.phone_number_2;} private set {contactInfo.phone_number_2 = value; }}
        global String fax_number { get {return contactInfo.fax_number;} private set {contactInfo.fax_number = value; }}
        global String notes { get {return contactInfo.notes;} private set {contactInfo.notes = value; }}
        global String external_account_id { get {return contactInfo.external_account_id;} private set {contactInfo.external_account_id = value; }}
        global String language { get {return contactInfo.language;} private set {contactInfo.language = value; }}
        global String verification_question { get {return contactInfo.verification_question;} private set {contactInfo.verification_question = value; }}
        global String verification_answer { get {return contactInfo.verification_answer;} private set {contactInfo.verification_answer = value; }}
        global String receive_provider_marketing { get {return contactInfo.receive_provider_marketing;} private set {contactInfo.receive_provider_marketing = value; }}
        global String receive_third_party_marketing { get {return contactInfo.receive_third_party_marketing;} private set {contactInfo.receive_third_party_marketing = value; }}
        global String master_account_id { get {return contactInfo.master_account_id;} private set {contactInfo.master_account_id = value; }}
        global String referral { get {return contactInfo.referral;} private set {contactInfo.referral = value; }}
        global String custom_field_1 { get {return contactInfo.custom_field_1;} private set {contactInfo.custom_field_1 = value; }}
        global String custom_field_2 { get {return contactInfo.custom_field_2;} private set {contactInfo.custom_field_2 = value; }}
        global String custom_field_3 { get {return contactInfo.custom_field_3;} private set {contactInfo.custom_field_3 = value; }}
        global String custom_field_4 { get {return contactInfo.custom_field_4;} private set {contactInfo.custom_field_4 = value; }}
        global String custom_field_5 { get {return contactInfo.custom_field_5;} private set {contactInfo.custom_field_5 = value; }}
        global String custom_field_6 { get {return contactInfo.custom_field_6;} private set {contactInfo.custom_field_6 = value; }}
	}

    global class LookupSubscriberPriceBookType {
    	private MonexaAPI.REP_LOOK_SUB_PRICE_BOOK_TYPE pbType;
    	
    	public LookupSubscriberPriceBookType(MonexaAPI.REP_LOOK_SUB_PRICE_BOOK_TYPE pb_type) {
    		pbType = pb_type;
    	}
        global String internal_price_book_id { get {return pbType.internal_price_book_id;} private set {pbType.internal_price_book_id = value; }}
        global String price_book_id { get {return pbType.price_book_id;} private set {pbType.price_book_id = value; }}
        global String price_book_name { get {return pbType.price_book_name;} private set {pbType.price_book_name = value; }}        
    
    }
    
	
	global class LookupSubscriberBillingInformation {
		private MonexaAPI.REP_LOOK_SUB_BILLING_INFORMATION_TYPE billingInfo {get; set;}

		public LookupSubscriberBillingInformation(MonexaAPI.REP_LOOK_SUB_BILLING_INFORMATION_TYPE bInfo) {
			billingInfo = bInfo;
			if(bInfo.Credit_Card_Information != null)
				Credit_Card_Information = new MonexaServices.CreditCardInformationElement(bInfo.Credit_Card_Information);
			if(bInfo.Bank_Account_Information != null)
				Bank_Account_Information = new MonexaServices.BankAccountInformationElement(bInfo.Bank_Account_Information);
			if(bInfo.PayPal_Information != null)
				PayPal_Information = new MonexaServices.PayPalInformationElement(bInfo.PayPal_Information);
			if(bInfo.Start_Date != null)
				Start_Date = MXA_APIHelper.convertDate(bInfo.Start_Date.Date_x);
			if(bInfo.Expiry_Date != null)
				Expiry_Date = MXA_APIHelper.convertDate(bInfo.Expiry_Date.Date_x);
			if(bInfo.Billed_Up_To_Date != null)
				Billed_Up_To_Date = MXA_APIHelper.convertDate(bInfo.Billed_Up_To_Date.Date_x);
			if(bInfo.Overtime_Billed_Up_To_Date != null)
				Overtime_Billed_Up_To_Date = MXA_APIHelper.convertDate(bInfo.Overtime_Billed_Up_To_Date.Date_x);
			if(bInfo.Last_Payment_Attempt_Date != null)
				Last_Payment_Attempt_Date = MXA_APIHelper.convertDate(bInfo.Last_Payment_Attempt_Date.Date_x);
			if(bInfo.Last_Payment_Date != null)
				Last_Payment_Date = MXA_APIHelper.convertDate(bInfo.Last_Payment_Date.Date_x);
			if(bInfo.Earliest_Amount_Owing_Date != null)
				Earliest_Amount_Owing_Date = MXA_APIHelper.convertDate(bInfo.Earliest_Amount_Owing_Date.Date_x);
			if(bInfo.Trial_Balance_Date != null)
				Trial_Balance_Date = MXA_APIHelper.convertDate(bInfo.Trial_Balance_Date.Date_x);
			if(bInfo.Auto_Pay_Run_Date != null)
				Auto_Pay_Run_Date = MXA_APIHelper.convertDate(bInfo.Auto_Pay_Run_Date.Date_x);
			
			Price_Book = new MonexaServices.LookupSubscriberPriceBookType(bInfo.Price_Book);
			
		}
		
        global String payment_method { get {return billingInfo.payment_method;} private set {billingInfo.payment_method = value; }}
        
        global MonexaServices.CreditCardInformationElement Credit_Card_Information { get; set;}
        global MonexaServices.BankAccountInformationElement Bank_Account_Information {get; set;}
        global MonexaServices.PayPalInformationElement PayPal_Information {get; set;}
        
        
        global Date Start_Date { get; private set;}
        global Date Expiry_Date { get; private set;}
        global String billing_day { get {return billingInfo.billing_day;} private set {billingInfo.billing_day = value; }}
        global String billing_frequency { get {return billingInfo.billing_frequency;} private set {billingInfo.billing_frequency = value; }}
        global String contract_term { get {return billingInfo.contract_term;} private set {billingInfo.contract_term = value; }}
        global String currency_x { get {return billingInfo.currency_x;} private set {billingInfo.currency_x = value; }}

        global MonexaServices.LookupSubscriberPriceBookType Price_Book {get; set;}

        global Date Billed_Up_To_Date { get; private set; }
        global Date Overtime_Billed_Up_To_Date { get; private set; }
        global Date Last_Payment_Attempt_Date { get; private set; }
        global String last_payment_amount { get {return billingInfo.last_payment_amount;} private set {billingInfo.last_payment_amount = value; }}
        global Date Last_Payment_Date { get; private set; }
        global Integer number_failed_payment_attempts { get {return billingInfo.number_failed_payment_attempts;} private set {billingInfo.number_failed_payment_attempts = value; }}
        global String current_balance { get {return billingInfo.current_balance;} private set {billingInfo.current_balance = value; }}
        global Date Earliest_Amount_Owing_Date { get; private set; }
        global String tax1_exempt { get {return billingInfo.tax1_exempt;} private set {billingInfo.tax1_exempt = value; }}
        global String tax2_exempt { get {return billingInfo.tax2_exempt;} private set {billingInfo.tax2_exempt = value; }}
        global String setup_fee_applied_flag { get {return billingInfo.setup_fee_applied_flag;} private set {billingInfo.setup_fee_applied_flag = value; }}
        global String po_number { get {return billingInfo.po_number;} private set {billingInfo.po_number = value; }}
        global String collection_status { get {return billingInfo.collection_status;} private set {billingInfo.collection_status = value; }}
        global String credit_limit { get {return billingInfo.credit_limit;} private set {billingInfo.credit_limit = value; }}
        global String trial_balance { get {return billingInfo.trial_balance;} private set {billingInfo.trial_balance = value; }}
        global Date Trial_Balance_Date { get; private set; }
        global String contract_minimum { get {return billingInfo.contract_minimum;} private set {billingInfo.contract_minimum = value; }}
        global String auto_pay_day { get {return billingInfo.auto_pay_day;} private set {billingInfo.auto_pay_day = value; }}
        global Date Auto_Pay_Run_Date { get; private set; }		
	}	

	global class LookupSubscriberInformationElement extends MonexaElement {
							
		public LookupSubscriberInformationElement(MonexaAPI.REP_LOOK_SUB_SUBSCRIBER_INFORMATION_TYPE sInfo) {			
			Account_Information = new LookupSubscriberAccountInformation(sInfo.Account_Information);
			Billing_Information = new LookupSubscriberBillingInformation(sInfo.Billing_Information);
			Contact_Information = new LookupSubscriberContactInformation(sInfo.Contact_Information);
		}	


		
        global LookupSubscriberAccountInformation Account_Information {get; set;}
        global LookupSubscriberBillingInformation Billing_Information {get; set;}
        global LookupSubscriberContactInformation Contact_Information {get; set;}
		
	}
	///////////////////////////////////////////////////////////////////////////
	// 					    End LOOKUP_SUBSCRIBER                            //
	///////////////////////////////////////////////////////////////////////////



	///////////////////////////////////////////////////////////////////////////
	// 					       SEARCH_SUBSCRIBER                             //
	///////////////////////////////////////////////////////////////////////////
	global class SearchSubscriberContactInformation  {
		private MonexaAPI.REP_SEA_SUB_CONTACT_INFORMATION_TYPE contactInfo;
		public SearchSubscriberContactInformation(MonexaAPI.REP_SEA_SUB_CONTACT_INFORMATION_TYPE conInfo) {
			contactInfo = conInfo;

		}
		 
        global String first_name { get {return contactInfo.first_name;} private set {contactInfo.first_name = value; }}
        global String last_name { get {return contactInfo.last_name;} private set {contactInfo.last_name = value; }}
        global String company { get {return contactInfo.company;} private set {contactInfo.company = value; }}
        global String phone_number_1 { get {return contactInfo.phone_number_1;} private set {contactInfo.phone_number_1 = value; }}
        global String external_account_id { get {return contactInfo.external_account_id;} private set {contactInfo.external_account_id = value; }}
        global String language { get {return contactInfo.language;} private set {contactInfo.language = value; }}
        global String master_account_id { get {return contactInfo.master_account_id;} private set {contactInfo.master_account_id = value; }}
        
	}
	global class SearchSubscriberAccountInformation {
		private MonexaAPI.REP_SEA_SUB_ACCOUNT_INFORMATION_TYPE acctInfo {get; set;}
		
		public SearchSubscriberAccountInformation(MonexaAPI.REP_SEA_SUB_ACCOUNT_INFORMATION_TYPE aInfo) {
			acctInfo = aInfo;
		}
		
        global String account_id { get {return acctInfo.account_id;} set {acctInfo.account_id = value; }}
        global String login_id { get {return acctInfo.login_id;} set {acctInfo.login_id = value; }}
        global String external_group_id { get {return acctInfo.external_group_id;} set {acctInfo.external_group_id = value; }}
        global String provider_id { get {return acctInfo.provider_id;} set {acctInfo.provider_id = value; }}
        global String provider_name { get {return acctInfo.provider_name;} set {acctInfo.provider_name = value; }}
        global String office_id { get {return acctInfo.office_id;} set {acctInfo.office_id = value; }}
        global String office_name { get {return acctInfo.office_name;} set {acctInfo.office_name = value; }}        
        global String account_status { get {return acctInfo.account_status;} set {acctInfo.account_status = value; }}
		
	}
	
	global class SearchSubscriberInformationElement extends MonexaElement {
        global SearchSubscriberAccountInformation Account_Information {get; set;}
        global SearchSubscriberContactInformation Contact_Information {get; set;}
	
    	public SearchSubscriberInformationElement(MonexaAPI.REP_SEA_SUB_SUBSCRIBER_INFORMATION_TYPE sInfo) {
    		Account_Information = new SearchSubscriberAccountInformation(sInfo.Account_Information);
    		Contact_Information = new SearchSubscriberContactInformation(sInfo.Contact_Information);
        }
	}
	///////////////////////////////////////////////////////////////////////////
	// 					    End SEARCH_SUBSCRIBER                            //
	///////////////////////////////////////////////////////////////////////////
		
	///////////////////////////////////////////////////////////////////////////
	// 					       CREATE_SUBSCRIBER                             //
	///////////////////////////////////////////////////////////////////////////
	global class CreateSubscriberServiceType {
		public MonexaAPI.CRE_SUB_SERVICE_TYPE Service;
		
		public CreateSubscriberServiceType() {
			Service = new MonexaAPI.CRE_SUB_SERVICE_TYPE();
			Service.Service_Parameter = new List<MonexaAPI.Service_Parameter_element>();
		}

        global String service_id { get { return Service.service_id; } set { Service.service_id = value; } }
		global void addServiceParameter(string attribute, string val) {
			MonexaAPI.Service_Parameter_element spe = new MonexaAPI.Service_Parameter_element();
			spe.service_parameter_attribute = attribute;
			spe.service_parameter_value = val;
			Service.Service_Parameter.add(spe);
		}
	}
    global class CreateSubscriberServiceGroupType {
        public MonexaAPI.CRE_SUB_SERVICE_GROUP_TYPE Service_Group;
		public CreateSubscriberServiceGroupType() {
			Service_Group = new MonexaAPI.CRE_SUB_SERVICE_GROUP_TYPE();
			Service = new MonexaServices.CreateSubscriberServiceType();
			Service_Group.Service = Service.Service;
		}
				  
        global String service_group_id { 
        	get { return Service_Group.service_group_id; } 
        	set { Service_Group.service_group_id = value; } 
        }
        global MonexaServices.CreateSubscriberServiceType Service { get; set; }
	}
	
	/**
	  * User of MonexaServices needs to be able to create these as CreateSubscriberAccountInformationElement
	  * contains a list of them.
	  */
	global class CreateSubscriberPlanServiceType {
		public MonexaAPI.CRE_SUB_PLAN_SERVICE_TYPE Plan_Service;
		
		global CreateSubscriberPlanServiceType() {
			Plan_Service = new MonexaAPI.CRE_SUB_PLAN_SERVICE_TYPE();
			Service_Group = new CreateSubscriberServiceGroupType();
			Plan_Service.Service_Group = Service_Group.Service_Group;		
		}
		global MonexaServices.CreateSubscriberServiceGroupType Service_Group {get; set;}
		
	}
	global class CreateSubscriberPlanDiscountType {
	
		public MonexaAPI.CRE_SUB_PLAN_DISCOUNT_TYPE Plan_Discount_Type;
		
		public CreateSubscriberPlanDiscountType() {
			Plan_Discount_Type = new MonexaAPI.CRE_SUB_PLAN_DISCOUNT_TYPE();
		}
		
		global String discount_type_id {
			get {
				return Plan_Discount_type.discount_type_id; 
			} 
			set { 
				Plan_Discount_Type.discount_type_id = value; 
			} 
		}
	}
	 
	global class CreateSubscriberAccountPlanType {
    	public MonexaAPI.CRE_SUB_ACT_PLAN_TYPE acctType;
        
        public CreateSubscriberAccountPlanType() {
        	acctType = new MonexaAPI.CRE_SUB_ACT_PLAN_TYPE();        	
        	Plan_Discount_Type = null;
        	
        }
        /**
          * Because it contains a list we need to copy the items in that list to a list of MonexaAPI objects
          * in acctType, before we can use acctType.
          */ 
        public void CopyPlanServiceToWrappedObject() {
        	if(Plan_Service != null && Plan_Service.size() > 0) {
	        	acctType.Plan_Service = new List<MonexaAPI.CRE_SUB_PLAN_SERVICE_TYPE>();        	
	        	for(MonexaServices.CreateSubscriberPlanServiceType cspst : Plan_Service) {
	        		cspst.Plan_Service.Service_Group = cspst.Service_Group.Service_Group;
	        		acctType.Plan_Service.add(cspst.Plan_Service);
	        	}
        	}
        }
        
        global String plan_id { get { return acctType.plan_id;} set { acctType.plan_id = value; } }
        
        private MonexaServices.CreateSubscriberPlanDiscountType planDiscountType = null;        
        global MonexaServices.CreateSubscriberPlanDiscountType Plan_Discount_Type {
        	get {
        		if(planDiscountType == null) {
        			planDiscountType = new MonexaServices.CreateSubscriberPlanDiscountType();
        			acctType.Plan_Discount_Type = planDiscountType.Plan_Discount_Type;
        		}
        		return planDiscountType;
        	} 
        	set {        	
        		planDiscountType = value;
        		acctType.Plan_Discount_Type = (value != null) ? planDiscountType.Plan_Discount_Type : null;
        	}
        }
        List<MonexaServices.CreateSubscriberPlanServiceType> planService = null;
        global List<MonexaServices.CreateSubscriberPlanServiceType> Plan_Service {
        	get {
        		if(planService == null) {
        			planService = new List<MonexaServices.CreateSubscriberPlanServiceType>();
        		}        		
        		return planService;
        	}
        	set {
        		planService = value;
        	}
        }
	}
	/**
	  * Parameter for createAccount.
	  */
	global class CreateSubscriberAccountInformationElement {
    	public MonexaAPI.CRE_SUB_ACCOUNT_INFORMATION_TYPE acctInfo;
    	
    	global CreateSubscriberAccountInformationElement() {
    		acctInfo = new MonexaAPI.CRE_SUB_ACCOUNT_INFORMATION_TYPE();
    		this.Plan = new MonexaServices.CreateSubscriberAccountPlanType();
    		acctInfo.Plan = this.Plan.acctType;
    	}
    	
    	
        global String login_id { get {return acctInfo.login_id;}  set {acctInfo.login_id = value; }}
        global String external_group_id { get {return acctInfo.external_group_id;}  set {acctInfo.external_group_id = value; }}
        global String provider_id { get {return acctInfo.provider_id;}  set {acctInfo.provider_id = value; }}
        global String password { get {return acctInfo.password;}  set {acctInfo.password = value; }}
        global String office_id { get {return acctInfo.office_id;}  set {acctInfo.office_id = value; }}
        
        private MonexaServices.CreateSubscriberAccountPlanType plan_x = null;
        global MonexaServices.CreateSubscriberAccountPlanType Plan { 
        	get {
        		if(plan_x == null) {
        			plan_x = new MonexaServices.CreateSubscriberAccountPlanType();
        			acctInfo.Plan = plan_x.acctType;
        		}	
        		return plan_x;
        	} 
        	set {
        		if(value == null) {
        			acctInfo.Plan = null;
        			plan_x = null;
        		} else {
        			plan_x = value;
        			acctInfo.Plan = plan_x.acctType;
        		}
        	}
        }
        
        global String account_status { get {return acctInfo.account_status;}  set {acctInfo.account_status = value; }}
        global String invoice_notify_flag { get {return acctInfo.invoice_notify_flag;}  set {acctInfo.invoice_notify_flag = value; }}
        global String statement_notify_flag { get {return acctInfo.statement_notify_flag;}  set {acctInfo.statement_notify_flag = value; }}
        global String sales_representative_name { get {return acctInfo.sales_representative_name;}  set {acctInfo.sales_representative_name = value; }}
        global String sales_representative_email { get {return acctInfo.sales_representative_email;}  set {acctInfo.sales_representative_email = value; }}
        global String promo_code { get {return acctInfo.promo_code;}  set {acctInfo.promo_code = value; }}	
	}
	global class CreditCardInformationElement {
    	public MonexaAPI.Credit_Card_Information_element Credit_Card_Information;
    	
    	public CreditCardInformationElement() {
    		Credit_Card_Information = new MonexaAPI.Credit_Card_Information_element();
    	}
		public CreditCardInformationElement(MonexaAPI.Credit_Card_Information_element cc_info) {
			Credit_Card_Information = cc_info;
		}
    
        global String credit_card_number { get {return Credit_Card_Information.credit_card_number;}  set {Credit_Card_Information.credit_card_number = value; }}
        global String name_on_credit_card { get {return Credit_Card_Information.name_on_credit_card;}  set {Credit_Card_Information.name_on_credit_card = value; }}
        global String credit_card_expiry_date { get {return Credit_Card_Information.credit_card_expiry_date;}  set {Credit_Card_Information.credit_card_expiry_date = value; }}
        global String card_security_code { get {return Credit_Card_Information.card_security_code;}  set {Credit_Card_Information.card_security_code = value; }}
    }
    	
    global class BankAccountInformationElement {    
    	public MonexaAPI.Bank_Account_Information_element Bank_Account_Information;
    	public BankAccountInformationElement() {
    		Bank_Account_Information = new MonexaAPI.Bank_Account_Information_element();
    	}
    	public BankAccountInformationElement(MonexaAPI.Bank_Account_Information_element ba_info) {
    		Bank_Account_Information = ba_info;
	    }    	
    	
        global String name_of_bank { get {return Bank_Account_Information.name_of_bank;}  set {Bank_Account_Information.name_of_bank = value; }}
        global String country_of_bank { get {return Bank_Account_Information.country_of_bank;}  set {Bank_Account_Information.country_of_bank = value; }}
        global String bank_account_number { get {return Bank_Account_Information.bank_account_number;}  set {Bank_Account_Information.bank_account_number = value; }}
        global String transit_number { get {return Bank_Account_Information.transit_number;}  set {Bank_Account_Information.transit_number = value; }}
        global String routing_number { get {return Bank_Account_Information.routing_number;}  set {Bank_Account_Information.routing_number = value; }}
        global String ecp_authorization { get {return Bank_Account_Information.ecp_authorization;}  set {Bank_Account_Information.ecp_authorization = value; }}
	}

	
	global class PayPalInformationElement {
		public MonexaAPI.PayPal_Information_element PayPal_Information;
        
        public PayPalInformationElement() {
        	PayPal_Information = new MonexaAPI.PayPal_Information_element();
        }

    	public PayPalInformationElement(MonexaAPI.PayPal_Information_element pp_info) {
    		PayPal_Information = pp_info;
    		
    	}        

        global String reference_id { get { return PayPal_Information.reference_id; } set { PayPal_Information.reference_id = value; } }
        global Date Reference_ID_Last_Updated_Date {
        	get {
        		return MXA_APIHelper.convertDate(PayPal_Information.Reference_ID_Last_Updated_Date.Date_x);
        	}
        	set {
        		PayPal_Information.Reference_ID_Last_Updated_Date = new MonexaAPI.Reference_ID_Last_Updated_Date_element();
        		PayPal_Information.Reference_ID_Last_Updated_Date.Date_x = MXA_APIHelper.convertDate(value);
        	}
        }
		
	}
	global class CreateSubscriberPriceBookType {
		public MonexaAPI.CRE_SUB_PRICE_BOOK_TYPE Price_Book;
		global CreateSubscriberPriceBookType() {
			Price_Book = new MonexaAPI.CRE_SUB_PRICE_BOOK_TYPE();
		}
		
		
		global String price_book_id { get { return Price_Book.price_book_id; } set { Price_Book.price_book_id = value; }}
	}
	global class CreateSubscriberBillingInformation {
		public MonexaAPI.CRE_SUB_BILLING_INFORMATION billingInfo;
		
		
		public CreateSubscriberBillingInformation() {
			billingInfo = new MonexaAPI.CRE_SUB_BILLING_INFORMATION();
		}
		
		


        global String payment_method { get {return billingInfo.payment_method;}  set {billingInfo.payment_method = value; }}
        
        private MonexaServices.CreditCardInformationElement ccInfo = null;
        global MonexaServices.CreditCardInformationElement Credit_Card_Information {
        	get { return ccInfo; }
        	set {
        		ccInfo = value;
        		billingInfo.Credit_Card_Information = value.Credit_Card_Information;
        	}
        }
        
        private MonexaServices.BankAccountInformationElement baInfo = null;
        global MonexaServices.BankAccountInformationElement Bank_Account_Information {
        	get { return baInfo; }
        	set {
        		baInfo = value;
        		billingInfo.Bank_Account_Information = value.Bank_Account_Information;
        	}
        }
        
        private MonexaServices.PayPalInformationElement ppInfo = null;
        global MonexaServices.PayPalInformationElement PayPal_Information {
        	get { return ppInfo; }
        	set {
        		ppInfo = value;
        		billingInfo.PayPal_Information = value.PayPal_Information;
        	}
      	}
        
        
        global Date Start_Date { 
        	get { return MXA_APIHelper.convertDate(billingInfo.Start_Date.Date_x);}
        	set { 
    			billingInfo.Start_Date = new MonexaAPI.Start_Date_element();
    		 	billingInfo.Start_Date.Date_x = MXA_APIHelper.convertDate(value);
        	}      	
        }
        global Date Expiry_Date { 
        	get { return MXA_APIHelper.convertDate(billingInfo.Expiry_Date.Date_x);}
        	set { 
    			billingInfo.Expiry_Date = new MonexaAPI.Expiry_Date_element();
    		 	billingInfo.Expiry_Date.Date_x = MXA_APIHelper.convertDate(value);
        	}      	
        }
        
        global String billing_day { get {return billingInfo.billing_day;}  set {billingInfo.billing_day = value; }}
        global String billing_frequency { get {return billingInfo.billing_frequency;}  set {billingInfo.billing_frequency = value; }}
        global String contract_term { get {return billingInfo.contract_term;}  set {billingInfo.contract_term = value; }}
        global String currency_x { get {return billingInfo.currency_x;}  set {billingInfo.currency_x = value; }}
        
        private MonexaServices.CreateSubscriberPriceBookType priceBook = null;
        global MonexaServices.CreateSubscriberPriceBookType Price_Book {
        	get { return priceBook; }
        	set {
        		priceBook = value;
        		billingInfo.Price_Book = value.Price_Book;
        	}
        }
        
        global Date Billed_Up_To_Date { 
        	get { return MXA_APIHelper.convertDate(billingInfo.Billed_Up_To_Date.Date_x);}
        	set { 
    			billingInfo.Billed_Up_To_Date = new MonexaAPI.Billed_Up_To_Date_element();
    		 	billingInfo.Billed_Up_To_Date.Date_x = MXA_APIHelper.convertDate(value);
        	}      	
        }
        global Date Overtime_Billed_Up_To_Date { 
        	get { return MXA_APIHelper.convertDate(billingInfo.Overtime_Billed_Up_To_Date.Date_x);}
        	set { 
    			billingInfo.Overtime_Billed_Up_To_Date = new MonexaAPI.Overtime_Billed_Up_To_Date_element();
    		 	billingInfo.Overtime_Billed_Up_To_Date.Date_x = MXA_APIHelper.convertDate(value);
        	}      	
        }
        global Date Last_Payment_Attempt_Date { 
        	get { return MXA_APIHelper.convertDate(billingInfo.Last_Payment_Attempt_Date.Date_x);}
        	set { 
    			billingInfo.Last_Payment_Attempt_Date = new MonexaAPI.Last_Payment_Attempt_Date_element();
    		 	billingInfo.Last_Payment_Attempt_Date.Date_x = MXA_APIHelper.convertDate(value);
        	}      	
        }
        
        global Integer number_failed_payment_attempts { get {return billingInfo.number_failed_payment_attempts;}  set {billingInfo.number_failed_payment_attempts = value; }}
        global String current_balance { get {return billingInfo.current_balance;}  set {billingInfo.current_balance = value; }}
        global String tax1_exempt { get {return billingInfo.tax1_exempt;}  set {billingInfo.tax1_exempt = value; }}
        global String tax2_exempt { get {return billingInfo.tax2_exempt;}  set {billingInfo.tax2_exempt = value; }}
        global String setup_fee_applied_flag { get {return billingInfo.setup_fee_applied_flag;}  set {billingInfo.setup_fee_applied_flag = value; }}
        global String po_number { get {return billingInfo.po_number;}  set {billingInfo.po_number = value; }}
        global String collection_status { get {return billingInfo.collection_status;}  set {billingInfo.collection_status = value; }}
        global String credit_limit { get {return billingInfo.credit_limit;}  set {billingInfo.credit_limit = value; }}
        global String trial_balance { get {return billingInfo.trial_balance;}  set {billingInfo.trial_balance = value; }}
        
        global Date Trial_Balance_Date { 
        	get { return MXA_APIHelper.convertDate(billingInfo.Trial_Balance_Date.Date_x);}
        	set { 
    			billingInfo.Trial_Balance_Date = new MonexaAPI.Trial_Balance_Date_element();
    		 	billingInfo.Trial_Balance_Date.Date_x = MXA_APIHelper.convertDate(value);
        	}      	
        }
        
        global String contract_minimum { get {return billingInfo.contract_minimum;}  set {billingInfo.contract_minimum = value; }}
        global String auto_pay_day { get {return billingInfo.auto_pay_day;}  set {billingInfo.auto_pay_day = value; }}
        		
	}	
	
	
	global class CreateSubscriberContactInformation {
		public MonexaAPI.CRE_SUB_Contact_Information_TYPE contactInfo = null;

		global CreateSubscriberContactInformation() {
			contactInfo = new MonexaAPI.CRE_SUB_CONTACT_INFORMATION_TYPE();
		}


        global String first_name { get {return contactInfo.first_name;}  set { contactInfo.first_name = value; }}
        global String last_name { get {return contactInfo.last_name;}  set { contactInfo.last_name = value; }}
        global String company { get {return contactInfo.company;}  set { contactInfo.company = value; }}
        global String contact_email { get {return contactInfo.contact_email;}  set { contactInfo.contact_email = value; }}
        
        private MonexaServices.AddressElement billTo;
        global MonexaServices.AddressElement Bill_To_Address {
        	get { 
        		if(billTo == null) {
        			billTo = new MonexaServices.AddressElement();
        			contactInfo.Bill_To_Address = new MonexaAPI.Bill_To_Address_element();
        			contactInfo.Bill_To_Address.Address	= billTo.address_element;
        		} 
        		return billTo; 
        	}
        	set {
        		billTo = value;
        		if(billTo != null) {        		
        			contactInfo.Bill_To_Address = new MonexaAPI.Bill_To_Address_element();
        			contactInfo.Bill_To_Address.Address	= billTo.address_element;
        		} else {
        			contactInfo.Bill_To_Address = null;
        		}
        	}
        }
        
        private MonexaServices.AddressElement shipTo;
        global MonexaServices.AddressElement Ship_To_Address {
        	get { 
        		if(shipTo == null) {
        			shipTo = new MonexaServices.AddressElement();
        			contactInfo.Ship_To_Address = new MonexaAPI.Ship_To_Address_element();
        			contactInfo.Ship_To_Address.Address	= shipTo.address_element;
        		} 
        		return shipTo; 
        	}
        	set {
        		shipTo = value;
        		if(shipTo != null) {        		
        			contactInfo.Ship_To_Address = new MonexaAPI.Ship_To_Address_element();
        			contactInfo.Ship_To_Address.Address	= shipTo.address_element;
        		} else {
        			contactInfo.Ship_To_Address = null;
        		}
        	}
        }
        //global MonexaAPI.Ship_To_Address_element Ship_To_Address;

        global String timezone { get {return contactInfo.timezone;}  set { contactInfo.timezone = value; }}
        global String phone_number_1 { get {return contactInfo.phone_number_1;}  set { contactInfo.phone_number_1 = value; }}
        global String phone_number_2 { get {return contactInfo.phone_number_2;}  set { contactInfo.phone_number_2 = value; }}
        global String fax_number { get {return contactInfo.fax_number;}  set { contactInfo.fax_number = value; }}
        global String notes { get {return contactInfo.notes;}  set { contactInfo.notes = value; }}
        global String external_account_id { get {return contactInfo.external_account_id;}  set { contactInfo.external_account_id = value; }}
        global String language { get {return contactInfo.language;}  set { contactInfo.language = value; }}
        global String verification_question { get {return contactInfo.verification_question;}  set { contactInfo.verification_question = value; }}
        global String verification_answer { get {return contactInfo.verification_answer;}  set { contactInfo.verification_answer = value; }}
        global String receive_provider_marketing { get {return contactInfo.receive_provider_marketing;}  set { contactInfo.receive_provider_marketing = value; }}
        global String receive_third_party_marketing { get {return contactInfo.receive_third_party_marketing;}  set { contactInfo.receive_third_party_marketing = value; }}
        global String master_account_id { get {return contactInfo.master_account_id;}  set { contactInfo.master_account_id = value; }}
        global String referral { get {return contactInfo.referral;}  set { contactInfo.referral = value; }}
        global String custom_field_1 { get {return contactInfo.custom_field_1;}  set { contactInfo.custom_field_1 = value; }}
        global String custom_field_2 { get {return contactInfo.custom_field_2;}  set { contactInfo.custom_field_2 = value; }}
        global String custom_field_3 { get {return contactInfo.custom_field_3;}  set { contactInfo.custom_field_3 = value; }}
        global String custom_field_4 { get {return contactInfo.custom_field_4;}  set { contactInfo.custom_field_4 = value; }}
        global String custom_field_5 { get {return contactInfo.custom_field_5;}  set { contactInfo.custom_field_5 = value; }}
        global String custom_field_6 { get {return contactInfo.custom_field_6;}  set { contactInfo.custom_field_6 = value; }}		
	}    
    

	
	///////////////////////////////////////////////////////////////////////////
	// 					   END CREATE_SUBSCRIBER                             //
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	// 					     SEARCH_TRANSACTION                              //
	///////////////////////////////////////////////////////////////////////////
	
	global class ContactInformationType {
		public MonexaAPI.Contact_Information_Type Contact_Info;
		public ContactInformationType(MonexaAPI.Contact_Information_Type cInfo) {
			Contact_Info = cInfo;
		}
        global String first_name { get {return Contact_Info.first_name;}  set { Contact_Info.first_name = value; }}
        global String last_name { get {return Contact_Info.last_name;}  set { Contact_Info.last_name = value; }}
        global String company { get {return Contact_Info.company;}  set { Contact_Info.company = value; }}
        global String external_account_id { get {return Contact_Info.external_account_id;}  set { Contact_Info.external_account_id = value; }}
        global String phone_number_1 { get {return Contact_Info.phone_number_1;}  set { Contact_Info.phone_number_1 = value; }}    
        global String language { get {return Contact_Info.language;}  set { Contact_Info.language = value; }}
        global String master_account_id { get {return Contact_Info.master_account_id;}  set { Contact_Info.master_account_id = value; }}		
	}
	
    global class AccountInformationType {
    	public MonexaAPI.Account_Information_Type Account_Info;
    	
    	public AccountInformationType(MonexaAPI.Account_Information_Type aInfo) {
    		Account_Info = aInfo;
    	}
        global String account_id { get {return Account_Info.account_id;}  set { Account_Info.account_id = value; }}
        global String login_id { get {return Account_Info.login_id;}  set { Account_Info.login_id = value; }}
        global String external_group_id { get {return Account_Info.external_group_id;}  set { Account_Info.external_group_id = value; }}
        global String provider_id { get {return Account_Info.provider_id;}  set { Account_Info.provider_id = value; }}
        global String provider_name { get {return Account_Info.provider_name;}  set { Account_Info.provider_name = value; }}
        global String office_id { get {return Account_Info.office_id;}  set { Account_Info.office_id = value; }}
        global String office_name { get {return Account_Info.office_name;}  set { Account_Info.office_name = value; }}
        global String account_status { get {return Account_Info.account_status;}  set { Account_Info.account_status = value; }}
    }	
   	global class SubscriberInformationType {
    	public MonexaAPI.Subscriber_Information_Type Subscriber_Info;
    	public SubscriberInformationType(MonexaAPI.Subscriber_Information_Type subInfo) {
    		Subscriber_Info = subInfo;
    		if(subInfo.Account_Information != null)
    			Account_Information = new MonexaServices.AccountInformationType(subInfo.Account_Information);
    		if(subInfo.Contact_Information != null)
    			Contact_Information = new MonexaServices.ContactInformationType(subInfo.Contact_Information);    		
    	}
        global MonexaServices.AccountInformationType Account_Information {get; private set;}
        global MonexaServices.ContactInformationType Contact_Information {get; private set;}
	}
	global class TransactionElement {
	    public MonexaAPI.Transaction_element Transaction_Element_x;
	    
	    public TransactionElement(MonexaAPI.Transaction_element e) {
	    	Transaction_Element_x = e;
	    	if(Transaction_Element_x.Subscriber_Information != null)
	    		Subscriber_Information = new MonexaServices.SubscriberInformationType(Transaction_Element_x.Subscriber_Information);
	    }
	    
        global MonexaServices.SubscriberInformationType Subscriber_Information {get; private set;}
        
        global String monexa_transaction_id { get {return Transaction_Element_x.monexa_transaction_id;}  set { Transaction_Element_x.monexa_transaction_id = value; }}
        global String transaction_type { get {return Transaction_Element_x.transaction_type;}  set { Transaction_Element_x.transaction_type = value; }}
        global String status { get {return Transaction_Element_x.status;}  set { Transaction_Element_x.status = value; }}
        global String approval_code { get {return Transaction_Element_x.approval_code;}  set { Transaction_Element_x.approval_code = value; }}
        global String response_code { get {return Transaction_Element_x.response_code;}  set { Transaction_Element_x.response_code = value; }}
        global String response_description { get {return Transaction_Element_x.response_description;}  set { Transaction_Element_x.response_description = value; }}
        global String avs_code { get {return Transaction_Element_x.avs_code;}  set { Transaction_Element_x.avs_code = value; }}
        global String amount { get {return Transaction_Element_x.amount;}  set { Transaction_Element_x.amount = value; }}
        
        global Date Applied_To_Invoice_Date { 
        	get {
				if(Transaction_Element_x.Applied_To_Invoice_Date == null)
					return null;
				else
					return MXA_APIHelper.convertDate(Transaction_Element_x.Applied_To_Invoice_Date.Date_x);        	
        	}
        	set {
        		Transaction_Element_x.Applied_To_Invoice_Date = new MonexaAPI.Applied_To_Invoice_Date_element();
        		Transaction_Element_x.Applied_To_Invoice_Date.Date_x = MXA_APIHelper.convertDate(value);
        	}
        }
        
        global String applied_to_invoice_amount { get {return Transaction_Element_x.applied_to_invoice_amount;}  set { Transaction_Element_x.applied_to_invoice_amount = value; }}
        global String transaction_outstanding_amount { get {return Transaction_Element_x.transaction_outstanding_amount;}  set { Transaction_Element_x.transaction_outstanding_amount = value; }}
        global String available_refund_amount { get {return Transaction_Element_x.available_refund_amount;}  set { Transaction_Element_x.available_refund_amount = value; }}
        global String further_action { get {return Transaction_Element_x.further_action;}  set { Transaction_Element_x.further_action = value; }}
        global String transaction_time { get {return Transaction_Element_x.transaction_time;}  set { Transaction_Element_x.transaction_time = value; }}
        
        global DateTime Local_Transaction_Time { 
        	get {
				if(Transaction_Element_x.Local_Transaction_Time == null)
					return null;
				else
					return MXA_APIHelper.convertDateTime(Transaction_Element_x.Local_Transaction_Time.Date_Time);        	
        	}
        	set {
        		// TODO Implement convertDateTime to do the opposite of the one in get!
        	}
        }
        
        global String transaction_id { get {return Transaction_Element_x.transaction_id;}  set { Transaction_Element_x.transaction_id = value; }}
        global String reference_number { get {return Transaction_Element_x.reference_number;}  set { Transaction_Element_x.reference_number = value; }}
        global String reference_id { get {return Transaction_Element_x.reference_id;}  set { Transaction_Element_x.reference_id = value; }}
        global String comment { get {return Transaction_Element_x.comment;}  set { Transaction_Element_x.comment = value; }}
	}
	///////////////////////////////////////////////////////////////////////////
	//  				     End SEARCH_TRANSACTION                          //
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	//  				       LOOKUP_TRANSACTION                            //
	///////////////////////////////////////////////////////////////////////////
	global class LookupTransactionElement {
	    public MonexaAPI.LOOKUP_TRANSACTION_element Transaction_Element;
	    
	    global LookupTransactionElement() {
	    	Transaction_Element = new MonexaAPI.LOOKUP_TRANSACTION_element();
	    }
	    
        global String account_id { get {return Transaction_Element.account_id;}  set { Transaction_Element.account_id = value; }}
        
        private MonexaServices.AccountNamespaceElement accountNamespace = null;
        global MonexaServices.AccountNamespaceElement Account_Namespace {
        	get {
        		if(accountNameSpace == null) {
        			accountNamespace = new MonexaServices.AccountNamespaceElement();
        		}        		
        		return accountNamespace;
        	}
        	set {
        		accountNamespace = value;
        		if(value == null) {
        			Transaction_Element.Account_Namespace = null;
        		} else {
        			Transaction_Element.Account_Namespace = accountNamespace.an;
        		}        	
        	}
        }
        global String information_type { get {return Transaction_Element.information_type;}  set { Transaction_Element.information_type = value; }}
        global String monexa_transaction_id { get {return Transaction_Element.monexa_transaction_id;}  set { Transaction_Element.monexa_transaction_id = value; }}	
	}
	
	global class InvoiceDetailElement {
    	public MonexaAPI.Invoice_Detail_element Invoice_Detail;
    	
    	public InvoiceDetailElement(MonexaAPI.Invoice_Detail_element detail) {
    		Invoice_Detail = detail;
    	}
    	
        global Date Invoice_Detail_Date {  
        	get { return MXA_APIHelper.convertDate(Invoice_Detail.Invoice_Detail_Date.Date_x);} 
        	set { 
        		Invoice_Detail.Invoice_Detail_Date = new MonexaAPI.Invoice_Detail_Date_element(); 
        		Invoice_Detail.Invoice_Detail_Date.Date_x = MXA_APIHelper.convertDate(value); 
        	}  
        }
        global String description { get {return Invoice_Detail.description;}  set { Invoice_Detail.description = value; }}
        global String amount { get {return Invoice_Detail.amount;}  set { Invoice_Detail.amount = value; }}
        global String line_item_type { get {return Invoice_Detail.line_item_type;}  set { Invoice_Detail.line_item_type = value; }}
        global String quantity { get {return Invoice_Detail.quantity;}  set { Invoice_Detail.quantity = value; }}
        global String rate { get {return Invoice_Detail.rate;}  set { Invoice_Detail.rate = value; }}
        global Date Period_Start_Date {  
        	get { return MXA_APIHelper.convertDate(Invoice_Detail.Period_Start_Date.Date_x);} 
        	set {  
        		Invoice_Detail.Period_Start_Date = new MonexaAPI.Period_Start_Date_element(); 
        		Invoice_Detail.Period_Start_Date.Date_x = MXA_APIHelper.convertDate(value); 
        	}  
        }
        global Date Period_End_Date {  
        	get { return MXA_APIHelper.convertDate(Invoice_Detail.Period_End_Date.Date_x);} 
        	set {  
        		Invoice_Detail.Period_End_Date = new MonexaAPI.Period_End_Date_element(); 
        		Invoice_Detail.Period_End_Date.Date_x = MXA_APIHelper.convertDate(value); 
        	} 
        }
        global String plan_id { get {return Invoice_Detail.plan_id;}  set { Invoice_Detail.plan_id = value; }}
        global String plan_name { get {return Invoice_Detail.plan_name;}  set { Invoice_Detail.plan_name = value; }}
        global String service_id { get {return Invoice_Detail.service_id;}  set { Invoice_Detail.service_id = value; }}
        global String service_name { get {return Invoice_Detail.service_name;}  set { Invoice_Detail.service_name = value; }}
        global Integer term_quantity { get {return Invoice_Detail.term_quantity;}  set { Invoice_Detail.term_quantity = value; }}
        global String term_unit { get {return Invoice_Detail.term_unit;}  set { Invoice_Detail.term_unit = value; }}
        global String subscriber_id { get {return Invoice_Detail.subscriber_id;}  set { Invoice_Detail.subscriber_id = value; }}
	}
	global class InvoiceElement {	
    	public MonexaAPI.Invoice_element invoiceElement;
    	
    	public InvoiceElement(MonexaAPI.Invoice_element invoice) {
    		invoiceElement = invoice;
    		if(invoice.Subscriber_Information != null)
    			Subscriber_Information = new MonexaServices.SubscriberInformationType(invoice.Subscriber_Information);
    		if(invoice.Invoice_Detail != null) {
    			Invoice_Detail = new List<MonexaServices.InvoiceDetailElement>();    			
    			for(MonexaAPI.Invoice_Detail_element e : invoice.Invoice_Detail) {
    				Invoice_Detail.add(new InvoiceDetailElement(e));
    			}
    		}
    	}
    	global MonexaServices.SubscriberInformationType Subscriber_Information { get; set; }
        
        global String invoice_number { get {return invoiceElement.invoice_number;}  set { invoiceElement.invoice_number = value; }}
        global String external_invoice_number { get {return invoiceElement.external_invoice_number;}  set { invoiceElement.external_invoice_number = value; }}
        global String invoice_amount { get {return invoiceElement.invoice_amount;}  set { invoiceElement.invoice_amount = value; }}
        global Date Applied_Date { 
        	get { return MXA_APIHelper.convertDate(invoiceElement.Applied_Date.Date_x);}
        	set { 
    			invoiceElement.Applied_Date = new MonexaAPI.Applied_Date_element();
    		 	invoiceElement.Applied_Date.Date_x = MXA_APIHelper.convertDate(value);
        	}      	
        }
        global String applied_amount { get {return invoiceElement.applied_amount;}  set { invoiceElement.applied_amount = value; }}
        global String invoice_outstanding_amount { get {return invoiceElement.invoice_outstanding_amount;}  set { invoiceElement.invoice_outstanding_amount = value; }}
        global Date Invoice_Date { 
        	get { return MXA_APIHelper.convertDate(invoiceElement.Invoice_Date.Date_x);}
        	set { 
    			invoiceElement.Invoice_Date = new MonexaAPI.Invoice_Date_element();
    		 	invoiceElement.Invoice_Date.Date_x = MXA_APIHelper.convertDate(value);
        	}      	
        }
        global Date Invoice_Due_Date { 
        	get { 
        		if(invoiceElement.Invoice_Due_Date == null) return null; 
        		return MXA_APIHelper.convertDate(invoiceElement.Invoice_Due_Date.Date_x);
        	}
        	set { 
    			invoiceElement.Invoice_Due_Date = new MonexaAPI.Invoice_Due_Date_element();
    		 	invoiceElement.Invoice_Due_Date.Date_x = MXA_APIHelper.convertDate(value);
        	}      	
        }
    	global List<MonexaServices.InvoiceDetailElement> Invoice_Detail {get; set;}           
	}
	global class TransactionInformationElement {	    
	    public MonexaAPI.Transaction_Information_element transInfoElement;
	    
	    public TransactionInformationElement(MonexaAPI.Transaction_Information_element transInfo)
	    {
	    	transInfoElement = transInfo;
	    	if(transInfo.Invoice != null) {
	    		Invoice = new List<MonexaServices.InvoiceElement>();
	    		for(MonexaAPI.Invoice_element e : transInfo.Invoice) {
	    			Invoice.add(new MonexaServices.InvoiceElement(e));
	    		}
	    	}
	    	if(transInfo.Transaction_x != null) {
	    		Transaction_x = new MonexaServices.TransactionElement(transInfo.Transaction_x);
	    	}	    
	    }
        
        global MonexaServices.TransactionElement Transaction_x {get; set;}
        global List<MonexaServices.InvoiceElement> Invoice;
        
   	}
    global class ResponseLookupTransactionElement {
    	public MonexaAPI.Response_LOOKUP_TRANSACTION_element Transaction_Element;
    
    	public ResponseLookupTransactionElement(MonexaAPI.Response_LOOKUP_TRANSACTION_element transElement) {
    		Transaction_Element = transElement;
    		Transaction_Information = new MonexaServices.TransactionInformationElement(transElement.Transaction_Information);
    	}
    
        global String account_id { get { return Transaction_Element.account_id; } set { Transaction_Element.account_id = value; } }
        
        global MonexaServices.TransactionInformationElement Transaction_Information {get; set;}
    }
	
	///////////////////////////////////////////////////////////////////////////
	//  				      End LOOKUP_TRANSACTION                         //
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	//  				          SEARCH_INVOICE                             //
	///////////////////////////////////////////////////////////////////////////
	
	global class InvoiceInformationElement {
    	public MonexaAPI.Invoice_Information_element Invoice_Information;
    	global InvoiceInformationElement() {
    		Invoice_Information = new MonexaAPI.Invoice_Information_element();
    		Invoice_Information.Invoice = new MonexaAPI.Invoice_element();
    		Invoice = new MonexaServices.InvoiceElement(Invoice_Information.Invoice);    		
    	}
    	public InvoiceInformationElement(MonexaAPI.Invoice_Information_element invoiceInformation) {
    		Invoice_Information = invoiceInformation;
    		if(invoiceInformation.Invoice != null)
    			Invoice = new MonexaServices.InvoiceElement(invoiceInformation.Invoice);
    		if(invoiceInformation.Transaction_x != null) {
    			Transaction_x = new List<MonexaServices.TransactionElement>();
    			for(MonexaAPI.Transaction_element t : invoiceInformation.Transaction_x) {
    			 	Transaction_x.add(new MonexaServices.TransactionElement(t));
    			}
    		}
    		if(InvoiceInformation.Related_Invoice != null) {
    			Related_Invoice = new List<MonexaServices.InvoiceElement>();
    			for(MonexaAPI.Related_Invoice_element e : invoiceInformation.Related_Invoice) {
    				Related_Invoice.add(new MonexaServices.InvoiceElement(e.Invoice));
    			}
    		}    		
    	}
    	global MonexaServices.InvoiceElement Invoice { get; set; }
    	global List<MonexaServices.TransactionElement> Transaction_x { get; set; }
        
        public List<MonexaServices.InvoiceElement> Related_Invoice {get; set;}
        
	}

	///////////////////////////////////////////////////////////////////////////
	//  				        End SEARCH_INVOICE                           //
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	//  				        PROCESS_TRANSACTION                          //
	///////////////////////////////////////////////////////////////////////////
	global class PaymentInformationElement {
    	public MonexaAPI.Payment_Information_element payment_information {get; set;}
        
     	   
        public String payment_method { get {return payment_information.payment_method;}  set { payment_information.payment_method = value; }}
        
        private MonexaServices.CreditCardInformationElement ccInfo;
        global MonexaServices.CreditCardInformationElement Credit_Card_Information {
        	get {
        		if(ccInfo == null) {
        			ccInfo = new MonexaServices.CreditCardInformationElement();
        			payment_information.Credit_Card_Information = ccInfo.Credit_Card_Information;        			
        		}
        		return ccInfo;
        	} 
        	set {        	
        		ccInfo = value;
        		payment_information.Credit_Card_Information = (value != null) ? ccInfo.Credit_Card_Information : null;
        	}
        }
        private MonexaServices.BankAccountInformationElement baInfo;
        global MonexaServices.BankAccountInformationElement Bank_Account_Information {
        	get {
        		if(baInfo == null) {
        			baInfo = new MonexaServices.BankAccountInformationElement();
        			payment_information.Bank_Account_Information = baInfo.Bank_Account_Information;        			
        		}
        		return baInfo;
        	} 
        	set {        	
        		baInfo = value;
        		
        		payment_information.Bank_Account_Information = (value != null) ? baInfo.Bank_Account_Information : null;
        	}
        }
        private MonexaServices.PayPalInformationElement ppInfo;
        global MonexaServices.PayPalInformationElement PayPal_Information {
        	get {
        		if(ppInfo == null) {
        			ppInfo = new MonexaServices.PayPalInformationElement();
        			payment_information.PayPal_Information = ppInfo.PayPal_Information;        			        		
        		}
        		return ppInfo;
        	} 
        	set {        	
        		ppInfo = value;
        		
        		payment_information.PayPal_Information = (value != null) ? ppInfo.PayPal_Information : null;
        	}
        }
        
        public MonexaAPI.Bill_To_Address_element Bill_To_Address;
        public String phone_number { get {return payment_information.phone_number;}  set { payment_information.phone_number = value; }}
        public String contact_email { get {return payment_information.contact_email;}  set { payment_information.contact_email = value; }}	
	}
	global class PaymentMapElement {
		public MonexaAPI.Payment_Map_element payment_map { get; set; }
		
		global PaymentMapElement() {
			payment_map = new MonexaAPI.Payment_Map_element();			
		}
		
        global String payment_type { get {return payment_map.payment_type;}  set { payment_map.payment_type = value; }}
        global String payment_id { get {return payment_map.payment_id;}  set { payment_map.payment_id = value; }}
        global String amount { get {return payment_map.amount;}  set { payment_map.amount = value; }}
	}

	global class ResponseProcessTransactionElement {
    	public MonexaAPI.Response_PROCESS_TRANSACTION_element Response_Process_Transaction;
    	
    	public ResponseProcessTransactionElement(MonexaAPI.Response_PROCESS_TRANSACTION_element e) {
    		Response_Process_Transaction = e;
    	}    	
        global String monexa_transaction_id { get {return Response_Process_Transaction.monexa_transaction_id;}  set { Response_Process_Transaction.monexa_transaction_id = value; }}
        global String transaction_id { get {return Response_Process_Transaction.transaction_id;}  set { Response_Process_Transaction.transaction_id = value; }}
        global String reference_number { get {return Response_Process_Transaction.reference_number;}  set { Response_Process_Transaction.reference_number = value; }}
        global String approval_code { get {return Response_Process_Transaction.approval_code;}  set { Response_Process_Transaction.approval_code = value; }}
        global String response_code { get {return Response_Process_Transaction.response_code;}  set { Response_Process_Transaction.response_code = value; }}
        global String response_description { get {return Response_Process_Transaction.response_description;}  set { Response_Process_Transaction.response_description = value; }}
        global String avs_code { get {return Response_Process_Transaction.avs_code;}  set { Response_Process_Transaction.avs_code = value; }}
	}
	///////////////////////////////////////////////////////////////////////////
	//  				      End PROCESS_TRANSACTION                        //
	///////////////////////////////////////////////////////////////////////////


	///////////////////////////////////////////////////////////////////////////
	//  				          LOOKUP_INVOICE                             //
	///////////////////////////////////////////////////////////////////////////

	global class ResponseLookupInvoiceElement {
		public MonexaAPI.Response_LOOKUP_INVOICE_element Lookup_Invoice;
		
		public ResponseLookupInvoiceElement(MonexaAPI.Response_LOOKUP_INVOICE_element lookup) {
			Lookup_Invoice = lookup;
			invoiceInfo = new MonexaServices.InvoiceInformationElement(lookup.Invoice_Information);													
		}
		
		global String account_id { get { return Lookup_Invoice.account_id; } set { Lookup_Invoice.account_id = value; } }
		private MonexaServices.InvoiceInformationElement invoiceInfo;
		global MonexaServices.InvoiceInformationElement Invoice_Information {
			get {
				if(invoiceInfo == null) {
					invoiceInfo = new MonexaServices.InvoiceInformationElement();
					Lookup_Invoice.Invoice_Information = invoiceInfo.Invoice_Information;
				}
				return invoiceInfo;
			}
			set {
				invoiceInfo = value;
				Lookup_Invoice.Invoice_Information = invoiceInfo.Invoice_Information;
			}
		} 
		
		
	}
	
	///////////////////////////////////////////////////////////////////////////
	//  				      End LOOKUP_INVOICE                             //
	///////////////////////////////////////////////////////////////////////////
	
	///////////////////////////////////////////////////////////////////////////
	//                              LIST PLANS                               //
	///////////////////////////////////////////////////////////////////////////
	global class ResponseListPlansPlanType {
		public MonexaAPI.REP_LIST_PLANS_PLAN_TYPE Plan_Type;
		
		public ResponseListPlansPlanType(MonexaAPI.REP_LIST_PLANS_PLAN_TYPE planType) {
			Plan_Type = planType;
			MonexaAPI.Plan_Discount_Type_element[] pdtes = planType.Plan_Discount_Type;
			Plan_Discount_Type = new MonexaServices.PlanDiscountType[] {};
			if(pdtes != null) {			
				for(MonexaAPI.Plan_Discount_Type_element discountType : pdtes) {
					Plan_Discount_Type.add(new MonexaServices.PlanDiscountType(discountType));
				}
			}
		}
        global String provider_id { get {return Plan_Type.provider_id;}  set { Plan_Type.provider_id = value; }}
        global String provider_name { get {return Plan_Type.provider_name;}  set { Plan_Type.provider_name = value; }}
        global String plan_id { get {return Plan_Type.plan_id;}  set { Plan_Type.plan_id = value; }}
        global String name { get {return Plan_Type.name;}  set { Plan_Type.name = value; }}
        global String description { get {return Plan_Type.description;}  set { Plan_Type.description = value; }}
        global String product_id { get {return Plan_Type.product_id;}  set { Plan_Type.product_id = value; }}
        global String price { get {return Plan_Type.price;}  set { Plan_Type.price = value; }}
        global String setup_fee { get {return Plan_Type.setup_fee;}  set { Plan_Type.setup_fee = value; }}
        global String setup_fee_description { get {return Plan_Type.setup_fee_description;}  set { Plan_Type.setup_fee_description = value; }}
        global String early_cancellation_penalty { get {return Plan_Type.early_cancellation_penalty;}  set { Plan_Type.early_cancellation_penalty = value; }}
        global Integer cancellation_penalty_days { get {return Plan_Type.cancellation_penalty_days;}  set { Plan_Type.cancellation_penalty_days = value; }}
        global Integer expiry_num_units { get {return Plan_Type.expiry_num_units;}  set { Plan_Type.expiry_num_units = value; }}
        global String expiry_units { get {return Plan_Type.expiry_units;}  set { Plan_Type.expiry_units = value; }}
        global String use_plan_credit_limit { get {return Plan_Type.use_plan_credit_limit;}  set { Plan_Type.use_plan_credit_limit = value; }}
        global String credit_limit { get {return Plan_Type.credit_limit;}  set { Plan_Type.credit_limit = value; }}
        global String pooled_access { get {return Plan_Type.pooled_access;}  set { Plan_Type.pooled_access = value; }}
        global Integer pool_limit { get {return Plan_Type.pool_limit;}  set { Plan_Type.pool_limit = value; }}
        global String[] plan_property { get {return Plan_Type.plan_property;}  set { Plan_Type.plan_property = value; }}
        global String custom_field_1 { get {return Plan_Type.custom_field_1;}  set { Plan_Type.custom_field_1 = value; }}
        global String custom_field_2 { get {return Plan_Type.custom_field_2;}  set { Plan_Type.custom_field_2 = value; }}
        global String custom_field_3 { get {return Plan_Type.custom_field_3;}  set { Plan_Type.custom_field_3 = value; }}
        global String custom_field_4 { get {return Plan_Type.custom_field_4;}  set { Plan_Type.custom_field_4 = value; }}
        global String custom_field_5 { get {return Plan_Type.custom_field_5;}  set { Plan_Type.custom_field_5 = value; }}
        global String custom_field_6 { get {return Plan_Type.custom_field_6;}  set { Plan_Type.custom_field_6 = value; }}

        
        
        global MonexaServices.PlanDiscountType[] Plan_Discount_Type {get; set;}
        
        //public MonexaAPI.REP_LIST_PLANS_PLAN_SERVICE_TYPE[] Plan_Service;
        //public MonexaAPI.Plan_Restriction_element[] Plan_Restriction;
        //public MonexaAPI.Price_Book_element[] Price_Book;
		
		
	}
	///////////////////////////////////////////////////////////////////////////
	//                            End LIST PLANS                             //
	///////////////////////////////////////////////////////////////////////////
	
	///////////////////////////////////////////////////////////////////////////
	//                             LOOKUP PLAN                               //
	///////////////////////////////////////////////////////////////////////////
    global class LookupPlanServiceType {     
    	public MonexaAPI.REP_LOOKUP_PLAN_SERVICE_TYPE Plan_Service_Type {get; set;}
    	
    	public LookupPlanServiceType(MonexaAPI.REP_LOOKUP_PLAN_SERVICE_TYPE lookupPlanServiceType) {
    		Plan_Service_Type = lookupPlanServiceType;
    	}
    	
        global String service_id { get {return Plan_Service_Type.service_id;}  set {Plan_Service_Type.service_id = value; }}
        global String description { get {return Plan_Service_Type.description;}  set {Plan_Service_Type.description = value; }}
        global String service_type { get {return Plan_Service_Type.service_type;}  set {Plan_Service_Type.service_type = value; }}
        global String price { get {return Plan_Service_Type.price;}  set {Plan_Service_Type.price = value; }}
        global String default_service { get {return Plan_Service_Type.default_service;}  set {Plan_Service_Type.default_service = value; }}
        global String optional_service { get {return Plan_Service_Type.optional_service;}  set {Plan_Service_Type.optional_service = value; }}
        global String product_id { get {return Plan_Service_Type.product_id;}  set {Plan_Service_Type.product_id = value; }}
	}

	global class LookupPlanServiceGroupType {	
		public MonexaAPI.REP_LOOKUP_PLAN_SERVICE_GROUP_TYPE Service_Group_Type {get; set;}
		
		public LookupPlanServiceGroupType(MonexaAPI.REP_LOOKUP_PLAN_SERVICE_GROUP_TYPE gType) {
			Service_Group_Type = gType;
			Service = new List<MonexaServices.LookupPlanServiceType>();
			
			for(MonexaAPI.REP_LOOKUP_PLAN_SERVICE_TYPE serviceType : gType.Service) {
				Service.add(new MonexaServices.LookupPlanServiceType(serviceType));
			}
		}
	    
        global String service_group_id { get {return Service_Group_Type.service_group_id;}  set {Service_Group_Type.service_group_id = value; }}
        global String description { get {return Service_Group_Type.description;}  set {Service_Group_Type.description = value; }}
        global String summary { get {return Service_Group_Type.summary;}  set {Service_Group_Type.summary = value; }}
        
        global List<MonexaServices.LookupPlanServiceType> Service {get; set;}
                
	}
	global class LookupPlanPlanServiceType  {
		public MonexaAPI.REP_LOOKUP_PLAN_PLAN_SERVICE_TYPE Plan_Service_Type {get; set;}
		public LookupPlanPlanServiceType(MonexaAPI.REP_LOOKUP_PLAN_PLAN_SERVICE_TYPE pType) {
			Plan_Service_Type = pType;
			Service_Group = new List<LookupPlanServiceGroupType>();
			for(MonexaAPI.REP_LOOKUP_PLAN_SERVICE_GROUP_TYPE gType : pType.Service_Group) {
				Service_Group.add(new MonexaServices.LookupPlanServiceGroupType(gType));
			}			
		}
		
		global List<MonexaServices.LookupPlanServiceGroupType> Service_Group {get; set;}				  
	}
	global class PlanRestrictionElement {
	    public MonexaAPI.Plan_Restriction_element Plan_Restriction {get; set;}
	    
	    public PlanRestrictionElement(MonexaAPI.Plan_Restriction_element e) {
	    	Plan_Restriction = e;
	    }	    
	    
        public String plan_id { get {return Plan_Restriction.plan_id;}  set {Plan_Restriction.plan_id = value; }}
        public Integer subaccount_limit { get {return Plan_Restriction.subaccount_limit;}  set {Plan_Restriction.subaccount_limit = value; }}
	}
	

    global class ServiceElement {    
    	public MonexaAPI.Service_element Service {get; set;}
    	public ServiceElement(MonexaAPI.Service_element serv) {
    		Service = serv;
    	}
        global String service_id { get {return Service.service_id;}  set {Service.service_id = value; }}
        global String description { get {return Service.description;}  set {Service.description = value; }}
        global String service_type { get {return Service.service_type;}  set {Service.service_type = value; }}
        global String price { get {return Service.price;}  set {Service.price = value; }}
        global String default_service { get {return Service.default_service;}  set {Service.default_service = value; }}
        global String optional_service { get {return Service.optional_service;}  set {Service.optional_service = value; }}
        global String product_id { get {return Service.product_id;}  set {Service.product_id = value; }}
        
        public MonexaAPI.Service_Parameter_element Service_Parameter;
	}	
	global class UsagePricingElement {
	    public MonexaAPI.Usage_Pricing_element Usage_Pricing {get; set;}
	    public UsagePricingElement(MonexaAPI.Usage_Pricing_element usagePricing) {
	    	Usage_Pricing = usagePricing;
	    }
	    
        global String start { get {return Usage_Pricing.start;}  set {Usage_Pricing.start = value; }}
        global String end_x { get {return Usage_Pricing.end_x;}  set {Usage_Pricing.end_x = value; }}
        global String price { get {return Usage_Pricing.price;}  set {Usage_Pricing.price = value; }}
	
	}
	global class UsageServiceElement {
		public MonexaAPI.Usage_Service_element Usage_Service {get; set;}
		public UsageServiceElement(MonexaAPI.Usage_Service_element usageService) {
			Usage_Service = usageService;
			Usage_Pricing = new List<MonexaServices.UsagePricingElement>();
			for(MonexaAPI.Usage_Pricing_element usageP : usageService.Usage_Pricing) {
				Usage_Pricing.add(new MonexaServices.UsagePricingElement(usageP));
			}
		}		
        global String service_id { get {return Usage_Service.service_id;}  set {Usage_Service.service_id = value; }}
        global String description { get {return Usage_Service.description;}  set {Usage_Service.description = value; }}
        global String pricing_type { get {return Usage_Service.pricing_type;}  set {Usage_Service.pricing_type = value; }}
        
        global List<MonexaServices.UsagePricingElement> Usage_Pricing {get; set;}
    }
	global class PriceSheetElement {
	    public MonexaAPI.Price_Sheet_element Price_Sheet {get; set;}
	    
	    public PriceSheetElement(MonexaAPI.Price_Sheet_element e) {
	    	Price_Sheet = e;
	    	if(e.Service != null) {
		    	Service = new List<MonexaServices.ServiceElement>();		    	
		    	for(MonexaApi.Service_element serv : e.Service) {
		    		Service.add(new MonexaServices.ServiceElement(serv));
		    	}
	    	}
	    	if(e.Usage_Service != null) {
		    	Usage_Service = new List<MonexaServices.UsageServiceElement>();
		    	for(MonexaAPI.Usage_Service_element usage : e.Usage_Service) {
		    		Usage_Service.add(new MonexaServices.UsageServiceElement(usage));
		    	}
	    	}
	    }
	    
        global String internal_price_sheet_id { get {return Price_Sheet.internal_price_sheet_id;}  set {Price_Sheet.internal_price_sheet_id = value; }}
        global String billing_frequency { get {return Price_Sheet.billing_frequency;}  set {Price_Sheet.billing_frequency = value; }}
        global String currency_x { get {return Price_Sheet.currency_x;}  set {Price_Sheet.currency_x = value; }}
        global String contract_term { get {return Price_Sheet.contract_term;}  set {Price_Sheet.contract_term = value; }}
        global Integer usage_billing_period_number { get {return Price_Sheet.usage_billing_period_number;}  set {Price_Sheet.usage_billing_period_number = value; }}
        global String usage_billing_period_unit { get {return Price_Sheet.usage_billing_period_unit;}  set {Price_Sheet.usage_billing_period_unit = value; }}
        global String fee { get {return Price_Sheet.fee;}  set {Price_Sheet.fee = value; }}
        
        global List<MonexaServices.ServiceElement> Service {get; set;}
        global MonexaServices.UsageServiceElement[] Usage_Service {get; set;}	
	}
	
    global class PriceBookElement {
    	public MonexaAPI.Price_Book_element Price_Book {get; set;}
    	public PriceBookElement(MonexaAPI.Price_Book_element priceBook) {
    		Price_Book = priceBook;
    		Price_Sheet = new List<MonexaServices.PriceSheetElement>();
    		for(MonexaAPI.Price_Sheet_element priceSheet : priceBook.Price_Sheet) {
    			Price_Sheet.add(new MonexaServices.PriceSheetElement(priceSheet));
    		}
    	}	

        global String internal_price_book_id { get {return Price_Book.internal_price_book_id;}  set {Price_Book.internal_price_book_id = value; }}
        global String price_book_id { get {return Price_Book.price_book_id;}  set {Price_Book.price_book_id = value; }}
        global String price_book_name { get {return Price_Book.price_book_name;}  set {Price_Book.price_book_name = value; }}
        global String price_book_description { get {return Price_Book.price_book_description;}  set {Price_Book.price_book_description = value; }}
        global String default_x { get {return Price_Book.default_x;}  set {Price_Book.default_x = value; }}
        global String active { get {return Price_Book.active;}  set {Price_Book.active = value; }}
        
        global MonexaServices.PriceSheetElement[] Price_Sheet {get; set;}        
	}
	
	global class ResponseLookupPlanPlanType {
		public MonexaAPI.REP_LOOKUP_PLAN_PLAN_TYPE Plan_Type {get; set;}
		
		public ResponseLookupPlanPlanType(MonexaAPI.REP_LOOKUP_PLAN_PLAN_TYPE planType) {
			Plan_Type = planType;
			if(planType.Plan_Discount_Type != null) {
				Plan_Discount_Type = new List<MonexaServices.PlanDiscountType>();
				for(MonexaAPI.Plan_Discount_Type_element e : planType.Plan_Discount_Type) {
					Plan_Discount_Type.add(new MonexaServices.PlanDiscountType(e));
				}
			}
			if(planType.Plan_Service != null) {
				Plan_Service = new List<MonexaServices.LookupPlanPlanServiceType>(); 
				for(MonexaAPI.REP_LOOKUP_PLAN_PLAN_SERVICE_TYPE planService : planType.Plan_Service) {
					Plan_Service.add(new MonexaServices.LookupPlanPlanServiceType(planService));
				}			
			}
			
			if(planType.Plan_Restriction != null) {
				Plan_Restriction = new List<MonexaServices.PlanRestrictionElement>();
				for(MonexaAPI.Plan_Restriction_element planRestriction : planType.Plan_Restriction) {
					Plan_Restriction.add(new MonexaServices.PlanRestrictionElement(planRestriction));
				}
			}
						
			if(planType.Price_Book != null) {
				Price_Book = new List<MonexaServices.PriceBookElement>();
				for(MonexaAPI.Price_Book_element priceBook : planType.Price_Book) {
					Price_Book.add(new MonexaServices.PriceBookElement(priceBook));
				}			
			}
			
		}
		
		
        global String provider_id { get {return Plan_Type.provider_id;}  set {Plan_Type.provider_id = value; }}
        global String provider_name { get {return Plan_Type.provider_name;}  set {Plan_Type.provider_name = value; }}
        global String plan_id { get {return Plan_Type.plan_id;}  set {Plan_Type.plan_id = value; }}
        global String name { get {return Plan_Type.name;}  set {Plan_Type.name = value; }}
        global String description { get {return Plan_Type.description;}  set {Plan_Type.description = value; }}
        global String product_id { get {return Plan_Type.product_id;}  set {Plan_Type.product_id = value; }}
        global String price { get {return Plan_Type.price;}  set {Plan_Type.price = value; }}
        global String setup_fee { get {return Plan_Type.setup_fee;}  set { Plan_Type.setup_fee = value; }}
        global String setup_fee_description { get {return Plan_Type.setup_fee_description;}  set { Plan_Type.setup_fee_description = value; }}
        global String early_cancellation_penalty { get {return Plan_Type.early_cancellation_penalty;}  set { Plan_Type.early_cancellation_penalty = value; }}
        global Integer cancellation_penalty_days { get {return Plan_Type.cancellation_penalty_days;}  set { Plan_Type.cancellation_penalty_days = value; }}
        global Integer expiry_num_units { get {return Plan_Type.expiry_num_units;}  set { Plan_Type.expiry_num_units = value; }}
        global String expiry_units { get {return Plan_Type.expiry_units;}  set { Plan_Type.expiry_units = value; }}
        global String use_plan_credit_limit { get {return Plan_Type.use_plan_credit_limit;}  set { Plan_Type.use_plan_credit_limit = value; }}
        global String credit_limit { get {return Plan_Type.credit_limit;}  set { Plan_Type.credit_limit = value; }}
        global String pooled_access { get {return Plan_Type.pooled_access;}  set { Plan_Type.pooled_access = value; }}
        global Integer pool_limit { get {return Plan_Type.pool_limit;}  set { Plan_Type.pool_limit = value; }}
        global String[] plan_property { get {return Plan_Type.plan_property;}  set { Plan_Type.plan_property = value; }}
        global String custom_field_1 { get {return Plan_Type.custom_field_1;}  set { Plan_Type.custom_field_1 = value; }}
        global String custom_field_2 { get {return Plan_Type.custom_field_2;}  set { Plan_Type.custom_field_2 = value; }}
        global String custom_field_3 { get {return Plan_Type.custom_field_3;}  set { Plan_Type.custom_field_3 = value; }}
        global String custom_field_4 { get {return Plan_Type.custom_field_4;}  set { Plan_Type.custom_field_4 = value; }}
        global String custom_field_5 { get {return Plan_Type.custom_field_5;}  set { Plan_Type.custom_field_5 = value; }}
        global String custom_field_6 { get {return Plan_Type.custom_field_6;}  set { Plan_Type.custom_field_6 = value; }}
        
        global MonexaServices.PlanDiscountType[] Plan_Discount_Type {get; set;}
        global MonexaServices.LookupPlanPlanServiceType[] Plan_Service {get; set;}
        global MonexaServices.PlanRestrictionElement[] Plan_Restriction {get; set;}
        global MonexaServices.PriceBookElement[] Price_Book {get; set;}
		
		
		
		
	}
	///////////////////////////////////////////////////////////////////////////
	//                           End LOOKUP PLAN                             //
	///////////////////////////////////////////////////////////////////////////


	///////////////////////////////////////////////////////////////////////////
	//                           LIST PROVIDERS                              //
	///////////////////////////////////////////////////////////////////////////
	global class PlanServiceElement {
	
		public MonexaAPI.Plan_Service_element innerObj {get; set;}
		public PlanServiceElement(MonexaAPI.Plan_Service_element e) {
			innerObj = e;
			if(innerObj.Service_Group != null) {
				Service_Group = new List<MonexaServices.ServiceGroupElement>();
				for(MonexaAPI.Service_Group_Element sge : innerObj.Service_Group) {
					Service_Group.add(new MonexaServices.ServiceGroupElement(sge));
				}
			}
		}
		global MonexaServices.ServiceGroupElement[] Service_Group {get; set;}
	}
	global class PlanElement {
		public MonexaAPI.Plan_element innerObj {get; set;}
		
		public PlanElement(MonexaAPI.Plan_element e) {
			innerObj = e;
        	if(innerObj.Plan_Discount_Type != null) {
        		Plan_Discount_Type = new List<MonexaServices.PlanDiscountType>();
        		for(MonexaAPI.Plan_Discount_Type_element pdt : innerObj.Plan_Discount_Type) {
        			Plan_Discount_Type.add(new MonexaServices.PlanDiscountType(pdt));
        		}
        	}

        	if(innerObj.Plan_Service != null) {
        		Plan_Service = new List<MonexaServices.PlanServiceElement>();
        		for(MonexaAPI.Plan_Service_element pdt : innerObj.Plan_Service) {
        			Plan_Service.add(new MonexaServices.PlanServiceElement(pdt));
        		}
        	}
			if(innerObj.Plan_Restriction != null) {
				Plan_Restriction = new List<MonexaServices.PlanRestrictionElement>();
				for(MonexaAPI.Plan_Restriction_Element pre : innerObj.Plan_Restriction) {
					Plan_Restriction.add(new MonexaServices.PlanRestrictionElement(pre));
				}
			}
			if(innerObj.Price_Book != null) {
				Price_Book = new List<MonexaServices.PriceBookElement>();
				
				for(MonexaAPI.Price_Book_element pbe : innerObj.Price_Book) {
					Price_Book.add(new MonexaServices.PriceBookElement(pbe));
				}
			} 			
		}
        global String provider_id { get {return InnerObj.provider_id;}  set {InnerObj.provider_id = value; }}
        global String provider_name { get {return InnerObj.provider_name;}  set {InnerObj.provider_name = value; }}
        global String plan_id { get {return InnerObj.plan_id;}  set {InnerObj.plan_id = value; }}
        global String name { get {return InnerObj.name;}  set {InnerObj.name = value; }}
        global String description { get {return InnerObj.description;}  set {InnerObj.description = value; }}
        global String product_id { get {return InnerObj.product_id;}  set {InnerObj.product_id = value; }}
        global String price { get {return InnerObj.price;}  set {InnerObj.price = value; }}
        global String setup_fee { get {return InnerObj.setup_fee;}  set {InnerObj.setup_fee = value; }}
        global String setup_fee_description { get {return InnerObj.setup_fee_description;}  set {InnerObj.setup_fee_description = value; }}
        global String early_cancellation_penalty { get {return InnerObj.early_cancellation_penalty;}  set {InnerObj.early_cancellation_penalty = value; }}
        global Integer cancellation_penalty_days { get {return InnerObj.cancellation_penalty_days;}  set {InnerObj.cancellation_penalty_days = value; }}
        global Integer expiry_num_units { get {return InnerObj.expiry_num_units;}  set {InnerObj.expiry_num_units = value; }}
        global String expiry_units { get {return InnerObj.expiry_units;}  set {InnerObj.expiry_units = value; }}
        global String use_plan_credit_limit { get {return InnerObj.use_plan_credit_limit;}  set {InnerObj.use_plan_credit_limit = value; }}
        global String credit_limit { get {return InnerObj.credit_limit;}  set {InnerObj.credit_limit = value; }}
        global String pooled_access { get {return InnerObj.pooled_access;}  set {InnerObj.pooled_access = value; }}
        global Integer pool_limit { get {return InnerObj.pool_limit;}  set {InnerObj.pool_limit = value; }}
        global String[] plan_property { get {return InnerObj.plan_property;}  set {InnerObj.plan_property = value; }}
        global String custom_field_1 { get {return InnerObj.custom_field_1;}  set {InnerObj.custom_field_1 = value; }}
        global String custom_field_2 { get {return InnerObj.custom_field_2;}  set {InnerObj.custom_field_2 = value; }}
        global String custom_field_3 { get {return InnerObj.custom_field_3;}  set {InnerObj.custom_field_3 = value; }}
        global String custom_field_4 { get {return InnerObj.custom_field_4;}  set {InnerObj.custom_field_4 = value; }}
        global String custom_field_5 { get {return InnerObj.custom_field_5;}  set {InnerObj.custom_field_5 = value; }}
        global String custom_field_6 { get {return InnerObj.custom_field_6;}  set {InnerObj.custom_field_6 = value; }}
        
        global MonexaServices.PlanDiscountType[] Plan_Discount_Type {get; set;}
        global MonexaServices.PlanServiceElement[] Plan_Service {get; set;}
        global MonexaServices.PlanRestrictionElement[] Plan_Restriction {get; set;}
        global MonexaServices.PriceBookElement[] Price_Book {get; set;}
        
        //public MonexaAPI.Plan_Service_element[] Plan_Service;
	}
	global class ProductElement {
		public MonexaAPI.Product_element innerObj {get; set;}
		public ProductElement(MonexaAPI.Product_element e) {
			innerObj = e;
		}
        global String provider_id { get {return InnerObj.provider_id;}  set {InnerObj.provider_id = value; }}
        global String product_id { get {return InnerObj.product_id;}  set {InnerObj.product_id = value; }}
        global String description { get {return InnerObj.description;}  set {InnerObj.description = value; }}
        global String price { get {return InnerObj.price;}  set {InnerObj.price = value; }}
        global String taxable_status { get {return InnerObj.taxable_status;}  set {InnerObj.taxable_status = value; }}
        global String class_x { get {return InnerObj.class_x;}  set {InnerObj.class_x = value; }}		
	}
	global class ServiceGroupElement {
		public MonexaAPI.Service_Group_element innerObj {get; set;}
		public ServiceGroupElement(MonexaAPI.Service_Group_element e) {
			innerObj = e;
			if(e.Service != null) {
				Service = new List<MonexaServices.ServiceElement>();
				for(MonexaAPI.Service_element se : e.Service) {
					Service.add(new MonexaServices.ServiceElement(se));
				}
			}
		}
		
        global String service_group_id { get {return InnerObj.service_group_id;}  set {InnerObj.service_group_id = value; }}
        global String description { get {return InnerObj.description;}  set {InnerObj.description = value; }}
        global String summary { get {return InnerObj.summary;}  set {InnerObj.summary = value; }}
        
        global MonexaServices.ServiceElement[] Service {get; set;}
	}
	global class OfficeElement {
		public MonexaAPI.Office_element innerObj {get; set;}
		public OfficeElement(MonexaAPI.Office_element e) {
			innerObj = e;			
		}
        global String office_id { get {return InnerObj.office_id;}  set {InnerObj.office_id = value; }}
        global String office_name { get {return InnerObj.office_name;}  set {InnerObj.office_name = value; }}
        global String transaction_token { get {return InnerObj.transaction_token;}  set {InnerObj.transaction_token = value; }}
        global String[] cancellation_reason { get {return InnerObj.cancellation_reason;}  set {InnerObj.cancellation_reason = value; }}
		
	}
	global class ResponseListProvidersProviderType {
		private MonexaAPI.REP_LIST_PROVIDERS_PROVIDER_TYPE InnerObj {get; set;}
		public ResponseListProvidersProviderType(MonexaAPI.REP_LIST_PROVIDERS_PROVIDER_TYPE mxaObj) {
			innerObj= mxaObj;
			
			if(mxaObj.Plan != null) {
				Plan = new List<MonexaServices.PlanElement>();
				for(MonexaAPI.Plan_element pe : mxaObj.Plan) {
					Plan.add(new MonexaServices.PlanElement(pe));
				}
			}
			if(mxaObj.Product != null) {
				Product = new List<MonexaServices.ProductElement>();				
				for(MonexaAPI.Product_element pe : mxaObj.Product) {
					Product.add(new MonexaServices.ProductElement(pe));
				}
			}
			if(mxaObj.Service_Group != null) {
				Service_Group = new List<MonexaServices.ServiceGroupElement>();				
				for(MonexaAPI.Service_Group_element sge : mxaObj.Service_Group) {
					Service_Group.add(new MonexaServices.ServiceGroupElement(sge));
				}				
			}
			if(mxaObj.Office != null) {
				Office = new List<MonexaServices.OfficeElement>();				
				for(MonexaAPI.Office_element oe : mxaObj.Office) {
					Office.add(new MonexaServices.OfficeElement(oe));
				}				
			}
		}
		
		
        global String provider_id { get {return InnerObj.provider_id;}  set {InnerObj.provider_id = value; }}
        global String provider_name { get {return InnerObj.provider_name;}  set {InnerObj.provider_name = value; }}
        global String external_group_id_required { get {return InnerObj.external_group_id_required;}  set {InnerObj.external_group_id_required = value; }}
        global String[] payment_method { get {return InnerObj.payment_method;}  set {InnerObj.payment_method = value; }}
        
        
        global MonexaServices.PlanElement[] Plan {get; set;}
        global MonexaServices.ProductElement[] Product {get; set;}
        global MonexaServices.ServiceGroupElement[] Service_Group {get; set;}
        global MonexaServices.OfficeElement[] Office {get; set;}
        
//        public MonexaAPI.Plan_element[] Plan;
//        public MonexaAPI.Product_element[] Product;
//        public MonexaAPI.Service_Group_element[] Service_Group;
//        public MonexaAPI.Office_element[] Office;
		
		
		
		
	}
	
	
	///////////////////////////////////////////////////////////////////////////
	//                         End LIST PROVIDERS                            //
	///////////////////////////////////////////////////////////////////////////

		
	global class Client {
		private MonexaAPI.MonexaSOAPPort port = new MonexaAPI.MonexaSOAPPort();		
		
		global MonexaServices.AuthenticationElement Authentication {get; set;}
		
		global Client() {
			port.timeout_x = 120000; 

		}
		
		global SessionKeyElement getSessionKey(String account_id, MonexaServices.AccountNamespaceElement account_namespace, String session_info, String session_type) {
			MonexaAPI.Session_Key_element response = null;
			MonexaAPI.GET_SESSION_KEY_element gsk = new MonexaAPI.GET_SESSION_KEY_element();
			if(account_id != null && account_id != '')
				gsk.account_id = account_id; 
			gsk.session_information = session_info;
			gsk.session_type = session_type;
			if(account_namespace != null)
				gsk.Account_Namespace = account_namespace.an;
								
			response = port.getSessionKey(Authentication.auth, gsk);
			if(response != null)
				return new SessionKeyElement(response);
			else
				return null;
        }
        /**
          * Lookup detailed information on a suscriber.
          */
        global List<MonexaServices.LookupSubscriberInformationElement> lookupSubscriber(String account_id, String master_account_id,  MonexaServices.AccountNamespaceElement account_namespace) {
        	MonexaAPI.LOOKUP_SUBSCRIBER_element lookup = new MonexaAPI.LOOKUP_SUBSCRIBER_element();
        	lookup.account_id = account_id;
        	lookup.master_account_id = master_account_id;
        	if(account_namespace != null)
        		lookup.Account_Namespace = account_namespace.an;
        		
        	List<MonexaAPI.REP_LOOK_SUB_SUBSCRIBER_INFORMATION_TYPE> response = null;
        	response = port.lookupSubscriber(Authentication.auth, lookup);
        	
        	List<MonexaServices.LookupSubscriberInformationElement> result = new List<MonexaServices.LookupSubscriberInformationElement>();
        	for(MonexaAPI.REP_LOOK_SUB_SUBSCRIBER_INFORMATION_TYPE subInfoType : response) {
        		if(subInfoType != null)
        			result.add(new MonexaServices.LookupSubscriberInformationElement(subInfoType));
        	}
        	return result;
        }     
        
        global List<SearchSubscriberInformationElement> searchSubscriber(String account_id, String login_id, 
        		String external_group_id, String first_name, String last_name, String company, String external_account_id, 
        		String phone_number_1, String master_account_id, String result_set_start, String result_set_length, 
        		String result_order, String result_sort_by, String from_modified_time, String to_modified_time, String account_type) {
        	MonexaAPI.SEARCH_SUBSCRIBER_element sse = new MonexaAPI.SEARCH_SUBSCRIBER_element();
        	sse.external_group_id = external_group_id;
        	sse.master_account_id = master_account_id;
        	sse.result_order = result_order;
        	sse.to_modified_time = to_modified_time;
        	sse.first_name = first_name;
        	sse.result_sort_by = result_sort_by;
        	sse.from_modified_time = from_modified_time;
        	sse.account_type = account_type;
        	sse.login_id = login_id;
        	sse.account_id = account_id;
        	sse.phone_number_1 = phone_number_1;
        	sse.result_set_length = result_set_length;
        	sse.external_account_id = external_account_id;
        	sse.result_set_start = result_set_start;
        	sse.company = company;
        	sse.last_name = last_name;
        	 
        	MonexaAPI.Response_SEARCH_SUBSCRIBER_element response = port.searchSubscriber(Authentication.auth, sse);
        	List<SearchSubscriberInformationElement> result = new List<SearchSubscriberInformationElement>();
        	if(response.Subscriber_Information != null && response.Subscriber_Information.size() > 0) {        	
	        	for(MonexaAPI.REP_SEA_SUB_SUBSCRIBER_INFORMATION_TYPE item : response.Subscriber_Information) {
	        		result.add(new SearchSubscriberInformationElement(item));
	        	}
        	}
        	return result;        
        }
		global String createSubscriber(MonexaServices.CreateSubscriberAccountInformationElement account_info, MonexaServices.CreateSubscriberBillingInformation billing_info, CreateSubscriberContactInformation contact_info) {
			MonexaAPI.CREATE_SUBSCRIBER_element cse = new MonexaAPI.CREATE_SUBSCRIBER_element();

			cse.Subscriber_Information = new MonexaAPI.CRE_SUB_SUBSCRIBER_INFORMATION_TYPE();
			cse.Subscriber_Information.Account_Information = account_info.acctInfo;
			cse.Subscriber_Information.Billing_Information = billing_info.billingInfo;
			cse.Subscriber_Information.Contact_Information = contact_info.contactInfo;
			
			if(account_info.Plan != null && account_info.Plan.Plan_Service != null
				&& account_info.Plan.Plan_Service.size() > 0) {
				account_info.Plan.CopyPlanServiceToWrappedObject();
			}			
					
			MonexaAPI.REP_CRE_SUB_SUBSCRIBER_INFORMATION_TYPE response = port.createSubscriber(Authentication.auth, cse);
			return response.Account_Information.account_id;			
		}
		
		global List<MonexaServices.TransactionElement> searchTransaction(String provider_id, String account_id, MonexaServices.AccountNamespaceElement Account_Namespace, 
			String transaction_type, String further_action, String payment_method, String transaction_token,
         	Date Start_Date, Date End_Date, Date Last_Updated_Start_Date, Date Last_Updated_End_Date, String status) {
        	
        	MonexaAPI.SEARCH_TRANSACTION_element search = new MonexaAPI.SEARCH_TRANSACTION_element();
        	search.provider_id = provider_id;
        	search.account_id = account_id;
        	if(Account_Namespace != null)
        		search.Account_Namespace = Account_Namespace.an;
        	search.transaction_type = transaction_type;
        	search.further_action = further_action;
        	search.payment_method = payment_method;
        	search.transaction_token = transaction_token;
        	
        	if(Start_Date != null) {
        		search.Start_Date = new MonexaAPI.Start_Date_element();
        		search.Start_Date.Date_x = MXA_APIHelper.convertDate(Start_Date);
        	}
        	if(End_Date != null) {
        		search.End_Date = new MonexaAPI.End_Date_element();
        		search.End_Date.Date_x = MXA_APIHelper.convertDate(End_Date);        	
        	}
        	if(Last_Updated_Start_Date != null) {
        		search.Last_Updated_Start_Date = new MonexaAPI.Last_Updated_Start_Date_element();
        		search.Last_Updated_Start_Date.Date_x = MXA_APIHelper.convertDate(Last_Updated_Start_Date);        	        	
        	}
        	if(Last_Updated_End_Date != null) {
        		search.Last_Updated_End_Date = new MonexaAPI.Last_Updated_End_Date_element();
        		search.Last_Updated_End_Date.Date_x = MXA_APIHelper.convertDate(Last_Updated_End_Date);        	        	
        	}        	
        	search.status = status;
        	MonexaAPI.Transaction_element[] responses = port.searchTransaction(Authentication.auth, search);
        	List<MonexaServices.TransactionElement> results = new List<MonexaServices.TransactionElement>(); 
        	for(MonexaAPI.Transaction_element response : responses) {
        		results.add(new MonexaServices.TransactionElement(response));
        	}
        	 
        	return results;
        }
        global MonexaServices.ResponseLookupTransactionElement lookupTransaction(String account_id, MonexaServices.AccountNamespaceElement Account_Namespace, String information_type, String monexa_transaction_id ) {
        	
        	MonexaAPI.LOOKUP_TRANSACTION_element lookup = new MonexaAPI.LOOKUP_TRANSACTION_element();
        	lookup.account_id = account_id;
        	if(Account_Namespace != null)
        		lookup.Account_Namespace = Account_Namespace.an;
        	lookup.information_type = information_type;
        	lookup.monexa_transaction_id = monexa_transaction_id;
        	
			MonexaAPI.Response_LOOKUP_TRANSACTION_element response = port.lookupTransaction(Authentication.auth, lookup);
			
			return new MonexaServices.ResponseLookupTransactionElement(response);        
        }

        global MonexaServices.ResponseLookupInvoiceElement lookupInvoice(String account_id, MonexaServices.AccountNamespaceElement Account_Namespace, String information_type, String invoice_number ) {
        	
        	MonexaAPI.LOOKUP_INVOICE_element lookup = new MonexaAPI.LOOKUP_INVOICE_element();
        	
        	lookup.account_id = account_id;
        	if(Account_Namespace != null)
        		lookup.Account_Namespace = Account_Namespace.an;
        	lookup.information_type = information_type;
        	lookup.invoice_number = invoice_number;
        	
			MonexaAPI.Response_LOOKUP_INVOICE_element response = port.lookupInvoice(Authentication.auth, lookup);
			
			
			return new MonexaServices.ResponseLookupInvoiceElement(response);        
        }

        
        global List<MonexaServices.InvoiceInformationElement> searchInvoice(String provider_id, String account_id, MonexaServices.AccountNamespaceElement Account_Namespace,
        	String information_type, String invoice_status, String external_invoice_number, Date Start_Date, Date End_Date) {        
			
			MonexaAPI.SEARCH_INVOICE_element search = new MonexaAPI.SEARCH_INVOICE_element();
			search.provider_id = provider_id;
			search.account_id = account_id;
			if(Account_Namespace != null)
				search.Account_Namespace = Account_Namespace.an;
			search.information_type = information_type;
			search.invoice_status = invoice_status;
			search.external_invoice_number = external_invoice_number;
			if(Start_Date != null) {
				search.Start_Date = new MonexaAPI.Start_Date_element();
				search.Start_Date.Date_x = MXA_APIHelper.convertDate(Start_Date);
			}
			if(End_Date != null) {
				search.End_Date = new MonexaAPI.End_Date_element();
				search.End_Date.Date_x = MXA_APIHelper.convertDate(End_Date);
			}
        	MonexaAPI.Invoice_Information_element[] response;
        	response = port.searchInvoice(Authentication.auth,search);
        	List<MonexaServices.InvoiceInformationElement> result = new List<MonexaServices.InvoiceInformationElement>();
        	if(response != null) {
	        	for(MonexaAPI.Invoice_Information_element e : response) {
	        		result.add(new MonexaServices.InvoiceInformationElement(e));
	        	}
        	}
			return result;
		}
		global String pingServer(){
			if(Authentication != null) {			
				MonexaAPI.Authentication_element auth = Authentication.auth;
				
				return port.pingServer(auth.account_id, auth.administrator_login_name, auth.Account_Namespace, auth.password);
			} else {
				return null;
			}
		}
		
		global MonexaServices.ResponseProcessTransactionElement processTransaction(String account_id, MonexaServices.AccountNamespaceElement Account_Namespace,
										String monexa_transaction_id, String transaction_token,
										String transaction_type, String apply_outstanding_amounts, String amount, 
										List<MonexaServices.PaymentMapElement> Payment_Map, MonexaServices.PaymentInformationElement Payment_Information,
										String comment) {
			MonexaAPI.PROCESS_TRANSACTION_element req = new MonexaAPi.PROCESS_TRANSACTION_element();
			req.account_id = account_id;
			if(Account_Namespace != null)
				req.Account_Namespace = Account_Namespace.an;
			req.monexa_transaction_id = monexa_transaction_id;
			req.transaction_token = transaction_token;
			req.transaction_type = transaction_type;
			req.amount = amount;
			req.comment = comment;
			req.apply_outstanding_amounts = apply_outstanding_amounts;
			if(Payment_Map != null) {
				req.Payment_Map = new List<MonexaAPI.Payment_Map_element>();
				for(MonexaServices.PaymentMapElement payMap : Payment_Map) {
					req.Payment_Map.add(payMap.payment_map);
				}
			}
			if(Payment_Information != null)
				req.Payment_Information = Payment_Information.payment_information;
			MonexaAPI.Response_PROCESS_TRANSACTION_element response;
			
			response = port.processTransaction(Authentication.auth, req);
			
			MonexaServices.ResponseProcessTransactionElement result = new MonexaServices.ResponseProcessTransactionElement(response);
			return result; 						
		}
		global List<MonexaServices.ResponseListPlansPlanType> ListPlans(String provider_id, String information_type) {
			MonexaAPI.LIST_PLANS_element req = new MonexaAPI.LIST_PLANS_element();
			req.provider_id = provider_id;
			req.information_type = information_type;
			
			List<MonexaAPI.REP_LIST_PLANS_PLAN_TYPE> response;
			response = port.listPlans(Authentication.auth, req);
			List<MonexaServices.ResponseListPlansPlanType> result = new List<MonexaServices.ResponseListPlansPlanType>(); 
			for(MonexaAPI.REP_LIST_PLANS_PLAN_TYPE plan : response) {
				result.add(new MonexaServices.ResponseListPlansPlanType(plan));
			}
			return result;
		}
		global MonexaServices.ResponseLookupPlanPlanType lookupPlan(String provider_id, String plan_id, String information_type, Boolean listPlanServices, Boolean listPlanDiscounts, Boolean listPriceBooks) {
			MonexaAPI.LOOKUP_PLAN_element req = new MonexaAPI.LOOKUP_PLAN_element();
			req.provider_id = provider_id;
			req.plan_id = plan_id;
			if(listPlanServices)
				req.LIST_PLAN_SERVICES = new MonexaAPI.LIST_PLAN_SERVICES_element();						
			if(listPlanDiscounts)
				req.LIST_PLAN_DISCOUNTS = new MonexaAPI.LIST_PLAN_DISCOUNTS_element();
			if(listPriceBooks)
				req.LIST_PRICE_BOOKS = new MonexaAPI.LIST_PRICE_BOOKS_element();
			req.LIST_PRICE_BOOKS.information_type = information_type;

			MonexaAPI.REP_LOOKUP_PLAN_PLAN_TYPE response = port.lookupPlan(Authentication.auth, req);
			
			return new MonexaServices.ResponseLookupPlanPlanType(response); 
		}
		global void deletePlan(String provider_id, String plan_id) {
			MonexaAPI.DELETE_PLAN_element req = new MonexaAPI.DELETE_PLAN_element();
			req.provider_id = provider_id;
			req.plan_id = plan_id;
			port.deletePlan(Authentication.auth, req);
		}
		/**
		  *
		  *
		  */
		global List<MonexaServices.ResponseListProvidersProviderType> listProviders(String providers_info_type, Boolean list_products, Boolean list_service_groups,
								String offices_info_type) {
			MonexaAPI.LIST_PROVIDERS_element req = new MonexaAPI.LIST_PROVIDERS_element();
			req.information_type = providers_info_type;
			if(list_products)
				req.LIST_PRODUCTS = new MonexaAPI.LIST_PROVIDERS_LIST_PRODUCTS_TYPE();
			if(list_service_groups)
				req.LIST_SERVICE_GROUPS = new MonexaAPI.LIST_PROVIDERS_LIST_SERVICE_GROUPS_TYPE();
			if(offices_info_type != null) {
				req.LIST_OFFICES = new MonexaAPI.LIST_PROVIDERS_LIST_OFFICES_TYPE();
				req.LIST_OFFICES.information_type = offices_info_type;
			}
			List<MonexaAPI.REP_LIST_PROVIDERS_PROVIDER_TYPE> response = port.listProviders(Authentication.auth, req);
			List<MonexaServices.ResponseListProvidersProviderType> result = new List<MonexaServices.ResponseListProvidersProviderType>();
			if(response != null) {
				for(MonexaAPI.REP_LIST_PROVIDERS_PROVIDER_TYPE prov : response) {
					result.add(new MonexaServices.ResponseListProvidersProviderType(prov));
				}
			}
			return result;
		}
	}
}