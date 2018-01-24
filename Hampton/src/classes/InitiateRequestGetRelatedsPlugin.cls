global with sharing class InitiateRequestGetRelatedsPlugin implements Process.Plugin
{
    global Process.PluginResult invoke(Process.PluginRequest request)
    {
        String parentObj = (String)request.inputParameters.get('parentObj'); // MUSW__Project2__c
        String parentId = (String)request.inputParameters.get('parentId');
        String relatedObj = (String)request.inputParameters.get('relatedObject'); // MUSW__Permit2__c
        String relatedType = (String)request.inputParameters.get('relatedType'); // Building
        
        String relationshipName = (relatedObj.contains('__c')) ? relatedObj.replace('__c', 's__r') : relatedObj + 's';
        String typeWhere = (relatedType != '') ? ' where MUSW__Type__c = \'' + relatedType + '\'' : '';
        
        Sobject s = database.query('select Id, (select Id, Name from ' + relationshipName + typeWhere + ') from ' + parentObj + ' where Id = \'' + parentId + '\'');
        
        Map<String, Object> result = new Map<String, Object>();
        Integer sz = (s.getSobjects(relationshipName) != null) ? s.getSobjects(relationshipName).size() : 0;
        result.put('xRelatedSize', sz);
        
        String relId = '', relName = '';
        if (sz > 0)
        {
            relId = s.getSobjects(relationshipName)[0].Id;
            relName = String.valueOf(s.getSobjects(relationshipName)[0].get('Name'));
        }
            
        result.put('xRelatedId', relId);
        result.put('xRelatedName', relName);
        
        return new Process.PluginResult(result);
    }

    global Process.PluginDescribeResult describe()
    {
        Process.PluginDescribeResult result = new Process.PluginDescribeResult();
        result.Name = 'GetRelateds';
        result.Tag = 'InitiateRequestPlugins';
        
        result.inputParameters = new
        List<Process.PluginDescribeResult.InputParameter> {
        	new Process.PluginDescribeResult.InputParameter('parentObj',
            Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter('parentId',
            Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter('relatedObject',
            Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter('relatedType',
            Process.PluginDescribeResult.ParameterType.STRING, true)
        };
        
        result.outputParameters =
        new List<Process.PluginDescribeResult.OutputParameter> {
            new Process.PluginDescribeResult.OutputParameter('xRelatedSize',
            Process.PluginDescribeResult.ParameterType.INTEGER),
            new Process.PluginDescribeResult.OutputParameter('xRelatedId',
            Process.PluginDescribeResult.ParameterType.STRING),
            new Process.PluginDescribeResult.OutputParameter('xRelatedName',
            Process.PluginDescribeResult.ParameterType.STRING)
        };
        
        return result;
    }
    
    private static testMethod void testPlugin()
    {
    	BGBK.RulesEngineState.setLock();
        MUSW__Parcel__c p = new MUSW__Parcel__c(MUSW__Street_Number__c='106XXY', Name='MyNameIsParcelX');
        insert p;
        MUSW__Permit2__c perm = new MUSW__Permit2__c(MUSW__Type__c='Building');
        insert perm;
        BGBK.RulesEngineState.releaseLock();
        
        InitiateRequestGetRelatedsPlugin plugin = new InitiateRequestGetRelatedsPlugin();
        
        Map<String, Object> inputParams = new Map<String, Object>();
        inputParams.put('parentId', p.Id);
        inputParams.put('parentObj', 'MUSW__Parcel__c');
        inputParams.put('relatedObject', 'MUSW__Permit2__c');
        inputParams.put('relatedType', perm.MUSW__Type__c);

        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result = plugin.invoke(request);
    }
    
    private static testMethod void testDescribe()
    {
        InitiateRequestGetRelatedsPlugin plugin = new InitiateRequestGetRelatedsPlugin();
        Process.PluginDescribeResult result = plugin.describe();
    }
}