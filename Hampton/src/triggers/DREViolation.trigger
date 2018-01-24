trigger DREViolation on MUSW__Violation__c (after insert, before update, after update)
{
	Boolean changedCond = trigger.new[0].MUSW__Status__c == 'Contractor Completed' && 
		trigger.new[0].MUSW__Status__c != trigger.old[0].MUSW__Status__c;
	
	// the rule on update of Violation that creates IV doesn't work on before-update (due to master-detail)
	// if said rule is expected to fire (when Violation is manually closed with Status Contractor Completed)
	// then run it in after-update, otherwise run in default mode
	if (trigger.isBefore && trigger.isUpdate && changedCond) return;
	if (trigger.isAfter && trigger.isUpdate && !changedCond) return;
	
	String actionType = (Trigger.isUpdate) ? 'Update' : ((Trigger.isInsert) ? 'Insert' : 'Delete');
    BGBK.TriggerManager.DREGeneric(actionType, Trigger.new, Trigger.old);
}