public with sharing class LocationVerifyController{
    public Case cas{get;set;}
    private Id m_caseId;
    public List<Address> addresses{get;set;}
    public List<Address> places{get;set;}
    public List<Intersection> intersections{get;set;}
    public String selectionIndex{get;set;}
    public String selectedTab{ get; set; }
    public String placeName{ get; set; }
    public String totalStreet{ get; set; }
    public String totalIntersection { get; set; }
    public String totalPlace { get; set; }
    public boolean isMissingGISAddress{ get; set; }
    
    
    private final String DISPOSITION = 'Pending GIS Validation';
    private String m_tempStreet1;
    private String m_tempStreet2;
    
    public LocationVerifyController(ApexPages.StandardController controller) {
        isMissingGISAddress = false;    
        m_caseId = ApexPages.currentPage().getParameters().get('id');
        if(m_caseId != null){
            cas = [Select id, Disposition__c, CaseNumber,Street_Number__c,Street_Name__c,City__c,State__c,Zip__c,Place__c,Intersection_Street_1__c,Intersection_Street_2__c, Missing_GIS_Address__c  from Case where id=:m_caseId];
            addresses = new List<Address>();
            intersections = new List<Intersection>();
            isMissingGISAddress = (cas.Missing_GIS_Address__c == null)?false:cas.Missing_GIS_Address__c;
            places = new List<Address>();
            m_tempStreet1 = (cas.Intersection_Street_1__c == null)?null:cas.Intersection_Street_1__c;
            m_tempStreet2 = (cas.Intersection_Street_2__c == null)?null:cas.Intersection_Street_2__c;
            
            //the following section is used to check which tab will be focused on after the page is reloaded.
            //if the intersection is not null, when the page is reloaded, it will go to Intersection tab. By default, it's Street tab.           
            if(cas.Intersection_Street_1__c != null ){
                searchIntersection();
            }else if(cas.Place__c != null){
                searchPlace();
                addresses.clear();
            }else if(cas.Street_Number__c != null && cas.Street_Name__c != null && cas.Place__c == null){
                searchStreet();
            }else{
                selectedTab = 'street';//locate street tab by default.
            }       
        }    
    }
    /** 
    *   This is used to search address if Street tab is selected
    */    
    public void searchStreet(){
        String criteria;
        selectedTab = 'street';
        if(addresses != null )addresses.clear();
        String streetNumber = (cas.Street_Number__c == null)?null:cas.Street_Number__c.trim(); 
        String street = (cas.Street_Name__c == null )?null:cas.Street_Name__c.trim();         
        
        if((streetNumber == null && street == null)|| (streetNumber.length() == 0 && street.length() == 0)){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter a street number or a street name or both.');
            ApexPages.addMessage(myMsg);         
            return ;
        }else if(street == null || street.length() == 0){
            criteria = EncodingUtil.urlEncode('ADDRESS like\'%' + streetNumber + '%\'','UTF-8');
        }else {
            criteria = EncodingUtil.urlEncode('ADDRESS like \'%' + streetNumber +  '%\'' + ' AND FullAdd like \'%' + street + '%\'','UTF-8');
        }
        addresses = getGISAddress(criteria);
       
        if(addresses == null || addresses.size() < 1){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No matched streets found.');
            ApexPages.addMessage(myMsg);               
        }else{
            totalStreet = 'Total: ' + addresses.size() + ' Records';
        }
                     
    }
    /** 
    *   This is used to search address and place name if Place tab is selected
    */    
    public void searchPlace(){
        String criteria;
        selectedTab = 'place';
        places.clear();

        if(cas.Place__c != null && cas.Place__c.length() > 0){
            criteria = EncodingUtil.urlEncode('PlaceName like \'%' + cas.Place__c.trim() + '%\'','UTF-8');
            places = getGISAddress(criteria);
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter a place name.');
            ApexPages.addMessage(myMsg);         
            return ;           
        }
       // places.addAll(addresses);
       // totalPlace = 'Total: ' + places.size() + ' Records';

        cas.Street_Number__c = '';
        cas.Street_Name__c = '';
        if(places == null || places.size() < 1){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No matched streets found.');
            ApexPages.addMessage(myMsg);               
        }else{
            totalPlace = 'Total: ' + places.size() + ' Records';
        }      

    }
    /** 
    *   This is used to search intersection streets if intersection tab is selected
    */    
    public void searchIntersection(){
        String criteria;    
        selectedTab = 'intersection';
        intersections.clear();

        String street1 = (cas.Intersection_Street_1__c == null)?null:cas.Intersection_Street_1__c.trim();
        String street2 = (cas.Intersection_Street_2__c == null)?null:cas.Intersection_Street_2__c.trim();
        if(street1 == null || street1.length() == 0)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter street 1.');
            ApexPages.addMessage(myMsg);         
            return ;
        }
        else
        {
            criteria = EncodingUtil.urlEncode('Name like \'%' + street1 + '%\'','UTF-8');
            if (street2 != null) criteria += EncodingUtil.urlEncode(' and Name like \'%' + street2 + '%\'','UTF-8');
            getGISAddress(criteria);
            if(intersections == null || intersections.size() < 1)
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No matched streets found.');
                ApexPages.addMessage(myMsg);               
            }                
        }
    }

    /** 
    *   When a user clicks on Cancel button, redirect to Case Detail page
    */    
    public pageReference redirect(){
        PageReference pr= new PageReference('/' + cas.id + '?nooverride=true');
        pr.setRedirect(true);
        return pr;
    }
    /** 
    *   Check if case disposition is not set to "Pending GIS Validation", redirect to Case Detail page
    *   Otherwise go to current page. 
    */     
    public pageReference checkAndRedirect(){
        if(cas.Disposition__c == null){
            return redirect();
        }else if(!cas.Disposition__c.equalsIgnoreCase(DISPOSITION)){
            return redirect();
        }else{
            return null;
        }   
    }
    /** 
    *   Save the street/place/intersection to case and set disposition to null.
    */  
    public pageReference save(){
        system.debug('****selectionIndex: '+selectionIndex);
        
        if(isMissingGISAddress){
            cas.Missing_GIS_Address__c = true;
            cas.Intersection_Street_1__c = m_tempStreet1;
            cas.Intersection_Street_2__c = m_tempStreet2;
        }else if(selectionIndex == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Please select an address.');
            ApexPages.addMessage(myMsg);  
            return null;           
        }
        else 
        {
            if(selectedTab == 'place'){
                saveStreetPlace(places,selectionIndex);
            }else if(selectedTab == 'street'){
                saveStreetPlace(addresses,selectionIndex);
            }else if(selectedTab == 'intersection'){
                for(Integer i = 0; i<intersections.size(); i++ ){
                    if(i== Integer.valueOf(selectionIndex)){
                        cas.Intersection_Street_1__c = intersections.get(i).street1;
                        cas.Intersection_Street_2__c = '';//cas.Intersection_Street_2__c;//intersections.get(i).street2;                            
//                        cas.Street_From__c = intersections.get(i).streetFrom;
//                        cas.Street_To__c = intersections.get(i).streetTo;
                        
                        cas.Address_X__c = Decimal.valueOf(intersections.get(i).longitude);
                        cas.Address_Y__c = Decimal.valueOf(intersections.get(i).latitude); 
                        cas.Street_Number__c = null;
                        cas.Street_Name__c = null;
                        cas.City__c = null;
                        cas.State__c = null;
                        cas.Zip__c = null; 
                        cas.Place__c = null;                         
                        cas.Location_Format__c = 'Intersection';
                        break;
                    }
                }            
            }
            cas.Missing_GIS_Address__c = false;
        }
        try{
            cas.Disposition__c = null;
            update cas; 
            PageReference pr= new PageReference('/' + cas.id + '?nooverride=true');
            pr.setRedirect(true);
            return pr;                                     
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);  
            return null;          
        }
    }
           
    /** 
    * Save address/place to this case object.
    * @param selectionIndex: String   
    * @param addressList: List<Address>
    */    
    private void saveStreetPlace(List<Address> addressList, String selectionIndex){
        for(Integer i = 0; i<addressList.size(); i++ ){
            if(i== Integer.valueOf(selectionIndex)){
                cas.Street_Number__c = addressList.get(i).streetNumber;
                cas.Street_Name__c = addressList.get(i).street;
                cas.GIS_Street__c = cas.Street_Name__c.trim(); 
                String addType = addressList.get(i).addType.equalsIgnoreCase('null')?'null':addressList.get(i).addType;
                String subAdd = addressList.get(i).subAdd.equalsIgnoreCase('null')?'null':addressList.get(i).subAdd;
                if(addType == 'null' && subAdd == 'null'){
                    cas.GIS_Apartment__c = '';
                }else{
                    cas.GIS_Apartment__c = (addType + ' ' + subAdd).trim(); 
                    cas.GIS_Street__c = cas.GIS_Street__c.replace(cas.GIS_Apartment__c, '');                    
                }
                
                cas.City__c = addressList.get(i).city;
                cas.State__c = addressList.get(i).state;
                cas.Zip__c = addressList.get(i).zip; 
                cas.Address_X__c = Decimal.valueOf(addressList.get(i).longitude);
                cas.Address_Y__c = Decimal.valueOf(addressList.get(i).latitude);
                cas.Place__c = (addressList.get(i).placeName)== 'Null'?null:addressList.get(i).placeName;
                if(cas.Place__c == null){
                    cas.Location_Format__c = 'Street Address';                       
                }else{
                    cas.Location_Format__c = 'Place';                       
                }
                cas.Intersection_Street_1__c = null;
                cas.Intersection_Street_2__c = null;                            
                break;
            }                  
        }
    }      

    /** 
    * Call GIS RESTful webservices to get the address.
    * @param criteria: String   search criteria
    */     
    private List<Address> getGISAddress(String criteria){
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        req.setMethod('GET');
        String endpoint = null;
        if(selectedTab == 'intersection'){
            endpoint = 'http://webgis.hampton.gov/ArcGIS/rest/services/AddressesAndCntrline4/MapServer/1/query?text=&geometry=&geometryType=esriGeometryPoint&inSR=4326&spatialRel=esriSpatialRelIntersects&relationParam=&objectIds=&where=' + criteria + '&time=&returnCountOnly=false&returnIdsOnly=false&returnGeometry=true&maxAllowableOffset=&outSR=&outFields=name%2C+lat%2C+long%2CShape&f=pjson';                                                         
        }else{
//            endpoint ='http://webgis.hampton.gov/ArcGIS/rest/services/AddressesAndCntrline4/MapServer/0/query?text=&geometry=&geometryType=esriGeometryPoint&inSR=&spatialRel=esriSpatialRelIntersects&relationParam=&objectIds=&where=' + criteria + '&time=&returnCountOnly=false&returnIdsOnly=false&returnGeometry=true&maxAllowableOffset=&outSR=&outFields=ADDRESS_NUMERIC%2C++ADDRESS_ALPHA%2CName%2C+TYPE_ABBR%2C+Fulladd%2C+CITY%2C+STATE%2C+ZIP%2CPlaceName%2CPOINT_X%2CPOINT_Y&f=pjson';                                             
            endpoint ='http://webgis.hampton.gov/ArcGIS/rest/services/AddressesAndCntrline4/MapServer/0/query?text=&geometry=&geometryType=esriGeometryPoint&inSR=&spatialRel=esriSpatialRelIntersects&relationParam=&objectIds=&where=' + criteria + '&time=&returnCountOnly=false&returnIdsOnly=false&returnGeometry=true&maxAllowableOffset=&outSR=&outFields=ADDRESS_NUMERIC%2C++ADDRESS_ALPHA%2CName%2C+TYPE_ABBR+%2C+Fulladd%2C+DIRECTION+%2C+ADD_TYPE+%2CSUB_ADD%2C++CITY%2C+STATE%2C+ZIP%2CPlaceName%2CPOINT_X%2CPOINT_Y&f&f=pjson';                                             
        }
        req.setEndpoint(endpoint);
        try{
            //create the response object
            HTTPResponse resp = http.send(req);
            JSONParser parser = JSON.createParser(resp.getBody());
            System.debug('body=' + resp.getBody());
            if(addresses != null)addresses.clear();
            if(intersections != null)intersections.clear();

            if(selectedTab == 'intersection'){// query by intersection
                parseIntersections(parser);
                return null;
            }else{//query by street or place
                return parseStreetPlace(parser);
            }        
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);             
            return null;
        }
    }  
    /** 
    * get the address and place name.
    * @param parser: JSONParser
    */ 

    private List<Address> parseStreetPlace(JSONParser parser){
       Address gisAddress;
        List<Address> addressList = new List<Address>();
        while(parser.nextToken() != null){
            if((parser.getCurrentToken() == JSONToken.FIELD_NAME)&&(parser.getText()=='attributes')){
                gisAddress = new Address();
                while(parser.nextToken()!= null && parser.getText()!= 'geometry'){
//                while(parser.nextToken()!= null){ 
                    if((parser.getCurrentToken()== JSONToken.FIELD_NAME)&&(parser.getText()=='ADDRESS_NUMERIC')){
                        parser.nextToken();
                        gisAddress.streetNumber = formatAddress(parser.getText());
                    }else if((parser.getCurrentToken()==JSONToken.FIELD_NAME)&&(parser.getText()=='ADDRESS_ALPHA')){
                        parser.nextToken();
                        gisAddress.streetAlpha = formatAddress(parser.getText());//parser.getText().equalsIgnoreCase('null')?'':parser.getText();      
                    }else if((parser.getCurrentToken()==JSONToken.FIELD_NAME)&&(parser.getText()=='NAME')){
                        parser.nextToken();
                        gisAddress.street = formatAddress(parser.getText());//parser.getText().equalsIgnoreCase('null')?'':parser.getText();      
                    }else if((parser.getCurrentToken()==JSONToken.FIELD_NAME)&&(parser.getText()=='TYPE_ABBR')){
                        parser.nextToken();
                        gisAddress.streetTypeAbbr = formatAddress(parser.getText());//parser.getText().equalsIgnoreCase('null')?'':parser.getText();
                    }else if((parser.getCurrentToken()==JSONToken.FIELD_NAME)&&(parser.getText()=='DIRECTION')){
                        parser.nextToken();
                        gisAddress.direction = formatAddress(parser.getText());//parser.getText().equalsIgnoreCase('null')?'':parser.getText();
                    }else if((parser.getCurrentToken()==JSONToken.FIELD_NAME)&&(parser.getText()=='ADD_TYPE')){
                        parser.nextToken();
                        gisAddress.addType = formatAddress(parser.getText());//parser.getText().equalsIgnoreCase('null')?'':parser.getText();
                    }else if((parser.getCurrentToken()==JSONToken.FIELD_NAME)&&(parser.getText()=='SUB_ADD')){
                        parser.nextToken();
                        gisAddress.subAdd = formatAddress(parser.getText());//parser.getText().equalsIgnoreCase('null')?'':parser.getText();
                    }else if((parser.getCurrentToken()==JSONToken.FIELD_NAME)&&(parser.getText()=='CITY')){
                        parser.nextToken();
                        gisAddress.city = formatAddress(parser.getText());//parser.getText();  
                    }else if((parser.getCurrentToken()==JSONToken.FIELD_NAME)&&(parser.getText()=='STATE')){
                        parser.nextToken();
                        gisAddress.state = formatAddress(parser.getText());//parser.getText().equalsIgnoreCase('null')?'':parser.getText();
                    }else if((parser.getCurrentToken()==JSONToken.FIELD_NAME)&&(parser.getText()=='ZIP')){
                        parser.nextToken();
                        gisAddress.zip = formatAddress(parser.getText());//parser.getText().equalsIgnoreCase('null')?'':parser.getText();
                    }else if((parser.getCurrentToken()==JSONToken.FIELD_NAME)&&(parser.getText()=='POINT_X')){
                   // }else if((parser.getCurrentToken()==JSONToken.FIELD_NAME)&&(parser.getText()=='x')){
                        parser.nextToken();
                        gisAddress.longitude = formatAddress(parser.getText());//parser.getText().equalsIgnoreCase('null')?'':parser.getText();  
                    }else if(parser.getText()=='POINT_Y'){
//                    }else if(parser.getText()=='y'){
                        parser.nextToken();
                        gisAddress.latitude = formatAddress(parser.getText());//parser.getText().equalsIgnoreCase('null')?'':parser.getText();
                    }else if(parser.getText()=='PlaceName'){
                        parser.nextToken();
                        gisAddress.placeName = (selectedTab =='place')?parser.getText():null;  
                    }                                                                              
                }
                String apartment = null;
                if(gisAddress.addType.equalsIgnoreCase('null') && gisAddress.subAdd.equalsIgnoreCase('null')){
                    apartment = '';
                }else{
                    apartment = gisAddress.addType + ' ' + gisAddress.subAdd;
                }
                gisAddress.streetNumber += ' ' + gisAddress.streetAlpha.trim();   
                gisAddress.street =  gisAddress.direction.trim() + ' ' + gisAddress.street + ' ' + gisAddress.streetTypeAbbr + ' ' + apartment;
                addressList.add(gisAddress);
            }
        }
        return addressList;    

    }    
    /** 
    * get the Intersection: street 1 and street 2.
    * @param parser: JSONParser
    */      
    private void parseIntersections(JSONParser parser){
        Intersection intersec;
        while(parser.nextToken() != null){
            if((parser.getCurrentToken()==JSONToken.FIELD_NAME)&&(parser.getText()=='attributes')){
                intersec = new Intersection();
                while(parser.nextToken()!= null && parser.getText()!= 'geometry'){

                    if((parser.getCurrentToken()== JSONToken.FIELD_NAME)&&(parser.getText()=='NAME')){
                        parser.nextToken();
                        intersec.street1 = parser.getText();  
                    }else if((parser.getCurrentToken()==JSONToken.FIELD_NAME)&&(parser.getText()=='LAT')){

                        parser.nextToken();
                        intersec.latitude = parser.getText(); 
                    }else if((parser.getCurrentToken()==JSONToken.FIELD_NAME)&&(parser.getText()=='LONG')){

                        parser.nextToken();
                        intersec.longitude = parser.getText();
                    }  
                }
                intersections.add(intersec);
            }
        }
        totalIntersection = 'Total: ' + intersections.size() + ' Records';
    }
        
    private String formatAddress(String str){
        str = str.trim();
        Set<String> s = new Set<String>();
        s.add('null');
        s.add('<null>');
         
        if(s.contains(str.toLowerCase())){
            return '';
        }
        return str;
    
    }
    /** 
    *   Inner Class
    */  
    public class Address{
        public String latitude{get;set;}
        public String longitude{get;set;}    
        public String streetNumber{get;set;}
        public String streetAlpha{get;set;}
        public String street{get;set;}
        public String streetTypeAbbr{get;set;}
        public String direction{get;set;}
        public String addType{get;set;}
        public String subAdd{get;set;}
        public String city{get;set;}
        public String state{get;set;}
        public String zip{get;set;}
        public String placeName{get;set;}
    
    }
    /** 
    *   Inner Class
    */ 
    public class Intersection{
        public String street1{get;set;}
        public String street2{get;set;}
        public String streetFrom{get;set;}
        public String streetTo{get;set;}
        public String latitude{get;set;}
        public String longitude{get;set;}
    }
}