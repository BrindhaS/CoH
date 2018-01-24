global with sharing class GISViewerController
{
    public String queryName {get; set;}
    public String searchText {get; set;}
    public String loadJsonObjs {get; set;}
    public String loadObjectName {get; set;}
    public String loadRelatedObjectName {get; set;}
    public String loadObjectType {get; set;}
    public String loadPrimaryParcel {get; set;}
    public String requestUrl {get; set;}
    public String parentId {get; set;}
    public String parcelNumber {get; set;}
    public String parcelRelatedObjectApiName {get; set;}
    public String searchIsRelated {get; set;}
    public String searchObjectName {get; set;}
    public String attachObjectType {get; set;}
    public String attacheeJson {get; set;}
    public String attacheeName {get; set;}
    public String parentNumber {get; set;}
    public String parentName {get; set;}
    public String objX {get; set;}
    public String objY {get; set;}
    public String proxQueryName {get; set;}
    public String proxObjectApiName {get; set;}
    public String proxDistance {get; set;}
    
    public String queryReturnVal {get; private set;}
    public String findReturnVal {get; private set;}
    public String loadReturnVal {get; private set;}
    public String proxyResponseVal {get; private set;}
    public String relatedParcelsReturnVal {get; private set;}
    public String parcelRelatedObjectsReturnVal {get; private set;}
    public String attachReturnVal {get; private set;}
    public String proximityReturnVal {get; private set;}
    public String parcelNameReturnVal {get; private set;}
    public String viewableObjectsReturnVal {get; private set;}
    public String createableObjectsReturnVal {get; private set;}
    public String tokenReturnVal {get; private set;}
    
    private MUSW.GISConnector m_gisc;
    
    public GISViewerController()
    {
		String browserType = Apexpages.currentPage().getHeaders().get('USER-AGENT'); 
		if(browserType != null && browserType.contains('MSIE'))
		{
		    Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=EmulateIE7');
		}
    	
        m_gisc = new MUSW.GISConnector();
        queryReturnVal = '';
        findReturnVal = '';
        loadReturnVal = '';
        proxyResponseVal = '';
        relatedParcelsReturnVal = '';
        parcelRelatedObjectsReturnVal = '';
        attachReturnVal = '';
        proximityReturnVal = '';
        parcelNameReturnVal = '';
    }
    
    public void query()
    {
        String res = m_gisc.query(queryName);
        res = String.escapeSingleQuotes(res);
        queryReturnVal = res;
    }
    
    public void find()
    {
        if (searchText == '')
        {
                findReturnVal = '';
                return;
        }
        else if (searchText.contains(','))
        {
                searchText = searchText.replaceAll(' ', '');
                if (searchText.endsWith(',')) searchText = searchText.substring(0, searchText.length() - 1);
                searchText = '("' + searchText + '")';
                searchText = searchText.replaceAll(',', '" OR "');
        }
        
        findReturnVal = m_gisc.find(searchText);
        findReturnVal = String.escapeSingleQuotes(findReturnVal);
    }
    
    public void loadAndAttach()
    {
        loadReturnVal = m_gisc.loadAndAttach(loadJsonObjs, loadObjectName, loadObjectType);
    }
    
    public void attachToExistingObject()
    {
        try
        {
            m_gisc.loadAndAttach(attacheeJson, attacheeName, parentNumber, parentName, attachObjectType);
            attachReturnVal = '';
        }
        catch (MUSW.BGException e)
        {
            attachReturnVal = e.getMessage();
        }
    }
    
    public void getParcelName() 
    {
        parcelNameReturnVal = m_gisc.getParcelName(parcelNumber);
        system.debug('***Parcel Name for ' + parcelNumber + ' is ' + parcelNameReturnVal);
    }       
    
    public void loadRelatedParcels()
    {
        relatedParcelsReturnVal = m_gisc.getRelatedParcels(parentId);
    }
    
    public void searchProximity()
    {
        proximityReturnVal = m_gisc.getSobjectsInExtent(Decimal.valueOf(objX), Decimal.valueOf(objY), Decimal.valueOf(proxDistance), proxQueryName);
    }
    
    public void loadParcelRelatedObjects()
    {
        try
        {
                parcelRelatedObjectsReturnVal = m_gisc.getParcelRelatedSobjects(parcelNumber);
        }
        catch (System.Exception e) {}
    }
    
    public void getUserPermittedObjects()
    {
        Map<String, String> permMap = m_gisc.getUserPermittedObjects();
        viewableObjectsReturnVal = permMap.get('View');
        createableObjectsReturnVal = permMap.get('Create');
    }
    
    public void getToken()
    {
        tokenReturnVal = m_gisc.getToken();
        system.debug('**** Token returned: ' + tokenReturnVal);
    }
    
    public void proxyRequest()
    {
        system.debug('**** URL: ' + requestUrl);
        String res = MUSW.UtilityConnection.sendProxyRequest(requestUrl);
        system.debug('**** Proxy response: ' + res);
        //res = res.substring(43000, 44000);
        //system.debug('**** WITH N:' + res);
        //res = res.replaceAll('\n', '!!');
        //system.debug('**** WITHOUT N:' + res);
        proxyResponseVal = res;
    }
    
    static testMethod void testClass()
    {
        delete [select id from MUSW__Automation_Rule__c];
        delete [select id from MUSW__Automation_Filter__c];
        delete [select id from MUSW__Automation_Result__c];
        
        // set up test data: query, parcel
        MUSW__Query__c q = new MUSW__Query__c(Name='TestQuery', MUSW__Object_Name__c='MUSW__Permit__c', MUSW__WHERE_Filter__c='MUSW__Permit_Type__c = \'testType123x\'', MUSW__Fields__c='MUSW__Tracking_Number__c, MUSW__Permit_Type__c, MUSW__Current_Status__c, MUSW__Latitude__c, MUSW__Longitude__c, Name');
        insert q;
        
        MUSW__Parcel__c par = new MUSW__Parcel__c(Name='888777', MUSW__Parcel_Number2__c = '888777');
        insert par;
        
        MUSW__Permit__c p = new MUSW__Permit__c(MUSW__Permit_Type__c='testType123x');
        insert p;
        
        MUSW__Permit_Parcel__c pp = new MUSW__Permit_Parcel__c(MUSW__Permit__c=p.Id, MUSW__Parcel__c=par.id);
        insert pp;
        
        MUSW.GISConnector.resetFlag();
        
        GISViewerController con = new GISViewerController();
        con.queryName = 'TestQuery';
        con.query();
        
        con.searchText = '123, 456';
        con.find();
        
        con.objX = '12.12';
        con.objY = '22.22';
        con.proxDistance = '1';
        con.proxQueryName = 'TestQuery';
        con.searchProximity();
        
        con.parcelNumber = '888777';
        con.loadParcelRelatedObjects();
        
        con.requestUrl = 'http://testme'; // kinda useless test!
        con.proxyRequest();
        
        con.parentId = p.Id;
        con.loadRelatedParcels();
        
        //try { con.loadAndAttach(); } catch(System.Exception e) {}
        //try { con.attachToExistingObject(); } catch(System.Exception e) {}
                
            con.getUserPermittedObjects();
            system.assert(con.viewableObjectsReturnVal != '');
            system.assert(con.createableObjectsReturnVal != '');
    }
}