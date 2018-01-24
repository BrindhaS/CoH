public with sharing class SubmissionAddController
{
    private MUSW__Submission__c m_sub;
    public String selectedType { get; set; }
    
    
    public SubmissionAddController(ApexPages.StandardController con)
    {
        m_sub = (MUSW__Submission__c)con.getRecord();
        m_sub.MUSW__Requested_DateTime__c = system.now();
        m_sub.MUSW__Required__c = true;
        selectedType = '';
    }
    
    public pageReference save()
    {
        if (selectedType != '')
        {
            for (SelectOption op : types)
            {
                if (op.getValue() == selectedType) { m_sub.Name = op.getLabel(); break; }
            }
            m_sub.MUSW__Link__c = selectedType;
        }
        insert m_sub;
        
        return cancel();
    }
    
    public pageReference cancel()
    {
        String retUrl = System.currentPageReference().getParameters().get('retURL');
        pageReference pr = new pageReference(retUrl);
        pr.setRedirect(true);
        return pr;
    }
    
    public SelectOption[] types
    {
        get
        {
            Folder f = [select Id from Folder where Name = 'Submission Forms' limit 1];
            Document[] docs = [select Id, Name from Document where FolderId = :f.Id order by Name];
            
            types = new SelectOption[]{new SelectOption('', 'Other')};
            for (Document doc : docs)
            {
                String url = 'https://c.na9.content.force.com/servlet/servlet.FileDownload?file=' + doc.Id;
                types.add(new SelectOption(Url, doc.Name));
            }
            return types;
        }
        set;
    }
    
    @isTest(SeeAllData=true)
    private static void testCon()
    {
        BGBK.RulesEngineState.setLock();
        
        MUSW__Parcel__c par = new MUSW__Parcel__c(Name='xyz123abc');
        insert par;
        MUSW__Permit2__c perm = new MUSW__Permit2__c(MUSW__Type__c='Building', MUSW__Parcel__c=par.id);
        insert perm;
        MUSW__Submission__c s = new MUSW__Submission__c(MUSW__Permit2__c=perm.Id, Name='Building Plan');
        BGBK.RulesEngineState.releaseLock();
        
        BGBK.RulesEngineState.releaseLock();
        pageReference p = Page.SubmissionCreate;
        p.getParameters().put('retURL', 'home');
        Test.setCurrentPage(p);
        
        SubmissionAddController c = new SubmissionAddController(new ApexPages.StandardController(s));
        c.selectedType = c.types[1].getvalue();
        c.save();
    }
}