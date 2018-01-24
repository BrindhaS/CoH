global with sharing class SearchPlugin implements Process.Plugin
{
    global Process.PluginResult invoke(Process.PluginRequest request)
    {
        String objectName = (String)request.inputParameters.get('object');
        String field = (String)request.inputParameters.get('field');
        String value = (String)request.inputParameters.get('value');
        String fieldExact = (String)request.inputParameters.get('fieldExact');
        String valueExact = (String)request.inputParameters.get('valueExact');
        String resultField = (String)request.inputParameters.get('resultField');
        Boolean useScramble = (Boolean)request.inputParameters.get('useScramble');
        if (useScramble == null) useScramble = false;
        field = (!String.isBlank(field)) ? field.trim() : '';
        value = (!String.isBlank(value)) ? value.trim() : '';
        fieldExact = (!String.isBlank(fieldExact)) ? fieldExact.trim() : '';
        valueExact = (!String.isBlank(valueExact)) ? valueExact.trim() : '';
        
        Map<String, Object> result = new Map<String, Object>();
        
        // delete previous search results
        Flow_Query_Result__c[] fqrOld = [select Id from Flow_Query_Result__c where ObjectName__c = :objectName and SessionId__c = :UserInfo.getSessionId() limit 20000];
        if (fqrOld.size() > 0) delete fqrOld;
        
        // see if exact match exists, else use fuzzy search to find near matches
        Sobject[] matches1 = new Sobject[]{};
        Sobject[] matches2 = new Sobject[]{};
        String resFldQ = (resultField.equalsIgnoreCase(field) || resultField.equalsIgnoreCase('Name')) ? '' : resultField + ', ';
        String nameFldQ = (field.equalsIgnoreCase('Name')) ? '' : 'Name, ';
        String fields = nameFldQ + resFldQ + field;
        fields = fields.removeEnd(', ');
        
        // RecordType requires separate query to get user permissions
        if (objectName.equalsIgnoreCase('RecordType'))
        {
            Map<String, Schema.SObjectType> gdesc = Schema.getGlobalDescribe();
            Schema.DescribeSObjectResult d = gdesc.get(value.toLowerCase()).getDescribe();
            Map<String, Schema.RecordTypeInfo> rtMap = d.getRecordTypeInfosByName();
            for (String rtName : rtMap.keySet())
            {
                RecordTypeInfo rti = rtMap.get(rtName);
                if (rti.isAvailable() && rtName != 'Master')
                {
                    RecordType rtTemp = new RecordType(Id=rti.getRecordTypeId(), Name=rtName);
                    rtTemp.put(resultField, rtName);
                    matches1.add(rtTemp);
                }
            }
        }
        else
        {
            // build where-clause filters
            String fuzzyFilter = '';
            if (useScramble && !String.isBlank(field) && !String.isBlank(value))
            {
                String[] valueArr = value.split(' ');
                for (Integer i=0; i<valueArr.size(); i++)
                {
                    String w = valueArr[i].toUpperCase().remove('.').remove(',').remove('&').remove('(').remove(')').remove('\'').remove('-').remove('%');
                    if (w.deleteWhitespace() != '') fuzzyFilter += field + ' like \'%' + w + '%\' and ';
                }
                fuzzyFilter = '(' + fuzzyFilter.removeEnd(' and ') + ')';
            }
            else
            {
                fuzzyFilter = (!String.isBlank(field)) ? field + ' = :value' : '';
            }
            
            String exactFilter = (!String.isBlank(fieldExact)) ? fieldExact + ' = :valueExact' : '';
            if (exactFilter != '' && fuzzyFilter != '') exactFilter = ' and ' + exactFilter;
            
            matches1 = database.query('select ' + fields + ' from ' + objectName + ' where ' + fuzzyFilter + exactFilter + ' limit 20000');
            if (matches1.size() == 0 && !String.isBlank(field))
            {
                // create tokens of 3/4/5/6 characters for the where clause based on value length
                // also keep tokens of 2 extra length to use in case the query returns too many results
                String whereTokens = '', whereTokensPlus = '';
                String valueNospace = value.deleteWhitespace().remove('.').remove(',').remove('&').remove('(').remove(')').remove('\'').remove('-').remove('%');
                Integer len;
                if (valueNospace.length() > 30) len = 6;
                else if (valueNospace.length() > 20) len = 5;
                else if (valueNospace.length() > 4) len = 4;
                else len = 3;
                for (Integer i=0; i<valueNospace.length()-len+1; i++)
                {
                    String token = String.escapeSingleQuotes(valueNospace.mid(i, len));
                    whereTokens += field + ' like \'%' + token + '%\' or ';
                    
                    if (i < valueNospace.length()-len-1)
                    {
                        String tokenPlus = String.escapeSingleQuotes(valueNospace.mid(i, len+2));
                        whereTokensPlus += field + ' like \'%' + tokenPlus + '%\' or ';
                    }
                }
                if (whereTokens != '') whereTokens = '(' + whereTokens.removeEnd(' or ') + ')';
                else whereTokens = field + ' like \'%' + String.escapeSingleQuotes(valueNospace) + '%\'';
                if (whereTokensPlus != '') whereTokensPlus = '(' + whereTokensPlus.removeEnd(' or ') + ')';
                else whereTokensPlus = field + ' like \'%' + String.escapeSingleQuotes(valueNospace) + '%\'';
                
                system.debug('select ' + fields + ' from ' + objectName + ' where ' + whereTokens + exactFilter + ' limit 1000');
                Sobject[] recs = database.query('select ' + fields + ' from ' + objectName + ' where ' + whereTokens + exactFilter + ' limit 1000');
                
                // reduce query size by using longer tokens to save on Apex statements
                if (recs.size() == 1000)
                {
                    recs = database.query('select ' + fields + ' from ' + objectName + ' where ' + whereTokensPlus + exactFilter + ' limit 20000');
                }
                
                /*for (Sobject c : recs)
                {
                    Decimal score = FuzzySearch.Compare(value, (String)c.get(field), useScramble);
                    if (score > 0.9) matches1.add(c);
                    if (score > 0.5) matches2.add(c);
                }*/
                
                Map<Decimal, Sobject[]> scoredRecs = FuzzySearch.Score(recs, field, value);
                for (Decimal score : scoredRecs.keySet())
                {
                    if (score > 0.9) matches1.addAll(scoredRecs.get(score));
                    if (score > 0.5) matches2.addAll(scoredRecs.get(score));
                }
            }
        }
        
        if (matches1.size() == 1)
        {
            result.put('xResultId', matches1[0].Id);
            result.put('xResultName', String.valueOf(matches1[0].get('Name')));
            result.put('xResultSize', matches1.size());
        }
        else if (matches1.size() > 1)
        {
            insertFQRs(objectName, matches1, resultField);
            result.put('xResultSize', matches1.size());
        }
        else if (matches2.size() > 0)
        {
            insertFQRs(objectName, matches2, resultField);
            result.put('xResultSize', matches2.size());
        }
        else
        {
            result.put('xResultSize', 0);
        }
        
        result.put('xSessionId', UserInfo.getSessionId());
        
        return new Process.PluginResult(result);
    }

    global Process.PluginDescribeResult describe()
    {
        Process.PluginDescribeResult result = new Process.PluginDescribeResult();
        result.Name = 'Search';
        result.Tag = 'RegistrationPlugins';
        
        result.inputParameters = new
        List<Process.PluginDescribeResult.InputParameter> {
            new Process.PluginDescribeResult.InputParameter('value',
            Process.PluginDescribeResult.ParameterType.STRING, false),
            new Process.PluginDescribeResult.InputParameter('object',
            Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter('field',
            Process.PluginDescribeResult.ParameterType.STRING, false),
            new Process.PluginDescribeResult.InputParameter('fieldExact',
            Process.PluginDescribeResult.ParameterType.STRING, false),
            new Process.PluginDescribeResult.InputParameter('valueExact',
            Process.PluginDescribeResult.ParameterType.STRING, false),
            new Process.PluginDescribeResult.InputParameter('resultField',
            Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter('useScramble',
            Process.PluginDescribeResult.ParameterType.BOOLEAN, false)
        };
        
        result.outputParameters =
        new List<Process.PluginDescribeResult.OutputParameter> {
            new Process.PluginDescribeResult.OutputParameter('xResultSize',
            Process.PluginDescribeResult.ParameterType.INTEGER),
            new Process.PluginDescribeResult.OutputParameter('xResultId',
            Process.PluginDescribeResult.ParameterType.STRING),
            new Process.PluginDescribeResult.OutputParameter('xResultName',
            Process.PluginDescribeResult.ParameterType.STRING),
            new Process.PluginDescribeResult.OutputParameter('xSessionId',
            Process.PluginDescribeResult.ParameterType.STRING)
        };
        
        return result;
    }
    
    private void insertFQRs(String objectName, Sobject[] objs, String resultField)
    {
        Flow_Query_Result__c[] fqrs = new Flow_Query_Result__c[]{};
        for (Sobject c : objs)
        {
            Flow_Query_Result__c fqr = new Flow_Query_Result__c(ObjectName__c=objectName, ObjectId__c=c.Id, ObjectValue__c=(String)c.get(resultField), Name=(String)c.get('Name'), SessionId__c=UserInfo.getSessionId());
            fqrs.add(fqr);
        }
        insert fqrs;
    }
    
    private static testMethod void testPlugin()
    {
        SearchPlugin plugin = new SearchPlugin();
        
        Map<String, Object> inputParams = new Map<String, Object>();
        inputParams.put('value', 'test garbage');
        inputParams.put('field', 'Name');
        inputParams.put('object', 'Contact');
        inputParams.put('resultField', 'Name');

        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result = plugin.invoke(request);
    }
    
    private static testMethod void testDescribe()
    {
        SearchPlugin plugin = new SearchPlugin();
        Process.PluginDescribeResult result = plugin.describe();
    }
}