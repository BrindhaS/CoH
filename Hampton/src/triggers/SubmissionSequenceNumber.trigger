trigger SubmissionSequenceNumber on MUSW__Submission__c (before insert) {
	MUSW.SequenceNumber.updateNumbers(Trigger.new);
}