<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Child_Iterate_Query_set_False</fullName>
        <field>Child_Iterate_Query__c</field>
        <literalValue>0</literalValue>
        <name>Child Iterate Query - set False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Letter_Query_Set_Child_Iterate_Query</fullName>
        <field>Child_Iterate_Query__c</field>
        <literalValue>1</literalValue>
        <name>Letter Query - Set Child Iterate Query</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Lettery Query Select Fields -Blank</fullName>
        <actions>
            <name>Child_Iterate_Query_set_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Applied_Query__c.Select_Fields__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lettery Query Select Fields not blank</fullName>
        <actions>
            <name>Letter_Query_Set_Child_Iterate_Query</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Applied_Query__c.Select_Fields__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
