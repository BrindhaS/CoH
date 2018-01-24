trigger InspectionExtendPermits on MUSW__Inspection__c (after insert, after update)
{
    // turn off for data loads
    if (!HamptonTriggerService.isRulesEngineActive()) return;
    if (HamptonTriggerService.isLocked()) return;
    
    Id[] pids = new Id[]{};
    Set<Id> finalPids = new Set<Id>();
    for (Integer i=0; i<trigger.new.size(); i++)
    {
        if (trigger.new[i].MUSW__Permit__c != null && 
            (trigger.new[i].MUSW__Status__c.contains('Passed') || trigger.new[i].MUSW__Status__c.contains('Approved')) &&
            ((trigger.isUpdate && trigger.new[i].MUSW__Status__c != trigger.old[i].MUSW__Status__c) || trigger.isInsert))
        {
            pids.add(trigger.new[i].MUSW__Permit__c);
            
            if (trigger.new[i].MUSW__Type__c.contains('- Final'))
                finalPids.add(trigger.new[i].MUSW__Permit__c);
        }
    }
    
    // set expiry date on child and parent permits to 6 months from now
    if (pids.size() > 0)
    {
        Map<Id, MUSW__Permit2__c> perms = new Map<Id, MUSW__Permit2__c>();
        MUSW__Permit2__c[] ps = [select id, MUSW__Expiration_Date__c, Permit2__c, Permit2__r.MUSW__Expiration_Date__c, (select id, MUSW__Expiration_Date__c from Permit2s__r where MUSW__Expiration_Date__c != null and MUSW__Status__c != 'Finaled') from MUSW__Permit2__c where Id in :pids and MUSW__Expiration_Date__c != null];
        
        for (MUSW__Permit2__c p : ps)
        {
            // extend permit
            if (!perms.containsKey(p.Id))
            {
                p.MUSW__Expiration_Date__c = Date.today().addMonths(6);
                
                // final parent Permit
                if (finalPids.contains(p.Id))
                {
                    p.MUSW__Status__c = 'Finaled';
                }
                
                perms.put(p.Id, p);
            }
            
            // extend parent permit
            if (p.Permit2__c != null && !perms.containsKey(p.Permit2__c) && p.Permit2__r.MUSW__Expiration_Date__c != null)
            {
                p.Permit2__r.MUSW__Expiration_Date__c = Date.today().addMonths(6);
                perms.put(p.Permit2__c, p.Permit2__r);
            }
            
            // extend child permits
            for (MUSW__Permit2__c subp : p.Permit2s__r)
            {
                if (!perms.containsKey(subp.Id))
                {
                    subp.MUSW__Expiration_Date__c = Date.today().addMonths(6);
                    perms.put(subp.Id, subp);
                }
            }
        }
        
        try
        {
            //HamptonTriggerService.setLock();
            update perms.values();
            //HamptonTriggerService.releaseLock();
        }
        catch (System.Dmlexception ex)
        {
            if (!ex.getMessage().contains('SELF_REFERENCE_FROM_TRIGGER') &&
                !ex.getMessage().contains('Cannot finalize Permit while non-finalized SubPermit exists'))
                throw ex;
        }
    }
}