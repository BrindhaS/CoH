<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Receipt_Amount_adjust_Available</fullName>
        <field>Amount_Available__c</field>
        <formula>PRIORVALUE(Amount_Available__c) + Amount_Tendered__c - BLANKVALUE(PRIORVALUE( Amount_Tendered__c ),0)</formula>
        <name>Receipt Amount adjust Available</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Receipt_Reject_adjust_Available</fullName>
        <field>Amount_Available__c</field>
        <formula>PRIORVALUE(Amount_Available__c) + BLANKVALUE(PRIORVALUE(Amount_Rejected__c),0) - BLANKVALUE(Amount_Rejected__c,0)</formula>
        <name>Receipt Reject adjust Available</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Receipts_Amounts_Adjust_Available</fullName>
        <field>Amount_Available__c</field>
        <formula>PRIORVALUE(Amount_Available__c) + 
(Amount_Tendered__c - BLANKVALUE(PRIORVALUE( Amount_Tendered__c ),0)) + 
(BLANKVALUE(PRIORVALUE(  Amount_Rejected__c  ),0) - Amount_Rejected__c  )</formula>
        <name>Receipts Amounts Adjust Available</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetReceiptAvailableAmount</fullName>
        <field>Amount_Available__c</field>
        <formula>Amount_Tendered__c -  BLANKVALUE(Amount_Rejected__c, 0)</formula>
        <name>Set Receipt Available Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Receipt Amount %26 Rejected Changed</fullName>
        <actions>
            <name>Receipts_Amounts_Adjust_Available</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(Amount_Tendered__c),ISCHANGED(  Amount_Rejected__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Receipt Amount Changed</fullName>
        <actions>
            <name>Receipt_Amount_adjust_Available</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(Amount_Tendered__c),NOT(ISCHANGED(  Amount_Rejected__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Receipt Blank Available Amount</fullName>
        <actions>
            <name>SetReceiptAvailableAmount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Receipt__c.Amount_Available__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Receipt__c.Amount_Tendered__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Receipt Reject Changed</fullName>
        <actions>
            <name>Receipt_Reject_adjust_Available</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(Amount_Rejected__c),NOT(ISCHANGED( Amount_Tendered__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
