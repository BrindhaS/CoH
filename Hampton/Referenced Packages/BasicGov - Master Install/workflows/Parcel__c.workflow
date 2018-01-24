<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Parcel_Primary_Contact_Name_Set</fullName>
        <field>Primary_Contact_Name__c</field>
        <formula>if(Primary_Contact__r.FirstName != &quot;&quot;,Primary_Contact__r.FirstName+ &quot; &quot;,&quot;&quot;) + Primary_Contact__r.LastName</formula>
        <name>Parcel Primary Contact Name Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Blank Parcel City %26 Zip</fullName>
        <actions>
            <name>ParcelCityDefault</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ParcelPostZipCodeDefault</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Parcel__c.City__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Parcel__c.Post_Zip_Code__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Default City &amp; Zip if both are blank</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Parcel Primary Contact not blank</fullName>
        <actions>
            <name>Parcel_Primary_Contact_Name_Set</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(AND(Primary_Contact__c != null, Primary_Contact_Name__c == null),ISCHANGED(Primary_Contact__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
