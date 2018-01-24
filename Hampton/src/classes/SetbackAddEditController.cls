public with sharing class SetbackAddEditController
{
    public Integer recordCount { get; private set; }
    public Integer addRowCount { get; set; }
    public String parentName { get; private set; }
    public Setback__c sh { get; set; }
    public Setback__c[] s { get; set; }
    private String parentId { get; set; }
    private integer initialnumberOfRows = 5;
    
    
    public SetbackAddEditController()
    {
        addRowCount = 1;
        parentId = System.currentPageReference().getParameters().get('pid');
        
        MUSW__Permit2__c p = database.query('select id, Name, (select ' + MUSW.UtilityDb.getFieldsFor_Str('Setback__c', false) + ' from Setbacks__r) from MUSW__Permit2__c where id = :parentId');
        parentName = p.Name;
        
        s = p.Setbacks__r;
        sh = new Setback__c(Permit2__c=parentId);
                        
        recordCount = s.size();
        
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
            Setback__c[] s2add = new Setback__c[]{};
            for (Setback__c tmp : s)
            {
                if (tmp.Type__c != null) s2add.add(tmp);
            }
            
            if (s2add.size() > 0) upsert s2add;
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
        String[] fields = MUSW.UtilityDb.getFieldsFor('Setback__c', false);
        for(String ff : fields)
        {
            if ((sh.get(ff)!= null) && (ff != 'Id') && (ff !='Permit2__c'))
            {
                for(Setback__c si : s) if (si.id == null) si.put(ff, sh.get(ff));
            }
        }
    }
    
    public void addRow()
    {
        for (Integer x = 0; x < addRowCount; x++)
        {
             Setback__c cnew = new Setback__c(Permit2__c=parentId);
             s.add(cnew);
        }
    }
    
    public void hideRow()
    {
        if (s.size() > 0 ) s.remove(s.size()-1);
    }
    
    private static testMethod void testAdd()
    {
        BGBK.RulesEngineState.setLock();
        
        MUSW__Permit2__c perm = new MUSW__Permit2__c(MUSW__Type__c='Building');
        insert perm;
        
        pageReference p = Page.CapacityAddEdit;
        p.getParameters().put('pid', perm.id );
        Test.setCurrentPage(p);
        
        SetbackAddEditController s = new SetbackAddEditController();
        s.fillDown();
        s.addRow();
        s.hideRow();
        s.save();
    }
}