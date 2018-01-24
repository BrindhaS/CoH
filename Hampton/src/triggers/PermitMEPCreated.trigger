trigger PermitMEPCreated on MUSW__Permit2__c (after insert)
{
    // turn off for data loads
    if (!HamptonTriggerService.isRulesEngineActive()) return;
    
    Set<Id> pids = new Set<Id>();
    for (MUSW__Permit2__c p : trigger.new)
    {
        if (p.Permit2__c != null) pids.add(p.Permit2__c);
    }
    if (pids.size() == 0) return;
    
    
    MUSW__Permit2__c[] ps = [select Id, (select Id, RecordType.Name from MUSW__Work_Items__r), (select Id, Name, MUSW__Permit2__c from MUSW__Milestones__r where Name like 'Mechanical%' or Name like 'Electrical%' or Name like 'Plumbing%') from MUSW__Permit2__c where Id in :pids];
    
    MUSW__Milestone__c[] ms2update = new MUSW__Milestone__c[]{};
    MUSW__Work_Item__c[] wis2update = new MUSW__Work_Item__c[]{};
    for (MUSW__Permit2__c p : ps)
    {
        for (MUSW__Permit2__c ptrig : trigger.new)
        {
            if (p.Id == ptrig.Permit2__c)
            {
                // transfer Reviews for MEP
                if ('Mechanical,Electrical,Plumbing'.contains(ptrig.MUSW__Type__c))
                {
                    for (MUSW__Milestone__c m : p.MUSW__Milestones__r)
                    {
                        if (m.Name.startsWith(ptrig.MUSW__Type__c))
                        {
                            m.MUSW__Permit2__c = ptrig.Id;
                            ms2update.add(m);
                        }
                    }
                }
                
                // transfer Work Items
                for (MUSW__Work_Item__c wi : p.MUSW__Work_Items__r)
                {
                    if (wi.RecordType.Name == ptrig.MUSW__Type__c)
                    {
                        wi.MUSW__Permit2__c = ptrig.Id;
                        wis2update.add(wi);
                    }
                }
            }
        }
    }
    
    if (ms2update.size() > 0) update ms2update;
    if (wis2update.size() > 0) update wis2update;
}