trigger PremitFinaled on MUSW__Permit2__c (before update)
{
    // turn off for data loads
    if (!HamptonTriggerService.isRulesEngineActive()) return;
    
    Id[] pids = new Id[]{};
    for (MUSW__Permit2__c p : trigger.new) if (p.MUSW__Status__c == 'Finaled') pids.add(p.Id);
    
    if (pids.size() > 0)
    {
        MUSW__Permit2__c[] ps = [select Id, (select Id, Name, MUSW__Type__c, MUSW__Status__c, Permit2__c from Permit2s__r) from MUSW__Permit2__c where Id in :pids];
        Map<Id, MUSW__Permit2__c> psMap = new Map<Id, MUSW__Permit2__c>(ps);
        
        for (MUSW__Permit2__c p : trigger.new)
        {
            if (psMap.containsKey(p.Id))
            {
                // see if permit can be finaled
                if (psMap.get(p.Id).Permit2s__r.size() > 0)
                {
                    for (MUSW__Permit2__c subp : psMap.get(p.Id).Permit2s__r)
                    {
                        if (p.Id == subp.Permit2__c && subp.MUSW__Status__c != 'Finaled' && subp.MUSW__Status__c != 'Voided' && 'Mechanical,Plumbing,Electrical'.contains(subp.MUSW__Type__c))
                        {
                            p.addError('Cannot finalize Permit while non-finalized SubPermit exists: ' + subp.MUSW__Type__c + ' (' + subp.Name + ')');
                        }
                    }
                }
            }
        }
    }
}