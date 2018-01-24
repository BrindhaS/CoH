trigger CaseInsert on Case (after insert, after update) 
{
    CaseModel.HandleInsert(trigger.new, trigger.old);
}