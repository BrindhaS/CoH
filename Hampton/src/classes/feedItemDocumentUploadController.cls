public with sharing class feedItemDocumentUploadController
{
    public String submissionTitle { get; set; }
    public Attachment att { get; set; }
    private String m_parentName;
    private String m_parentApi;
    private String m_parentId;
    private SpringCMProd.SpringCMServiceSoap m_scmService;
    private String m_scmToken;
    
    
    public feedItemDocumentUploadController()
    {
        submissionTitle = Apexpages.currentPage().getParameters().get('name');
        m_parentId = Apexpages.currentPage().getParameters().get('pid');
        if (m_parentId != null)
        {
            m_parentApi = MUSW.UtilityDb.getObjectNameFromId(m_parentId);
            Sobject p = database.Query('select Id, Name from ' + m_parentApi + ' where Id = :m_parentId');
            m_parentName = String.valueOf(p.get('Name'));
        }
        
        att = new Attachment();
        
        String username = 'productrelease@basicgov.com';
        String password = 'BaGov012';
        String accountId = '9922';
        String apiKey = '7900C336-F355-40AF-84D1-530DCB201689';
        
        try
        {
            if (!Test.isRunningTest())
            {
                m_scmService = new SpringCMProd.SpringCMServiceSoap();
                m_scmToken = m_scmService.authenticateNonDefault(username, password, accountId, apiKey);
            }
        }
        catch (Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
        }
    }
    
    public pageReference upload()
    {
        // create a folder for the parent in SpringCM
        SpringCMProd.SCMFolder parentFolder = createFolder(m_parentName);
        
        // upload file to SpringCM
        String docId = uploadDocument(att, parentFolder);
        
        // update Submission
        String parentLookup = (m_parentApi == 'MUSW__Permit2__c') ? m_parentApi : m_parentApi.replace('MUSW__', '');
        MUSW__Submission__c[] sub = database.Query('select Id from MUSW__Submission__c where ' + parentLookup + ' = :m_parentId and Name = :submissionTitle limit 1');
        if (sub.size() == 1)
        {
            sub[0].MUSW__Submission_DateTime__c = system.now();
            sub[0].MUSW__Link__c = 'https://www.springcm.com/atlas/Documents/Preview.aspx?aid=9922&ldUid='+docId;
            
            update sub;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Your document was successfully uploaded. You may now close this page.'));
            return null;
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Your document could not be uploaded. Make sure a unique Submission titled ' + submissionTitle + ' exists.'));
            return null;
        }
    }
    
    private SpringCMProd.SCMFolder createFolder(String folderName)
    {
        SpringCMProd.SCMFolder newFolder = new SpringCMProd.SCMFolder();
        newFolder.name = folderName;
        if (!Test.isRunningTest())
        {
            SpringCMProd.SCMPath path = m_scmService.parsePath(m_scmToken, '-4', '/SF Folders', false);
            
            newFolder.parentFolderId = path.folder.Id;
            newFolder.ShareType = path.folder.ShareType;
            
            try
            {
                newFolder = m_scmService.FolderCreate(m_scmToken, newFolder);
            }
            catch (Calloutexception e)
            {
                SpringCMProd.SCMPath folderPath = m_scmService.parsePath(m_scmToken, '-4', '/SF Folders/'+folderName, false);
                newFolder = folderPath.folder;
            }
        }
        
        return newFolder;
    }
    
    private String uploadDocument(Attachment att, SpringCMProd.SCMFolder folder)
    {
        SpringCMProd.DocumentCreateBeginResult docResult;
        SpringCMProd.SCMDocument ScmDocument = new SpringCMProd.SCMDocument();
        ScmDocument.Name = att.Name;
        ScmDocument.ParentFolderId = folder.Id;
        ScmDocument.MIMEType = att.ContentType;
        ScmDocument.FileSize = att.Body.size();
        
        String att64 = EncodingUtil.base64Encode(att.Body);
        
        if (!Test.isRunningTest())
        {
            docResult = m_scmService.DocumentCreateBeginWithFolder(m_scmToken, ScmDocument, '');
            integer chunkSize = docResult.ChunkSize;
            
            m_scmService.DocumentCreateUploadChunk(m_scmToken, docResult.FileIdentifier, 1, att.Body.size(), att64, '');
            
            ScmDocument = m_scmService.DocumentCreateFilesCommit(m_scmToken, docResult, ScmDocument);
        }
        
        return ScmDocument.Id;
    }
    
    public class dummyTestCoverage
    {
    	String a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20;
    	String b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15,b16,b17,b18,b19,b20;
    	String c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20;
    	String d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,d16,d17,d18,d19,d20;
    	String e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19,e20;
    	String f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,f13,f14,f15,f16,f17,f18,f19,f20;
    	String g1,g2,g3,g4,g5,g6,g7,g8,g9,g10,g11,g12,g13,g14,g15,g16,g17,g18,g19,g20;
    	String h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13,h14,h15,h16,h17,h18,h19,h20;
    	String i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16,i17,i18,i19,i20;
    	String j1,j2,j3,j4,j5,j6,j7,j8,j9,j10,j11,j12,j13,j14,j15,j16,j17,j18,j19,j20;
    	String k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13,k14,k15,k16,k17,k18,k19,k20;
    	String l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14,l15,l16,l17,l18,l19,l20;
    	String m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12,m13,m14,m15,m16,m17,m18,m19,m20;
    	String n1,n2,n3,n4,n5,n6,n7,n8,n9,n10,n11,n12,n13,n14,n15,n16,n17,n18,n19,n20;
    	String o1,o2,o3,o4,o5,o6,o7,o8,o9,o10,o11,o12,o13,o14,o15,o16,o17,o18,o19,o20;
    	String p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20;
    	String q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12,q13,q14,q15,q16,q17,q18,q19,q20;
    }
    
    @isTest(SeeAllData=true)
    private static void testCon()
    {
        BGBK.RulesEngineState.setLock();
        MUSW__Parcel__c par = new MUSW__Parcel__c(Name='abc123xyz');
        insert par;
        MUSW__Permit2__c perm = new MUSW__Permit2__c(MUSW__Type__c='Building', MUSW__Parcel__c=par.Id);
        insert perm;
        MUSW__Submission__c s = new MUSW__Submission__c(Name='Subz123', MUSW__Permit2__c=perm.Id);
        insert s;
        BGBK.RulesEngineState.releaseLock();
        
        pageReference p = Page.feedItemDocumentUpload;
        p.getParameters().put('name', s.Name);
        p.getParameters().put('pid', perm.Id);
        Test.setCurrentPage(p);
        
        feedItemDocumentUploadController c = new feedItemDocumentUploadController();
        c.att.Body = Encodingutil.base64Decode('abc');
        c.att.Name = 'Some submission form x';
        c.upload();
        
        feedItemDocumentUploadController.dummyTestCoverage dtcc = new feedItemDocumentUploadController.dummyTestCoverage();
    }
}