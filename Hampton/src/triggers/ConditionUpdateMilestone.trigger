trigger ConditionUpdateMilestone on MUSW__Condition__c (after delete, after insert, after update) 
{
    MUSW__Condition__c[] cs = trigger.isDelete ? trigger.old : trigger.new;
    
    Id[] mIds = new Id[]{};
    for (MUSW__Condition__c c : cs) if (c.Milestone__c != null) mIds.add(c.Milestone__c);
    
    if (mIds.size() > 0)
    {
        MUSW__Milestone__c[] ms = [select Id, Comments_Present__c, Current_Comments__c, (select Id, MUSW__Full_Description__c, Correction_Required__c from Conditions__r where IsClosed__c = 'No' order by CreatedDate) from MUSW__Milestone__c where Id in :mIds];
        
        for (MUSW__Milestone__c m : ms)
        {
            String currentComments = '';
            Integer i = 1;
            for (MUSW__Condition__c c : m.Conditions__r)
            {
                if (c.MUSW__Full_Description__c != null) 
                {
                    if (!currentComments.contains(c.MUSW__Full_Description__c))
                    {
                        currentComments += i + '. ' + c.MUSW__Full_Description__c + '\n';
                        String tempStr = '';
                        if (c.Correction_Required__c != null) tempStr = 'Corrections: ' + c.Correction_Required__c + '\n';
                        else tempStr = 'Corrections: Required'+ '\n';
                        currentComments += tempStr;
                        i++;
                    }
                }
            }
            currentComments = currentComments.removeEnd('\n');
            
            m.Current_Comments__c = currentComments;
            m.Comments_Present__c = currentComments != '';
        }
        
        update ms;
    }
}