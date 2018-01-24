<xml>
<getPropertySchedule>
<![CDATA[
<xml xmlns:s="uuid:BDC6E3F0-6DA3-11d1-A2A3-00AA00C14882" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema">
 <s:Schema id="RowsetSchema">
 <s:ElementType name="row" content="eltOnly">
 <s:AttributeType name="CUNO" rs:number="1" rs:writeunknown="true">
 <s:datatype dt:type="float" dt:maxLength="8" rs:precision="15" rs:fixedlength="true" rs:maybenull="false"/>
 </s:AttributeType>
 <s:AttributeType name="CLIENT" rs:number="2" rs:nullable="true" rs:writeunknown="true">
 <s:datatype dt:type="string" rs:dbtype="str" dt:maxLength="40" rs:fixedlength="true"/>
 </s:AttributeType>
 <s:AttributeType name="SHYR" rs:number="3" rs:writeunknown="true">
 <s:datatype dt:type="float" dt:maxLength="8" rs:precision="15" rs:fixedlength="true" rs:maybenull="false"/>
 </s:AttributeType>
 <s:AttributeType name="SHCD" rs:number="4" rs:writeunknown="true">
 <s:datatype dt:type="float" dt:maxLength="8" rs:precision="15" rs:fixedlength="true" rs:maybenull="false"/>
 </s:AttributeType>
 <s:AttributeType name="SHOW" rs:number="5" rs:nullable="true" rs:writeunknown="true">
 <s:datatype dt:type="string" rs:dbtype="str" dt:maxLength="40" rs:fixedlength="true"/>
 </s:AttributeType>
 <s:AttributeType name="FCCD" rs:number="6" rs:nullable="true" rs:writeunknown="true">
 <s:datatype dt:type="float" dt:maxLength="8" rs:precision="15" rs:fixedlength="true"/>
 </s:AttributeType>
 <s:AttributeType name="CITY" rs:number="7" rs:nullable="true" rs:writeunknown="true">
 <s:datatype dt:type="string" rs:dbtype="str" dt:maxLength="30"/>
 </s:AttributeType>
 <s:AttributeType name="ASN_START_DATE" rs:number="8" rs:nullable="true" rs:writeunknown="true">
 <s:datatype dt:type="string" rs:dbtype="str" dt:maxLength="10"/>
 </s:AttributeType>
 <s:AttributeType name="ASN_END_DATE" rs:number="9" rs:nullable="true" rs:writeunknown="true">
 <s:datatype dt:type="string" rs:dbtype="str" dt:maxLength="10"/>
 </s:AttributeType>
 <s:AttributeType name="SHOW_START_DATE" rs:number="10" rs:nullable="true" rs:writeunknown="true">
 <s:datatype dt:type="string" rs:dbtype="str" dt:maxLength="4000"/>
 </s:AttributeType>
 <s:AttributeType name="SHOW_END_DATE" rs:number="11" rs:nullable="true" rs:writeunknown="true">
 <s:datatype dt:type="string" rs:dbtype="str" dt:maxLength="4000"/>
 </s:AttributeType>
 <s:extends type="rs:rowbase"/>
 </s:ElementType>
 </s:Schema>
 <rs:data>
 <z:row CUNO="1011" CLIENT="Acura " SHYR="2012" SHCD="1612" SHOW="No Show " FCCD="100122" CITY="Auburn Hills, MI" ASN_START_DATE="2012-01-04" ASN_END_DATE="2012-01-04" SHOW_START_DATE="2012-01-01" SHOW_END_DATE="2012-12-31"/>
 <z:row CUNO="1011" CLIENT="Acura " SHYR="2012" SHCD="399386" SHOW="Sundance Film Festival " FCCD="479573" CITY="Park City, UT" ASN_START_DATE="2012-01-12" ASN_END_DATE="2012-01-30" SHOW_START_DATE="2012-01-19" SHOW_END_DATE="2012-04-15"/>
 <z:row CUNO="1011" CLIENT="Acura " SHYR="2012" SHCD="487515" SHOW="MusiCares Person of the Year Tribute " FCCD="7779" CITY="Los Angeles, CA" ASN_START_DATE="2012-02-08" ASN_END_DATE="2012-02-10" SHOW_START_DATE="2012-02-10" SHOW_END_DATE="2012-02-10"/>
 </rs:data>
 </xml>
]]>
</getPropertySchedule>
</xml>