global class PaymentGateway implements IPaymentGateway
{
    private static MonexaManager mxManager;
    
    public static Boolean authenticate(String accountId)
    {
        mxManager = new MonexaManager(accountId);
        return mxManager.authenticate();
    }
    
    /**	
     *	Needs to authenticate because MonexaManager is static and 
     *	once authenticate() is called from the page the static reference is lost
     **/
    WebService static String refund(String accountId, String transactionId, Decimal amount)
    {
    	Boolean loggedIn = authenticate(accountId);
    	
        if (loggedIn)
        {
        	try
        	{
        		return mxManager.refund(transactionId, amount);
        	}
        	catch(CalloutException e)
        	{
        		throw new MUSW.BGException('You cannot issue a refund after a certain period of time. Contact your Administrator for more information.', true);
        	}
        }
        else
        {
        	throw new MUSW.BGException('Refund failed because login was unsuccessful.', true);
        }
    }
    
    /**	
     *	Needs to authenticate because MonexaManager is static and 
     *	once authenticate() is called from the page the static reference is lost
     **/
    WebService static String void(String accountId, String transactionId, Decimal amount)
    {
    	Boolean loggedIn = authenticate(accountId);
    	
        if (loggedIn)
        {
        	try
        	{
        		return mxManager.void(transactionId, amount);
        	}
        	catch(CalloutException e)
        	{
        		throw new MUSW.BGException('This Receipt cannot be voided. Use the Refund feature on the Payment Adjust screen to issue a refund instead.', true);
        	}
        }
        else
        {
        	throw new MUSW.BGException('Void failed because login was unsuccessful.', true);
        }
    }
    
    public static String getSessionKey(Decimal amount)
    {
        return mxManager.getSessionKey(amount);
    }
}