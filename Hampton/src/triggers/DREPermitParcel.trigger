trigger DREPermitParcel on MUSW__Permit_Parcel__c (after insert, before update)
{
    String actionType = (Trigger.isUpdate) ? 'Update' : ((Trigger.isInsert) ? 'Insert' : 'Delete');
    BGBK.TriggerManager.DREGeneric(actionType, Trigger.new, Trigger.old);
}