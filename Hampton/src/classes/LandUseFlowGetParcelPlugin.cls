global with sharing class LandUseFlowGetParcelPlugin implements Process.Plugin
{
    global Process.PluginResult invoke(Process.PluginRequest request)
    {
        String streetNameOrApn = (String)request.inputParameters.get('streetNameOrParcelNumber');
        String streetNum = (String)request.inputParameters.get('streetNumber');
        String streetName = (String)request.inputParameters.get('streetName');
        String apn = (String)request.inputParameters.get('parcelNumber');
        
        String qWhere = '';
        if (!String.isBlank(streetNameOrApn))
        {
        	qWhere += ' where Name like \'%' + streetNameOrApn + '%\'';
        }
        else if (!String.isBlank(apn))
        {
        	qWhere += ' where Name like \'%' + apn + '%\'';
        }
        if (!String.isBlank(streetNum))
        {
        	String strWhere = ' MUSW__Street_Number__c like \'%' + streetNum + '%\'';
        	qWhere += (qWhere != '') ? ' and ' + strWhere : ' where ' + strWhere;
        }
        if (!String.isBlank(streetName))
        {
        	String strWhere = ' Name like \'%' + streetName + '%\'';
        	qWhere += (qWhere != '') ? ' and ' + strWhere : ' where ' + strWhere;
        }
        
        MUSW__Parcel__c[] parcels = database.query('select Id, Name from MUSW__Parcel__c' + qWhere);
        
        Map<String, Object> result = new Map<String, Object>();
        Integer sz = parcels.size();
        result.put('xParcelSize', sz);
        
        String parcelId = '', parcelName = '';
        if (parcels.size() > 0)
        {
            parcelId = parcels[0].Id;
            parcelName = parcels[0].Name;
        }
            
        result.put('xParcelName', parcelName);
        result.put('xParcelId', parcelId);
        
        return new Process.PluginResult(result);
    }

    global Process.PluginDescribeResult describe()
    {
        Process.PluginDescribeResult result = new Process.PluginDescribeResult();
        result.Name = 'LandUseFlowGetParcelPlugin';
        result.Tag = 'LandUseFlowGetParcelPlugin';
        
        result.inputParameters = new
        List<Process.PluginDescribeResult.InputParameter> {
            new Process.PluginDescribeResult.InputParameter('streetNameOrParcelNumber',
            Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter('streetNumber',
            Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter('streetName',
            Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter('parcelNumber',
            Process.PluginDescribeResult.ParameterType.STRING, true)
        };
        
        result.outputParameters =
        new List<Process.PluginDescribeResult.OutputParameter> {
            new Process.PluginDescribeResult.OutputParameter('xParcelSize',
            Process.PluginDescribeResult.ParameterType.INTEGER),
            new Process.PluginDescribeResult.OutputParameter('xParcelId',
            Process.PluginDescribeResult.ParameterType.STRING),
            new Process.PluginDescribeResult.OutputParameter('xParcelName',
            Process.PluginDescribeResult.ParameterType.STRING)
        };
        
        return result;
    }
    
    private static testMethod void testPlugin()
    {
        MUSW__Parcel__c p = new MUSW__Parcel__c(MUSW__Street_Number__c='106XXY', Name='MyNameIsParcelX');
        insert p;
        
        LandUseFlowGetParcelPlugin plugin = new LandUseFlowGetParcelPlugin();
        
        Map<String, Object> inputParams = new Map<String, Object>();
        inputParams.put('streetNameOrParcelNumber', p.Name);
        inputParams.put('streetNumber', p.MUSW__Street_Number__c);

        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result = plugin.invoke(request);
    }
    
    private static testMethod void testDescribe()
    {
        LandUseFlowGetParcelPlugin plugin = new LandUseFlowGetParcelPlugin();
        Process.PluginDescribeResult result = plugin.describe();
    }
}