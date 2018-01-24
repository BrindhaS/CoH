trigger MilestoneUpdateSubmission on MUSW__Milestone__c (after insert, after update, after delete)
{
    MUSW__Milestone__c[] ms = trigger.isDelete ? trigger.old : trigger.new;
    Id[] subIds = new Id[]{};
    for (Integer i=0; i<ms.size(); i++)
    {
        if (ms[i].Submission__c != null)
        {
            if ((trigger.isUpdate && (trigger.new[i].Submission__c != trigger.old[i].Submission__c || trigger.new[i].MUSW__Status__c != trigger.old[i].MUSW__Status__c)) ||
                !trigger.isUpdate)
                subIds.add(ms[i].Submission__c);
        }
        else
        {
            if (trigger.isUpdate && trigger.old[i].Submission__c != null)
                subIds.add(trigger.old[i].Submission__c);
        }
    }
    
    HamptonTriggerService.updateSubmissionTotals(subIds);
}