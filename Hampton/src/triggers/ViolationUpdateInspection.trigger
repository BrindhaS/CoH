trigger ViolationUpdateInspection on MUSW__Violation__c (after update)
{
    /*  for manual edits on Violations
     *  it closes the Inspection if the Violation has been closed
     */
    
    // get related Open Inspections
    Inspection_Violation__c[] ivs = [select Inspection__c from Inspection_Violation__c where Violation__c in :trigger.newMap.keySet() and Inspection__r.isClosed__c = 'No'];
    
    // get all Open IV's for related Inspections -close those with no Open Violations
    Set<Id> insIds = new Set<Id>();
    for (Inspection_Violation__c iv : ivs) insIds.add(iv.Inspection__c);
    MUSW__Inspection__c[] ins = [select Id, (select Id from Inspection_Violations__r where Violation__r.isClosed__c = 'No') from MUSW__Inspection__c where Id in :insIds];
    
    MUSW__Inspection__c[] ins2close = new MUSW__Inspection__c[]{};
    for (MUSW__Inspection__c i : ins)
    {
        if (i.Inspection_Violations__r.size() == 0)
        {
            i.Close_Inspection__c = true;
            ins2close.add(i);
        }
    }
    
    try
    {
        if (ins2close.size() > 0) update ins2close;
    }
    catch (System.Dmlexception ex)
    {
        if (!ex.getMessage().contains('SELF_REFERENCE_FROM_TRIGGER')) throw ex;
    }
}