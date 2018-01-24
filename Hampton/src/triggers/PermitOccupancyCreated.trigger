trigger PermitOccupancyCreated on MUSW__Permit2__c (after insert)
{
    // turn off for data loads
    if (!HamptonTriggerService.isRulesEngineActive()) return;
    
    Map<Id, MUSW__Permit2__c> parentOccMap = new Map<Id, MUSW__Permit2__c>();
    for (MUSW__Permit2__c p : trigger.new)
    {
        if (p.MUSW__Type__c == 'Occupancy Certificate' && p.Permit2__c != null)
        {
            parentOccMap.put(p.Permit2__c, p);
        }
    }
    
    if (parentOccMap.size() > 0)
    {
        MUSW.TriggerBlocker.blockAllTriggers = true;
        
        // move Capacities
        MUSW__Work_Item__c[] wis = [select Id, MUSW__Permit2__c from MUSW__Work_Item__c where RecordType.Name = 'Capacity' and MUSW__Permit2__c in :parentOccMap.keySet()];
        
        for (MUSW__Work_Item__c wi : wis)
        {
            wi.MUSW__Permit2__c = parentOccMap.get(wi.MUSW__Permit2__c).Id;
        }
        if (wis.size() > 0) update wis;
        
        // close Project
        MUSW__Project2__c[] prjs = new MUSW__Project2__c[]{};
        for (MUSW__Permit2__c occp : parentOccMap.values())
        {
            if (occp.MUSW__Project2__c != null)
            {
                MUSW__Project2__c prj = new MUSW__Project2__c(Id=occp.MUSW__Project2__c, MUSW__Status__c='Closed');
                prjs.add(prj);
            }
        }
        if (prjs.size() > 0) update prjs;
        
        MUSW.TriggerBlocker.blockAllTriggers = false;
    }
}