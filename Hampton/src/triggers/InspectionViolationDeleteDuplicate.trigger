trigger InspectionViolationDeleteDuplicate on Inspection_Violation__c (after insert)
{
	Map<Id, Inspection_Violation__c> trigMap = trigger.newMap;
	Inspection_Violation__c[] trig = [select Id, Violation__c, Inspection__c, Inspection__r.MUSW__Previous_Inspection__c from Inspection_Violation__c where Id in :trigMap.keySet()];
    
    Inspection_Violation__c[] dupIVs = new Inspection_Violation__c[]{};
    MUSW__Inspection__c[] dupIns = new MUSW__Inspection__c[]{};
    for (Integer i=trig.size()-1; i>=0; i--)
    {
        for (Integer j=0; j<trig.size(); j++)
        {
            if (trig[i].Violation__c == trig[j].Violation__c && 
            	trig[i].Inspection__r.MUSW__Previous_Inspection__c == trig[j].Inspection__r.MUSW__Previous_Inspection__c && 
            	trig[i].Id != trig[j].Id)
	        {
	            dupIVs.add(new Inspection_Violation__c(Id=trig[i].Id));
	            dupIns.add(trig[i].Inspection__r);
	            trig.remove(i);
	            break;
	        }
        }
    }
    
    if (dupIVs.size() > 0)
    {
    	delete dupIVs;
    	delete dupIns;
	}
}