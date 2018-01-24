<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Paid_in_Full_check</fullName>
        <field>Fee_Paid__c</field>
        <literalValue>1</literalValue>
        <name>Paid in Full check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Paid_in_Full_uncheck</fullName>
        <field>Fee_Paid__c</field>
        <literalValue>0</literalValue>
        <name>Paid in Full uncheck</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Blank Flat Fee Amount</fullName>
        <actions>
            <name>FeeAmountSet</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FeePricePerUnitSetFlex</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) and 3</booleanFilter>
        <criteriaItems>
            <field>Fee__c.Amount__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Fee__c.Amount__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Fee__c.Fee_Paid__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Calculate/Default the Fee Amount based on the Fee Type when the Amount is not specified or is zero</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Paid in Full check</fullName>
        <actions>
            <name>Paid_in_Full_check</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Fee__c.Outstanding_Fee__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Fee__c.Amount__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Paid in Full uncheck</fullName>
        <actions>
            <name>Paid_in_Full_uncheck</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Fee__c.Outstanding_Fee__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
