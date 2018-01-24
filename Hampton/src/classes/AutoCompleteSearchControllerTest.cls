@isTest
public class AutoCompleteSearchControllerTest 
{
    static testmethod void testSearch()
    {
        AutoCompleteSearchController.search('test');
    }
    
    static testmethod void testRedirect()
    {
        AutoCompleteSearchController.redirect('Account', 'Name', 'Test');
    }
}