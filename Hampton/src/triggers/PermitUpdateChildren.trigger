trigger PermitUpdateChildren on MUSW__Permit2__c (after update)
{
	// turn off for data loads
	if (!HamptonTriggerService.isRulesEngineActive()) return;
	
	Id[] pids = new Id[]{};
	for (MUSW__Permit2__c p : trigger.new)
	{
		if (p.MUSW__Status__c == 'Voided' && p.MUSW__Type__c == 'Building')
		{
			pids.add(p.Id);
		}
	}
	
	if (pids.size() > 0)
	{
		MUSW__Permit2__c[] ps = [select MUSW__Status__c from MUSW__Permit2__c where Permit2__c in :pids];
		
		MUSW__Permit2__c[] subPs = new MUSW__Permit2__c[]{};
		for(MUSW__Permit2__c pm : ps)
		{
			if (pm.MUSW__Status__c != 'Voided')
			{
				pm.MUSW__Status__c = 'Voided';
				subPs.add(pm);
			}
		}
		
		update subPs;
	}
}