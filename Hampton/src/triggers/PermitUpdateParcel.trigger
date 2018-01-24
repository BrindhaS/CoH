trigger PermitUpdateParcel on MUSW__Permit2__c (after delete, after insert, after update, before insert, before update)
{
    // turn off for data loads
    if (!HamptonTriggerService.isRulesEngineActive()) return;
    if (HamptonTriggerService.isLocked()) return;
    
    MUSW__Permit2__c[] ps = trigger.isDelete ? trigger.old : trigger.new;
    Id[] parIds = new Id[]{};
    for (Integer i=0; i<ps.size(); i++)
    {
        if (ps[i].MUSW__Parcel__c != null)
        {
            if ((trigger.isUpdate && (trigger.new[i].MUSW__Parcel__c != trigger.old[i].MUSW__Parcel__c || trigger.new[i].MUSW__Type__c != trigger.old[i].MUSW__Type__c)) ||
                !trigger.isUpdate)
                parIds.add(ps[i].MUSW__Parcel__c);
        }
    }
    
    if (parIds.size() > 0)
    {
    	// get all parcels for the trigger-permits and
    	// get all Yard Sale permits that were either issued or started this year
        MUSW__Parcel__c[] pars = [select Id, Yard_Sales__c, Zoning__c, (select Id, MUSW__Status__c from MUSW__Permit2s__r where MUSW__Type__c like '%Yard Sale%' and ((MUSW__Issue_Date__c != null and MUSW__Issue_Date__c = THIS_YEAR) or (MUSW__Issue_Date__c = null and Valid_From__c = THIS_YEAR))) from MUSW__Parcel__c where Id in :parIds and MUSW__Parcel_Number2__c != 'No Parcel'];
        
        // fill in Yard sale count on Parcel
        MUSW__Parcel__c[] pars2update = new MUSW__Parcel__c[]{};
        if (trigger.isAfter)
        {
            for (MUSW__Parcel__c par : pars)
            {
                Integer count = par.MUSW__Permit2s__r.size();
                if (count != par.Yard_Sales__c)
                {
                	par.Yard_Sales__c = count;
                	pars2update.add(par);
                }
            }
            
            HamptonTriggerService.setLock();
            update pars2update;
            HamptonTriggerService.releaseLock();
        }
        
        // fill in Parcel Zoning on Permit
        if (trigger.isBefore)
        {
            Map<Id, MUSW__Parcel__c> parMap = new Map<Id, MUSW__Parcel__c>(pars);
            for (MUSW__Permit2__c p : ps)
            {
                if (parMap.containsKey(p.MUSW__Parcel__c)) p.Parcel_Zoning__c = parMap.get(p.MUSW__Parcel__c).Zoning__c;
            }
        }
    }
}