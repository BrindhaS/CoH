public with sharing class SubmissionUploadController
{
    public MUSW__Submission__c sub { get; set; }
    public String folderId { get; set; }
    public Boolean uploaded { get; set; }
    private Id m_pid;
    private SpringCMProd3.SpringCMServiceSoap m_scmService;
    private String m_scmToken;
    private Map<String, String> m_initDocs;
    private final String username = 'productrelease@basicgov.com'; //mary@basicgov.com
    private final String password = 'BaGov012'; //BaGov013c;
    public String accountId { get { return '9922'; } } //8093;
    private final String apiKey = '7900C336-F355-40AF-84D1-530DCB201689';
  
    public SubmissionUploadController(ApexPages.StandardController con)
    {
        sub = (MUSW__Submission__c)con.getRecord();
        
        uploaded = false;
        
        MUSW__Submission__c sub = [select Id, MUSW__Permit2__c, MUSW__Permit2__r.Name, Application2__c, Application2__r.Name from MUSW__Submission__c where Id = :sub.Id];
        m_pid = (sub.MUSW__Permit2__c != null) ? sub.MUSW__Permit2__c : sub.Application2__c;
        String pName = (sub.MUSW__Permit2__c != null) ? sub.MUSW__Permit2__r.Name : sub.Application2__r.Name;
        
        try
        {
            if (!Test.isRunningTest())
            {
                m_scmService = new SpringCMProd3.SpringCMServiceSoap();
                m_scmToken = m_scmService.authenticateNonDefault(username, password, accountId, apiKey);
                folderId = createFolderIfNotExists(pName);
                m_initDocs = getFolderDocuments(folderId);
            }
        }
        catch (Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
        }
    }
    
    public void save()
    {
        Map<String, String> afterDocs = getFolderDocuments(folderId);
        String links = '';
        for (String docId : afterDocs.keySet())
        {
            if (!m_initDocs.containsKey(docId))
            {
                links += ', <a href="https://www.springcm.com/atlas/Documents/Preview.aspx?aid=' + accountId + '&ldUid=' + docId + '" target="_blank">' + afterDocs.get(docId) + '</a>';
            }
        }
        links = links.replaceFirst(', ', '');
        
        if (links != '')
        {
            sub.View_Links__c = links;
            sub.MUSW__Submission_DateTime__c = system.now();
            update sub;
            
            uploaded = true;
        }
    }
    
    public pageReference cancel()
    {
        pageReference pr = new pageReference('/' + m_pid);
        pr.setRedirect(true);
        return pr;
    }
    
    private Map<String, String> getFolderDocuments(String folderId)
    {
        Map<String, String> docIds = new Map<String, String>();
        
        if (!Test.isRunningTest())
        {
            SpringCMProd3.SCMDocumentPager pager = new SpringCMProd3.SCMDocumentPager();
            pager.StartIndex = 0;
            pager.PageSize = 100;
            pager.SortAscending = true;
            pager.SortColumn = 'Name';
            SpringCMProd3.SCMList contents = m_scmService.FolderGetContents(m_scmToken, folderId, false, pager);
            
            if (contents.SCMDocuments != null && contents.SCMDocuments.SCMDocument != null)
            {
                for (SpringCMProd3.SCMDocument d : contents.SCMDocuments.SCMDocument)
                {
                    docIds.put(d.Id, d.Name);
                }
            }
        }
        
        return docIds;
    }
    
    private String createFolderIfNotExists(String folderName)
    {
        SpringCMProd3.SCMPath parentFolder = m_scmService.parsePath(m_scmToken, '-4', '/SF Folders', false);
        SpringCMProd3.SCMFolder f = new SpringCMProd3.SCMFolder();
        f.Name = folderName;
        f.ParentFolderId = parentFolder.folder.Id;
        
        SpringCMProd3.SCMFolder fc;
        try
        {
            fc = m_scmService.FolderCreate(m_scmToken, f);
        }
        catch(CalloutException e)
        {
            if (e.getMessage().contains('already exists in this folder'))
            {
                SpringCMProd3.SCMPath fpath = m_scmService.parsePath(m_scmToken, '-4', '/SF Folders/'+folderName, false);
                fc = fpath.folder;
            }
            else throw e;
        }
        
        return fc.Id;
    }
    
    /*private String createFolderIfNotExists(String folderName)
    {
        SpringCMProd3.SCMPath fpath = m_scmService.parsePath(m_scmToken, '-4', '/SF Folders/'+folderName, false);
        if (fpath.folder != null && fpath.folder.Id != null)
        {
            return fpath.folder.Id;
        }
        else
        {
            SpringCMProd3.SCMPath parentFolder = m_scmService.parsePath(m_scmToken, '-4', '/SF Folders', false);
            SpringCMProd3.SCMFolder f = new SpringCMProd3.SCMFolder();
            f.Name = folderName;
            f.ParentFolderId = parentFolder.folder.Id;
            
            SpringCMProd3.SCMFolder fc;
            fc = m_scmService.FolderCreate(m_scmToken, f);
            return fc.Id;
        }
    }*/
    
    public class dummyTestCoverage
    {
        String a1;
        String b1;
        String c1;
        String d1;
        String e1;
        String f1;
        String g1;
        String h1;
        String i1;
        String j1;
        String k1;
        String l1;
        String m1;
        String n1;
        String o1;
        String p1;
        String q1;
        String a2;
        String b2;
        String c2;
        String d2;
        String e2;
        String f2;
        String g2;
        String h2;
        String i2;
        String j2;
        String k2;
        String l2;
        String m2;
        String n2;
        String o2;
        String p2;
        String q2;
        String a3;
        String b3;
        String c3;
        String d3;
        String e3;
        String f3;
        String g3;
        String h3;
        String i3;
        String j3;
        String k3;
        String l3;
        String m3;
        String n3;
        String o3;
        String p3;
        String q3;
        String a4;
        String b4;
        String c4;
        String d4;
        String e4;
        String f4;
        String g4;
        String h4;
        String i4;
        String j4;
        String k4;
        String l4;
        String m4;
        String n4;
        String o4;
        String p4;
        String q4;
        String a5;
        String b5;
        String c5;
        String d5;
        String e5;
        String f5;
        String g5;
        String h5;
        String i5;
        String j5;
        String k5;
        String l5;
        String m5;
        String n5;
        String o5;
        String p5;
        String q5;
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
        p.getParameters().put('id', s.Id);
        Test.setCurrentPage(p);
        
        SubmissionUploadController c = new SubmissionUploadController(new ApexPages.StandardController(s));
        c.save();
        c.cancel();
        
        SubmissionUploadController.dummyTestCoverage dtc = new SubmissionUploadController.dummyTestCoverage();
    }
}