trigger AttachmentInsertFile on Attachment (after delete, after insert)
{
	Map<Id, Attachment> attsMap = Trigger.isDelete ? Trigger.oldMap : Trigger.newMap;
	
	if (Trigger.isInsert)
	{
		Attachment[] attr = [select Id, Name, parent.Name, Description, OwnerId from Attachment where Id in :attsMap.keySet()];
		
		File__c[] f2add = new File__c[]{};
		for (Attachment a : attr)
		{
			Boolean isSysGen = a.Description != null && a.Description.contains('SYSGEN');
			f2add.add(new File__c(ObjectId__c=a.Id, Name=a.Name, ParentName__c=a.parent.Name, OwnerId=a.OwnerId, SysGen__c=isSysGen, Type__c='Attachment'));
		}
		
		insert f2add;
	}
	else
	{
		File__c[] fs = [select Id from File__c where ObjectId__c in :attsMap.keySet()];
		delete fs;
	}
}