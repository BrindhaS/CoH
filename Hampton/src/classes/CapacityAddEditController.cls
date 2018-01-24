public with sharing class CapacityAddEditController
{
    public Integer recordCount { get; private set; }
    public Integer addRowCount { get; set; }
    public String parentName { get; private set; }
    public Capacity__c ch { get; set; }
    public Capacity__c[] c { get; set; }
    private String parentId { get; set; }
    private integer initialnumberOfRows = 5;
    
    
    public CapacityAddEditController()
    {
        addRowCount = 1;
        parentId = System.currentPageReference().getParameters().get('pid');
        
        MUSW__Permit2__c p = database.query('select id, Name, (select ' + MUSW.UtilityDb.getFieldsFor_Str('Capacity__c', false) + ' from Capacities__r) from MUSW__Permit2__c where id = :parentId');
        parentName = p.Name;
        
        c = p.Capacities__r;
        ch = new Capacity__c(Permit2__c=parentId);
                        
        recordCount = c.size();
        
        //default row values (if overriding client defaults)
        if (recordCount == 0)
        {
            addRowCount = initialnumberOfRows;
            addRow();
            addRowCount = 1;
        }
    }
    
    public pageReference save()
    {
        try
        {
            Capacity__c[] c2add = new Capacity__c[]{};
            for (Capacity__c tmp : c)
            {
                if (tmp.Name != null) c2add.add(tmp);
            }
            
            upsert c2add;
        }
        catch(Exception e)
        {
            ApexPages.addMessages(e);
            return null;
        }
    
        return cancel();
    }
    
    public pageReference cancel()
    {
        pageReference pr = new pageReference('/'+ parentId);
        pr.setredirect(true);
        return pr;  
    }
    
    public void fillDown ()
    {
        String[] fields = MUSW.UtilityDb.getFieldsFor('Capacity__c', false);
        for(String ff : fields)
        {
            if ((ch.get(ff)!= null) && (ff != 'Id') && (ff !='Permit2__c'))
            {
                for(Capacity__c ci : c) if (ci.id == null) ci.put(ff, ch.get(ff));
            }
        }
    }
    
    public void addRow()
    {
        for (Integer x = 0; x < addRowCount; x++)
        {
             Capacity__c cnew = new Capacity__c(Permit2__c=parentId);
             c.add(cnew);
        }
    }
    
    public void hideRow()
    {
        if (c.size() > 0 ) c.remove(c.size()-1);
    }
}