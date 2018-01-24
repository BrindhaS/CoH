trigger AttachmentUpdateParcel on Attachment (after insert)
{
	/*
	 *	update parcel field Last_High_Grass_Sent_Date when High Grass letter generated
	 */
	
	Id[] insIds = new Id[]{};
	for (Attachment a : trigger.new) if (a.Name.contains('High_Grass')) insIds.add(a.parentId);
	
	MUSW__Inspection__c[] ins = [select MUSW__Parcel__c from MUSW__Inspection__c where Id in :insIds];
	
	MUSW__Parcel__c[] pars = new MUSW__Parcel__c[]{};
	for (MUSW__Inspection__c i : ins)
	{
		if (i.MUSW__Parcel__c != null)
		{
			MUSW__Parcel__c p = new MUSW__Parcel__c(Id = i.MUSW__Parcel__c);
			p.Last_High_Grass_Sent_Date__c = Date.today();
			pars.add(p);
		}
	}
	
	update pars;
}