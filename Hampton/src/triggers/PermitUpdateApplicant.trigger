trigger PermitUpdateApplicant on MUSW__Permit2__c (before insert, before update, after delete)
{
    // turn off for data loads
    if (!HamptonTriggerService.isRulesEngineActive()) return;
    if (HamptonTriggerService.isLocked()) return;
    
    MUSW__Permit2__c[] ps = trigger.isDelete ? trigger.old : trigger.new;
    
    Id[] cids = new Id[]{};
    for (Integer i=0; i<ps.size(); i++)
    {
        cids.add(ps[i].MUSW__Applicant__c);
    }
    
    // fill in Open Permits on Applicant
    Contact[] cs = [select Id, Open_Permits__c, (select Name from MUSW__Applicant_Permit2s__r) from Contact where Id in :cids];
    for (Contact c : cs)
    {
        String types = '';
        for (MUSW__Permit2__c p : c.MUSW__Applicant_Permit2s__r) types += ', ' + p.Name;
        types = types.replaceFirst(', ', '');
        c.Open_Permits__c = types;
    }
    
    // the inspection might be locked by another trigger. if so skip
    try
    {
        HamptonTriggerService.setLock();
        update cs;
    }
    catch (System.Dmlexception ex)
    {
        if (!ex.getMessage().contains('SELF_REFERENCE_FROM_TRIGGER')) throw ex;
    }
    finally
    {
        HamptonTriggerService.releaseLock();
    }
}