<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Login_New_User_Created</fullName>
        <description>Login - New User Created</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Templates/Login_New_User_Created</template>
    </alerts>
    <rules>
        <fullName>Login %E2%80%93 New User Created</fullName>
        <actions>
            <name>Login_New_User_Created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Login_UserInfo__c.Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
