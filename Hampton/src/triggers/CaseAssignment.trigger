/*
    This trigger is used to do following thing:
        -- Update the Case Owner of the Case according to the Case Assignment Rule.
*/

trigger CaseAssignment on Case (after insert, after update) {

    //For changing Case Owner
        Set<Id> CaseId = new Set<Id>();
        if(Trigger.isInsert)    {   
            if (!CaseFieldUpdate.inFutureContext) {
                for (Case c : Trigger.new) 
                    CaseId.add(c.id);
            
                if (!CaseId.isEmpty())
                    CaseAssignmentProcessor.processCases(CaseId);
            }         
        }

    if(Trigger.isUpdate)    { 
        if (!CaseFieldUpdate.inFutureContext) {
                for (Case c : Trigger.new) {
                    Case oldCase = Trigger.oldMap.get(c.Id);
                    if(oldCase.OwnerId == c.OwnerId)
                        CaseId.add(c.id);
                }
                
                if (!CaseId.isEmpty())
                    CaseAssignmentProcessor.processCases(CaseId);
        }                 
    }
}