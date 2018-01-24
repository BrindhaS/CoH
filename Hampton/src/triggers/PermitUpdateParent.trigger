trigger PermitUpdateParent on MUSW__Permit2__c (after update) {
    //Issued on Occupancy permit updates parent permit
    
    // turn off for data loads
    if (!HamptonTriggerService.isRulesEngineActive()) return;
    if (HamptonTriggerService.isLocked()) return;
    
    MUSW__Permit2__c[] ps = trigger.new;    
    Map<Id, Date> coPermsMap = new Map<Id, Date>(); // Map<copmtId : issue date>
    
    // get all co permits with status is issued
    for (Integer i=0; i<ps.size(); i++)
    {
        if (ps[i].MUSW__Status__c == 'Issued' && ps[i].MUSW__Type__c == 'Occupancy Certificate' && ps[i].Permit2__c != null)
        {
                coPermsMap.put(ps[i].Permit2__c,ps[i].MUSW__Issue_Date__c);
        }
    }
    
    if (coPermsMap.size() >0)
    {
        MUSW__Permit2__c[] pPerms = [select Id, C_of_O_Issued_Date__c,MUSW__Status__c from MUSW__Permit2__c where Id in: coPermsMap.keySet()];
        for (MUSW__Permit2__c p: pPerms)
        {
            p.MUSW__Status__c ='C/O Issued';
            p.C_of_O_Issued_Date__c = coPermsMap.get(p.Id);
        }
        HamptonTriggerService.setLock();
        update pPerms;
        HamptonTriggerService.releaseLock();
    }
}