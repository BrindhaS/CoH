trigger ComplaintDuplicateCheck on MUSW__Complaint2__c (before insert, before update)
{
    // turn off for data loads
    if (!HamptonTriggerService.isRulesEngineActive()) return;
    
    Id[] parIds = new Id[]{};
    for (MUSW__Complaint2__c c : trigger.new) if (c.Complaint2__c == null && !c.MUSW__Status__c.contains('Closed') && c.MUSW__Parcel__c != null) parIds.add(c.MUSW__Parcel__c);
    
    if (parIds.size() > 0)
    {
        MUSW__Parcel__c[] pars = [select Id, (select Id, Name, MUSW__Type__c, Subtype__c from MUSW__Complaint2s__r where not(MUSW__Status__c like '%Closed%')) from MUSW__Parcel__c where Id in :parIds];
        Map<Id, MUSW__Parcel__c> parsMap = new Map<Id, MUSW__Parcel__c>(pars);
        
        // error if duplicate Complaint exists on Parcel & current Complaint is not linked to it
        for (MUSW__Complaint2__c c : trigger.new)
        {
            if (c.Complaint2__c == null && !c.MUSW__Status__c.contains('Closed') && c.MUSW__Parcel__c != null)
            {
                for (MUSW__Complaint2__c c2 : parsMap.get(c.MUSW__Parcel__c).MUSW__Complaint2s__r)
                {
                    if (c2.MUSW__Type__c == c.MUSW__Type__c && c2.Subtype__c == c.Subtype__c && c2.Id != c.Id)
                    {
                        c.AddError('Duplicate Case found: ' + c2.Name + '. Fill in ' + MUSW__Complaint2__c.Complaint2__c.getDescribe().getLabel() + '.');
                        break;
                    }
                }
            }
        }
    }
}