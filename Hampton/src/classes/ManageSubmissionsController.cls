public with sharing class ManageSubmissionsController
{
    public String parentName { get; set; }
    public String parentLabel { get; set; }
    public MUSW__Submission__c[] subs { get; set; }
    private String pid;
    
    public ManageSubmissionsController()
    {
        pid = System.currentPageReference().getParameters().get('pid');
        
        List<Schema.FieldSetMember> fsFields = Schema.SObjectType.MUSW__Submission__c.fieldSets.Manage_Submissions_List.getFields();
        String subFields = 'Id';
        for(Schema.FieldSetMember f : fsFields)
        {
            if (!subFields.toLowerCase().contains(f.getFieldPath().toLowerCase()))
                subFields += ', ' + f.getFieldPath();
        }
        if (!subFields.contains('Action_Link__c')) subFields += ', Action_Link__c';
        if (!subFields.contains('View_Links__c')) subFields += ', View_Links__c';
        
        Schema.Describesobjectresult ds = ((Id)pid).getSObjectType().getDescribe();
        String pObj = ds.getName();
        parentLabel = ds.getLabel();
        String subsRelName = (pObj == 'MUSW__Permit2__c') ? 'MUSW__Submissions__r' : 'Submissions__r';
        Sobject p = database.query('select Name, (select ' + subFields + ' from ' + subsRelName + ') from ' + pObj + ' where Id = :pid');
        parentName = String.valueOf(p.get('Name'));
        subs = (List<MUSW__Submission__c>)p.getSobjects(subsRelName);
    }
    
    public pageReference save()
    {
        // need to update one by one for DRE to work
        for (MUSW__Submission__c s : subs) update s;
        return cancel();
    }
    
    public pageReference cancel()
    {
        pageReference pr = new pageReference('/' + pid);
        pr.setRedirect(true);
        return pr;
    }
    
    @isTest(seeAllData=true)
    private static void testController()
    {
        BGBK.RulesEngineState.setLock();
        
        MUSW__Parcel__c par = new MUSW__Parcel__c(Name='abcxfsafaf');
        insert par;
        MUSW__Permit2__c perm = new MUSW__Permit2__c(MUSW__Type__c='Building', MUSW__Parcel__c=par.Id);
        insert perm;
        MUSW__Submission__c s = new MUSW__Submission__c(MUSW__Permit2__c=perm.Id,Name='Building Plan');
        insert s;
        BGBK.RulesEngineState.releaseLock();
        
        pageReference p = Page.SubmissionCreate;
        p.getParameters().put('pid', perm.Id);
        Test.setCurrentPage(p);
        
        ManageSubmissionsController c = new ManageSubmissionsController();
        c.save();
    }
}