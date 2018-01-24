public with sharing class OrdinanceLookupController
{
    public MUSW__Violation_Type__c[] os { get; set; }
    public MUSW__Violation_Type__c o { get; set; }
    public String searchText { get; set; }
    public String selectionId { get; set; }
    
    public OrdinanceLookupController(){}
    
    public void search()
    {
        o = null;
        selectionId = null;
        //List<List<SObject>> ls = [find :searchText in NAME FIELDS returning MUSW__Violation_Type__c(Name, Type__c, MUSW__Description__c where RecordType.Name = 'Standard Comment')];
        
        os = [select Name, Type__c, MUSW__Description__c from MUSW__Violation_Type__c where RecordType.Name = 'Standard Comment' and Name like :('%'+searchText+'%')];
    }
    
    public void getDescription()
    {
        for (MUSW__Violation_Type__c o : os)
        {
            if (o.Id == selectionId)
            {
                this.o = o;
                break;
            }
        }
    }
}