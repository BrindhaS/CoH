trigger CartSequenceNumber on Cart__c (before insert, before update) {
    //update track Numbers
    MUSW.SequenceNumber.updateNumbers(Trigger.new);
}