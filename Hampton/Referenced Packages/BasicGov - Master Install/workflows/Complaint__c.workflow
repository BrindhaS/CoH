<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Blank Complaint City %26 Zip</fullName>
        <actions>
            <name>ComplaintCityDefault</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ComplaintPostalZipCodeDefault</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Default the City &amp; Zip when both are blank</description>
        <formula>AND(ISNULL(Parcel__c ),  ISNULL(City__c ),ISNULL( Post_Zip_Code__c ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
