public class UnisysTestData {
    void clearDataMap() {
        if (dataMap != null)
            dataMap.clear();
    }
    
    public string find(string aTagName)
    {
        return dataMap.get(aTagname);
    }
    
    map<string, string> loadMapFrom(string aString)
    {
        map<string, string> aMap = new map<string, string>();
        
        XmlStreamReader reader = new XmlStreamReader(aString);
        reader.setCoalescing(true);
        
        reader.nextTag();
        system.assertEquals('xml', reader.getLocalName(), 'test data should start inside <xml> tag.');
        
        while (reader.hasNext()) {
            reader.nextTag();
            
            string nodeName = reader.getLocalName();
            
            if (String.IsNotBlank(nodeName)) {
                for (; reader.getEventType() != XmlTag.END_ELEMENT; reader.next()) {
                    if (reader.getEventType() == XmlTag.CHARACTERS) {                                       
                        aMap.put(nodeName, reader.getText().trim());
                    }
                }
                reader.next();
            }
        }
        
        return aMap;
    }
    
    public void release()
    {
        clearDataMap();
        sobjectData = null;
    }
    
    public void refresh() { refresh(resourceName); }
    
    void refresh(string aResourceName)  
    {
        system.debug('refresh loading resource named ' + aResourceName);
        
        sobjectData = [ 
            select  id, name, body
              from  StaticResource
             where  name = :aResourceName limit 1 
        ];
        
        dataMap = loadMapFrom(sobjectData.body.toString());
    }
    
    public UnisysTestData(string aResourceName)
    {
        resourceName = aResourceName;
        refresh();
    }
    
    public map<string, string> dataMap;
    string resourceName;    
    StaticResource sobjectData; 
}