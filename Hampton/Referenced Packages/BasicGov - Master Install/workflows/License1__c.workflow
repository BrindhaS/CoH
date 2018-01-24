<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>License_No_Dup_update</fullName>
        <field>Tracking_Number1__c</field>
        <formula>Tracking_Number__c</formula>
        <name>License No. (Dup) update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>License No%2E Changed %28Update External ID%29</fullName>
        <actions>
            <name>License_No_Dup_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISCHANGED( Tracking_Number__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
