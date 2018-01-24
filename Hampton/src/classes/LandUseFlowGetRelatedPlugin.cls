global with sharing class LandUseFlowGetRelatedPlugin implements Process.Plugin
{
    global Process.PluginResult invoke(Process.PluginRequest request)
    {
        String parcelId = (String)request.inputParameters.get('parcelId');
        String relatedObj = (String)request.inputParameters.get('relatedObject'); // MUSW__Permit2__c
        String relatedType = (String)request.inputParameters.get('relatedType'); // Building
        
        String relationshipName = (relatedObj == 'MUSW__Permit2__c') ? 'MUSW__Permit2s__r' : 'MUSW__Project2s__r';
        String fields = (relatedObj == 'MUSW__Permit2__c') ? ', MUSW__Type__c, MUSW__Status__c' : ', MUSW__Status__c';
        String typeWhere = (relatedType != '') ? ' where MUSW__Type__c = \'' + relatedType + '\'' : '';
        MUSW__Parcel__c parcel = database.query('select Id, (select Id, Name' + fields + ' from ' + relationshipName + typeWhere + ') from MUSW__Parcel__c where Id = \'' + parcelId + '\'');
        
        Map<String, Object> result = new Map<String, Object>();
        Integer sz = (parcel.getSobjects(relationshipName) != null) ? parcel.getSobjects(relationshipName).size() : 0;
        result.put('xRelatedSize', sz);
        
        String relId = '', relName = '';
        if (sz > 0)
        {
            relId = parcel.getSobjects(relationshipName)[0].Id;
            relName = String.valueOf(parcel.getSobjects(relationshipName)[0].get('Name'));
        }
            
        result.put('xRelatedId', relId);
        result.put('xRelatedName', relName);
        
        return new Process.PluginResult(result);
    }

    global Process.PluginDescribeResult describe()
    {
        Process.PluginDescribeResult result = new Process.PluginDescribeResult();
        result.Name = 'LandUseFlowGetRelatedPlugin';
        result.Tag = 'LandUseFlowGetRelatedPlugin';
        
        result.inputParameters = new
        List<Process.PluginDescribeResult.InputParameter> {
            new Process.PluginDescribeResult.InputParameter('parcelId',
            Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter('relatedObject',
            Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter('relatedType',
            Process.PluginDescribeResult.ParameterType.STRING, true)
        };
        
        result.outputParameters =
        new List<Process.PluginDescribeResult.OutputParameter> {
            new Process.PluginDescribeResult.OutputParameter('xReslatedSize',
            Process.PluginDescribeResult.ParameterType.INTEGER),
            new Process.PluginDescribeResult.OutputParameter('xReslatedId',
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
        
        LandUseFlowGetRelatedPlugin plugin = new LandUseFlowGetRelatedPlugin();
        
        Map<String, Object> inputParams = new Map<String, Object>();
        inputParams.put('parcelId', p.Id);
        inputParams.put('relatedObject', 'MUSW__Permit2__c');
        inputParams.put('relatedType', perm.MUSW__Type__c);

        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result = plugin.invoke(request);
    }
    
    private static testMethod void testDescribe()
    {
        LandUseFlowGetRelatedPlugin plugin = new LandUseFlowGetRelatedPlugin();
        Process.PluginDescribeResult result = plugin.describe();
    }
}