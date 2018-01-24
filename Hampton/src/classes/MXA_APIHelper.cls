public class MXA_APIHelper {
	public static MonexaServices.AuthenticationElement getAuthentication() {
		MXA_Settings__c settings = MXA_Settings__c.getInstance();
		String userName = settings.API_User_Name__c;
		String password = settings.API_Password__c;


		MonexaServices.AuthenticationElement auth = new MonexaServices.AuthenticationElement();
		auth.administrator_login_name = userName;
		auth.password = password;
		return auth;
	}
	public static MonexaAPI.Authentication_element getAuth() {
		
		MXA_Settings__c settings = MXA_Settings__c.getInstance();
		String userName = settings.API_User_Name__c;
		String password = settings.API_Password__c;
		
		
		
		MonexaAPI.Authentication_element auth = new MonexaAPI.Authentication_element();
		auth.administrator_login_name = userName;
		auth.password = password; 
		return auth;
	}
	public static SelectOption[] getBillingFrequencies() {
		return new SelectOption[] { new SelectOption('1', 'Monthly'),
									new SelectOption('3', 'Quarterly'),
									new SelectOption('4', 'Every 4 Months'),
									new SelectOption('6', 'Semi-Annually'),
									new SelectOption('12', 'Annually'),
									new SelectOption('18', 'Every 18 Months'),
									new SelectOption('18', 'Every 18 Months'),
									new SelectOption('24', 'Every 2 Years'),
									new SelectOption('36', 'Every 3 Years')
									};
									
	}
	
	public static String getProviderId() {
		MXA_Settings__c settings = MXA_Settings__c.getInstance();
		return String.valueOf(settings.Provider_ID__c);		
	}
	public static Date convertDate(MonexaAPI.Date_element dx) {
		if(dx == null)
			return null;
		if(dx.year != null && dx.month != null && dx.day != null && dx.year != '' && dx.month != '' && dx.day != '') {	
			return Date.newInstance(Integer.valueOf(dx.year), Integer.valueOf(dx.month), Integer.valueOf(dx.day));
		} else {
			return null;
		}
	}
	public static Date convertDate(MonexaAPI.Date_Time_element dx) {
		if(dx == null)
			return null;
		if(dx.year != null && dx.month != null && dx.day != null && dx.year != '' && dx.month != '' && dx.day != '') {	
			return Date.newInstance(Integer.valueOf(dx.year), Integer.valueOf(dx.month), Integer.valueOf(dx.day));
		} else {
			return null;
		}		
	}	
	public static MonexaAPI.Date_element convertDate(Date d) {
		DateTime dt = DateTime.newInstance(d, Time.newInstance(0,0,0,0));
		MonexaAPI.Date_element dx = new MonexaAPI.Date_element();
		dx.year = dt.format('yyyy');
		dx.month = dt.format('MM');
		dx.day = dt.format('dd');
		return dx;
	}
	
	public static DateTime convertDateTime(MonexaAPI.Date_Time_element dx) {
		if(dx == null)
			return null;
		if(dx.year != null) {
			return DateTime.newInstance(Integer.valueOf(dx.year), Integer.valueOf(dx.month), Integer.valueOf(dx.day), Integer.valueOf(dx.hour),Integer.valueOf(dx.minute),Integer.valueOf(dx.second));
		} else {
			return null;
		}		
	}

	public static MonexaAPI.MonexaSOAPPort createPort() {
		MonexaAPI.MonexaSOAPPort port = new MonexaAPI.MonexaSOAPPort();
		
		return port;
	}
	
	@isTest(seeAllData=true)
    private static void testHelper()
    {   	
    	MonexaAPI.Date_element dx = new MonexaAPI.Date_element();
    	MonexaAPI.Date_Time_element mdt = new MonexaAPI.Date_Time_element();
    	Date d = MXA_APIHelper.convertDate(dx);
    	Date d1 = MXA_APIHelper.convertDate(mdt);
    	MonexaAPI.Date_element md = MXA_APIHelper.convertDate(Date.newInstance(2012,12,25));
    	DateTime dt = MXA_APIHelper.convertDateTime(mdt);
        SelectOption[] so = MXA_APIHelper.getBillingFrequencies();
        MonexaAPI.Authentication_element au = MXA_APIHelper.getAuth();
        MonexaServices.AuthenticationElement aue = MXA_APIHelper.getAuthentication();
        String s = MXA_APIHelper.getProviderId();
    }	
	
	
}