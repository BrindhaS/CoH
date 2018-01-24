@isTest
public class TestCaseAssignment {
   static  testmethod void insertNewcase() {
   List<Case> cases = new List<Case>();
    for(integer i = 0 ; i< 200 ; i++)
    {
        Case joe = new Case();
        joe.Service_Request_Type__c  = 'Miscellaneous';
        joe.Status = 'New';
        joe.Origin = 'Phone';
        joe.Priority = 'Medium';
        cases.add(joe);
    }
    Database.insert(cases);
  }
}