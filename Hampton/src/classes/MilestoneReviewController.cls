public with sharing class MilestoneReviewController
{
    private MUSW__Milestone__c m_ms;
    private MUSW__Work_Item__c[] m_witems { get; set; }
    private Id m_pid;
    private Id m_capacityRT, m_commentRT;    
    public MUSW__Submission__c sub { get; set; }
    public MUSW__Work_Item__c[] filteredWorkItems { get; set; }
    public Task[] tasks { get; set; }
    public MUSW__Condition__c[] comments { get; set; }
    public MUSW__Condition__c[] otherComments { get; set; }
    public MUSW__Work_Item__c[] capacities { get; set; }
    public String wiGroupSelected { get; set; }
    public String depPicklistVals { get; set; }
    public LinkVO[] viewLinks { get; set; }
    public String docUrlToShow { get; set; }
    public Schema.FieldSetMember[] workItemFields
    {
        get
        {
            Map<String, Schema.FieldSet> fsMap = Schema.SObjectType.MUSW__Work_Item__c.fieldSets.getMap();
            Schema.FieldSet fs;
            for (Schema.FieldSet fs1 : fsMap.values()) if (fs1.getLabel() == wiGroupSelected) fs = fs1;
            if (fs == null) fs = fsMap.get('Review_Work_Items_List');
            
            workItemFields = fs.getFields();
            return workItemFields;
        }
        private set;
    }
    
    
    public pageReference redirectNoSub()
    {
        String msid = System.currentPageReference().getParameters().get('id');
        
        MUSW__Milestone__c ms2 = database.query('select Submission__c from MUSW__Milestone__c where Id = \'' + msid + '\'');
        
        if (ms2.Submission__c == null)
        {
            pageReference pr = new pageReference('/' + msid + '?nooverride=1');
            pr.setRedirect(true);
            return pr;
        }
        else return null;
    }
    
    public MilestoneReviewController(ApexPages.StandardController con)
    {
        String mName;
        m_ms = (MUSW__Milestone__c)con.getRecord();
        
        // get Submission fields
        List<Schema.FieldSetMember> fssFields = Schema.SObjectType.MUSW__Submission__c.fieldSets.Submission_Review_Overview.getFields();
        String sFields = 'Submission__r.Id, Submission__r.View_Links__c';
        for(Schema.FieldSetMember f : fssFields)
        {
            if (!sFields.toLowerCase().contains(f.getFieldPath().toLowerCase()))
                sFields += ', Submission__r.' + f.getFieldPath();
        }
        
        MUSW__Milestone__c ms2 = database.query('select MUSW__Permit2__c, Application2__c, ' + sFields + ' from MUSW__Milestone__c where Id = \'' + m_ms.Id + '\'');
        m_pid = (ms2.MUSW__Permit2__c != null) ? ms2.MUSW__Permit2__c : ms2.Application2__c;
        
        // came from somewhere other than Permit/Application. Redirect to default view by redirectNoSub
        if (m_pid == null) return;
        
        sub = ms2.Submission__r;
        
        // get view links
        viewLinks = new LinkVO[]{};
        if (sub != null && sub.View_Links__c != null)
        {
            for (String l : sub.View_Links__c.split(', '))
            {
                String url = l.substringAfter('"').substringBefore('"').replace('&amp;', '&');
                String lbl = l.replace('</a>', '').substringAfterLast('>');
                if (!String.isBlank(url)) viewLinks.add(new LinkVO(url, lbl));
                
                if (sub.View_Links__c.split(', ').size() == 1) docUrlToShow = url;
            }
        }
        
        RecordType[] rt = [select Id, Name from RecordType where (Name = 'Capacity' and SobjectType = 'MUSW__Work_Item__c') or ((Name = 'Comment' and SobjectType = 'MUSW__Condition__c')) order by Name];
        m_capacityRT = rt[0].Id;
        m_commentRT = rt[1].Id;
        
        //added the field set for condition__c 
        List<Schema.FieldSetMember> commentsFields = Schema.SObjectType.MUSW__Condition__c.fieldSets.New_Edit_Comments.getFields();
        String commFields = 'Id, MUSW__Status__c, MUSW__Permit2__c, Milestone__c, Milestone__r.Name, recordTypeId ';
        for (Schema.FieldSetMember fs : commentsFields)
        {
            if (!commFields .toLowerCase().contains(fs.getFieldPath().toLowerCase()))
                commFields += ', ' + fs.getFieldPath();
        }
        
        comments = database.query('select ' + commFields + ' from MUSW__Condition__c where recordTypeId = :m_commentRT and Milestone__c =  \'' + m_ms.Id+ '\'');
        
        // get the milestones and comments for in same permit with same milestone name
        mName = m_ms.Name;
        if (mName.lastIndexOf('-') > 0)
        {
            if (mName.substringAfterLast('-').indexof('/') > 0)
            {
                mName = mName.substringBeforeLast('-');
            }
        }
        
        MUSW__Milestone__c[] otherMilestones = database.query('select Id, Name,(select ' + commFields +' from Conditions__r where RecordTypeId = :m_commentRT and MUSW__Status__c = \'Open\') from MUSW__Milestone__c where Id != \'' + m_ms.Id+ '\' and Name like \'' + mName + '%\' and (MUSW__Permit2__c = \'' + m_pid + '\' or Application2__c = \'' + m_pid + '\')');
        otherComments = new MUSW__Condition__c[]{};
        for (MUSW__Milestone__c otherms : otherMilestones)
        {
            otherComments.addAll(otherms.Conditions__r);
        }
        
        // get Task fields
        List<Schema.FieldSetMember> fstFields = Schema.SObjectType.Task.fieldSets.MUSW__New_Edit_Tasks.getFields();
        String tFields = 'Id';
        for(Schema.FieldSetMember f : fstFields)
        {
            if (!tFields.toLowerCase().contains(f.getFieldPath().toLowerCase()))
                tFields += ', ' + f.getFieldPath();
        }
        
        tasks = database.query('select ' + tFields + ' from Task where whatId = \'' + m_ms.Id + '\'');
        
        if (ms2.MUSW__Permit2__c != null)
        {
            // get Capacitiy fields
            List<Schema.FieldSetMember> capacitiesFields = Schema.SObjectType.MUSW__Work_Item__c.fieldSets.New_Edit_Capacities.getFields();
            String capFields = 'Id, Name, MUSW__Quantity__c, MUSW__Type__c';
            for (Schema.FieldSetMember cs : capacitiesFields )
            {
                if (!capFields.toLowerCase().contains(cs.getFieldPath().toLowerCase()))
                    capFields += ', ' + cs.getFieldPath();
            }
            
            capacities = database.query('select '+ capFields +' from MUSW__Work_Item__c where MUSW__Permit2__c =  \'' + ms2.MUSW__Permit2__c + '\' and RecordType.Name = \'Capacity\'');
            
            // get Work Item fields
            List<Schema.FieldSetMember> fsFields = Schema.SObjectType.MUSW__Work_Item__c.fieldSets.Review_Work_Items_List.getFields();
            String wiFields = 'Id';
            for(Schema.FieldSetMember f : fsFields)
            {
                if (!wiFields.toLowerCase().contains(f.getFieldPath().toLowerCase()))
                    wiFields += ', ' + f.getFieldPath();
            }
            
            m_witems = database.query('select ' + wiFields + ' from MUSW__Work_Item__c where MUSW__Permit2__c = \'' + m_pid + '\' and RecordType.Name != \'Capacity\' order by MUSW__Type__c');
            
            filteredWorkItems = new MUSW__Work_Item__c[]{};
            wiGroupSelected = 'all';
            filterWorkItems();
        }
    }
    
    public pageReference save()
    {
        update sub;
        update m_ms;
        
        for (Integer i=tasks.size()-1; i>=0; i--)
        {
            if (tasks[i].Subject == null) tasks.remove(i);
        }
        upsert tasks;
        
        for (Integer i=comments.size()-1; i>=0; i--)
        {
            if (comments[i].MUSW__Full_Description__c == null) comments.remove(i);
        }
        upsert comments;
        
        if (m_witems != null)
        {
            for (Integer i=m_witems.size()-1; i>=0; i--)
            {
                if ((m_witems[i].MUSW__Quantity__c == null || m_witems[i].MUSW__Quantity__c == 0) &&
                	(m_witems[i].MUSW__Quantity2__c == null || m_witems[i].MUSW__Quantity2__c == 0))
                	m_witems.remove(i);
            }
            upsert m_witems;
            
            for (Integer i=capacities.size()-1; i>=0; i--)
            {
                if (capacities[i].MUSW__Quantity2__c == null) capacities.remove(i);
            }
            upsert capacities;
        }
        
        return cancel();
    }
    
    public pageReference cancel()
    {
        pageReference pr = new pageReference('/' + m_pid);
        pr.setRedirect(true);
        return pr;
    }
    
    public void filterWorkItems()
    {
        filteredWorkItems.clear();
        
        String[] types = (wiGroupSelected == 'all') ? wiTypes : depPicklistVals.split(',');
        
        // get the selected group recordtypeId
        RecordType[] rtGroup = [select Id,Name from RecordType where SobjectType = 'MUSW__Work_Item__c' and Name = :wiGroupSelected order by Name];
        
        String[] notFound = new String[]{};
        for (String typ : types)
        {
            Boolean found = false;
            for (MUSW__Work_Item__c wi : m_witems)
            {
                if (wi.MUSW__Type__c == typ)
                {                    
                    // if there is recordTypeId for selected group,then assign the recordType to workItem to override recordTypeId
                    if (rtGroup.size() > 0) wi.recordTypeId = rtGroup[0].Id;
                    filteredWorkItems.add(wi);
                    found = true;
                    break;
                }
            }
            
            if (!found) notFound.add(typ);
        } 
        
        for (String typ : notFound)
        {
            MUSW__Work_Item__c wi = new MUSW__Work_Item__c(MUSW__Permit2__c=m_pid, Group__c=wiGroupSelected, MUSW__Type__c=typ, MUSW__Quantity2__c=0, MUSW__Quantity__c=0, MUSW__Unit__c=null);
          
            // if there is recordTypeId for selected group,then initialize the recordType to workItem
            if (rtGroup.size() > 0) wi.recordTypeId = rtGroup[0].Id;
                       
            m_witems.add(wi);
            filteredWorkItems.add(wi);
        }
    }
    
    public void addCapacity()
    {
        capacities.add(new MUSW__Work_Item__c(MUSW__Permit2__c=m_pid, recordTypeId=m_capacityRT));
    }
    
    public void addTask()
    {
        tasks.add(new Task(whatId=m_ms.Id));
    }
    
    public void addComment()
    {
        comments.add(new MUSW__Condition__c(Milestone__c=m_ms.Id, recordTypeId=m_commentRT));
    }
    
    public SelectOption[] wiGroups
    {
        get
        {
            if (wiGroups == null)
            {
                wiGroups = new SelectOption[]{};
                wiGroups.add(new Selectoption('all', 'All'));
                Schema.PicklistEntry[] pls = MUSW__Work_Item__c.Group__c.getDescribe().getPicklistValues();
                for (Schema.PicklistEntry e : pls)
                {
                    wiGroups.add(new Selectoption(e.getValue(), e.getLabel()));
                }
            }
            return wiGroups;
        }
        set;
    }
    
    private String[] wiTypes
    {
        get
        {
            if (wiTypes == null)
            {
                wiTypes = new String[]{};
                Schema.PicklistEntry[] pls = MUSW__Work_Item__c.MUSW__Type__c.getDescribe().getPicklistValues();
                for (Schema.PicklistEntry e : pls)
                {
                    wiTypes.add(e.getLabel());
                }
            }
            return wiTypes;
        }
        set;
    }
    
    public class LinkVO
    {
        public String url { get; set; }
        public String label { get; set; }
        
        public LinkVO(String u, String l)
        {
            url = u;
            label = l;
        }
    }
    
    @isTest(seeAllData=true)
    private static void testController()
    {
        BGBK.RulesEngineState.setLock();
        
        MUSW__Parcel__c par = new MUSW__Parcel__c(Name='xyz123abc');
        insert par;
        MUSW__Permit2__c perm = new MUSW__Permit2__c(MUSW__Type__c='Building', MUSW__Parcel__c=par.id);
        insert perm;
        MUSW__Submission__c s = new MUSW__Submission__c(MUSW__Permit2__c=perm.Id, Name='Test Plan');
        insert s;
        MUSW__Milestone__c m = new MUSW__Milestone__c(Name='Plan Review - Demolition', Submission__c=s.Id, MUSW__Permit2__c=perm.Id, MUSW__Due_Date__c=system.today());
        insert m;
        BGBK.RulesEngineState.releaseLock();
        
        pageReference p = Page.SubmissionCreate;
        p.getParameters().put('id', m.Id);
        Test.setCurrentPage(p);
        
        MilestoneReviewController c = new MilestoneReviewController(new ApexPages.StandardController(m));    
        SelectOption[] grps = c.wiGroups;
        c.filterWorkItems();
        Schema.FieldSetMember[] fsm = c.workItemFields;        
        pageReference rNoSub = c.redirectNoSub();
        c.addCapacity();
        c.addTask();
        c.addComment();
        c.save();
    }
}