trigger InspectionFixComplaintLookup on MUSW__Inspection__c (before insert)
{
    for (MUSW__Inspection__c ins : trigger.new)
    {
        if (ins.Complaint2__c == null) ins.Complaint2__c = ins.MUSW__Complaint2__c;
    }
}