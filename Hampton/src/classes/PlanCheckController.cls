/* README
     by Mostafa Asadi-Moghadam
     
     1) SEARCH FOR ** CONFIGURE: AND FOLLOW INSTRUCTTIONS FOR EACH APPLICABLE CUSTOM FIELD

*/
public class PlanCheckController {
    
        // ======================= PRIVATE MEMBER VARIABLESz
        //
        //
        private MUSW__Plan_Check__c m_pc;
        private Boolean m_newMode;
        private String m_currentId; // Id of the current object
        private String m_parentId;  // Id of the parent object (the object we just came from)
        private String m_parentName;
        private String m_parentLabel;
        private List<String> m_checklistOptions = new List<String>{}; //** CONFIGURE: FOR EACH CHECKBOX COPY AND RENAME (THIS NAME WILL BE USED BELOW IN 'PUBLIC MEMBERS' SECTION)
        
        
        
        // ======================= PUBLIC METHODS
        //
        //
        ////public PlanCheckController(ApexPages.StandardController controller) {}
        public PlanCheckController() {
                // This represents the ID of the current Plan Check. If you're just creating a new one this will
                // be null. Used for determining if in Edit mode or New mode.
                m_currentId = ApexPages.currentPage().getParameters().get('id');
                
                m_parentId = System.currentPageReference().getParameters().get('retURL').replace('/','');
                m_parentName = MUSW.UtilityDb.getObjectNameFromId(new List<String>{'permit__c', 'parcel__c', 'planning_application__c', 'complaint__c', 'master_project__c', 'plan_check__c'}, m_parentId);
                m_parentLabel = MUSW.UtilityDb.getObjectLabelFromId(new List<String>{'permit__c', 'parcel__c', 'planning_application__c', 'complaint__c', 'master_project__c', 'plan_check__c'}, m_parentId);
                
                if (m_currentId == null)  // "New" mode
                {
                        m_newMode = true;
                        m_pc = new MUSW__Plan_Check__c(MUSW__Permit__c=getPermitId(), MUSW__Parcel__c=getParcelId());
                } 
                else  // "Edit" mode
                {
                        m_newMode = false;
                        String query = 'select ' + getPlanCheckFields() + ' from MUSW__Plan_Check__c where id =: m_currentId';
                        m_pc = Database.query(query);
                        
                        // Fill in default values for certain fields only in New mode.
                        //*** Fake Edit Mode refers to the process of redirecting from New to Edit in order for 
                        //    the formula fields to evaluate correctly)
                        if (isFakeEditMode()) 
                        {
                                //**  CONFIGURE: ENTER ANY DEFAULT FIELDS HERE
                                //m_pc.Lot_Coverage_Perc__c = m_pc.Lot_Coverage_Requirement__c;
                        }
                }
                
        }
        
        /* This gets called immediately after the default constructor (as defined in the VF page) */
        public pageReference Initialize() {
                // Create and insert the Plan Check so that the formula fields can be evaluated
                // CAUTION: The user will end up with a new Plan Check item even when they close their browser but
                //          we have decided to go with it since there was no clean way of getting the formulas to evaluate.
                // CAUTION: If user hits "cancel" a Plan Check ID will be wasted because the m_pc object is deleted.
                
                pageReference pr = null;
                if (m_newMode) 
                {
                    try
                    {
                        upsert m_pc;
                        pr = new pageReference('/' + m_pc.id + '/e?retURL=//' +  m_parentId + '&fakeEditMode=1');
                        pr.setredirect(true);
                    }
                    catch(DmlException ex)
                    {
                        ApexPages.addMessages(ex);
                    }
                }
                
                return pr;
        }
        
        public pageReference save() {
                //** CONFIGURE: ENTER A NEW ROW FOR EACH CHECKLIST THAT YOU HAVE
                convertCheckboxValuesToPicklistValues('Checklist__c', m_checklistOptions);
                
                try
                {
                    upsert m_pc; // save to db
                }
                catch(DmlException ex)
                {
                    ApexPages.addMessages(ex);
                }
                
                return getPageRedirect();
        }
        
        public pageReference cancel() {
                if (isFakeEditMode()) 
                {
                    try
                    {
                        delete m_pc; // delete from db
                    }
                    catch(DmlException ex)
                    {
                        ApexPages.addMessages(ex);
                    }
                }
                
                return getPageRedirect();
        }
                
                
        
        // ======================= PUBLIC MEMBERS
        //
        //
        //** CONFIGURE: FOR EVERY PICKLIST THAT NEEDS TO SHOW AS CHECKBOXES, 
        //              1) RENAME Items TO A UNIQUE NAME (THIS NAME WILL BE REFERENCED INSIDE VF PAGE)
        //              2) REPLACE 'Checklist__c' WITH FIELD NAME
        /*public List<SelectOption> Items {
            get {
                return convertPicklistToCheckboxes(MUSW__Plan_Check__c.Checklist__c.getDescribe());
            }
        }*/
        
        //** CONFIGURE: FOR EVERY PICKLIST THAT NEEDS TO SHOW AS CHECKBOXES, 
        //              1) RENAME ChecklistOptions TO A UNIQUE NAME (THIS NAME WILL BE REFERENCED INSIDE VF PAGE)
        //              2) REPLACE 'Checklist__c' WITH FIELD NAME
        //              3) YOU NEED TO CREATE A NEW GLOBAL VARIABLE (refer to instructions on top)
        /*public List<String> ChecklistOptions {
            get {
                    m_checklistOptions = convertPicklistValuesToCheckboxValues(m_pc.Checklist__c);
                    return m_checklistOptions;
                }
            set { m_checklistOptions = value; }
        }*/
        
        public MUSW__Plan_Check__c PlanCheck {
            get { return m_pc; }
        }
        
        public Boolean parcelExists {
            get { return (m_pc.MUSW__Parcel__c != null); }
        }
        
        public String parentLabel {
            get { return m_parentLabel; }
        }
        
        
        
        // ======================= PRIVATE METHODS (HELPERS)
        //
        //
        /* Redirect page to parent. This method is usually called by cancel and save. */
        private pageReference getPageRedirect() {
                pageReference pr = new pageReference('//' + m_parentId);
                pr.setredirect(true);
                return pr; 
        }
        
        private String getPlanCheckFields() {
            String result = '';
            
            Map<String, Schema.SObjectField> pcmap = Schema.SObjectType.MUSW__Plan_Check__c.fields.getMap();
            
            Integer i = 1;
            for (String s : pcmap.keySet())
            {
                result += s;
                if (i < pcmap.size())
                {
                     result += ', ';
                }
                i++;
            }
            
            return result;
        }
        
        /* Determines if the page was in New mode but was redirected to the Edit page to get the formulas to work 
           hence the name Fake Edit Mode. The logic is: if 'fakeEditMode' is set to 1 in url then true.
           */
        private Boolean isFakeEditMode() {
                return isInMode('fakeEditMode', 1);
        }
        
        private Boolean isInMode(String urlParam, Integer value) {
                Boolean fake = false;
                try 
                {
                    fake = Integer.ValueOf(ApexPages.currentPage().getParameters().get(urlParam)) == value;
                } 
                catch (System.Exception e) {}
                                
                return fake;
        }
        
        /* Gets the parcel id of the parcel that is associated to the parent. */
        private String getParcelId() {
                String result = null;
                
                if (m_parentName != null)
                {
                    if (m_parentName.toLowerCase() == 'musw__parcel__c')
                    {   
                        // the parent was a parcel
                        result = m_parentId;
                    }
                    else
                    {
                        // the parent was a permit
                        MUSW__Permit__c[] perm = [select MUSW__Parcel__c from MUSW__Permit__c where id =: m_parentId];
                        if (perm.size() > 0) 
                        {
                                result = perm[0].MUSW__Parcel__c;
                        }
                    }
                }                

                return result;                  
        }
        
        /*  pid: the ID of the parent which is obtained using getParentId() */
        private String getPermitId() {
                String result = null;
                
                // Only fill in the permit id when coming from the permit page (i.e. parent is permit).
                // This if-statement determines if the parent was a permit
                if (m_parentName != null)
                {
                    if (m_parentName.toLowerCase() == 'musw__permit__c')
                    {
                        result = m_parentId;
                    }
                }

                return result;
        }
        
        private List<SelectOption> convertPicklistToCheckboxes(Schema.DescribeFieldResult picklistFieldResult) {
            List<SelectOption> options = new List<SelectOption>();
            List<Schema.PicklistEntry> ple = picklistFieldResult.getPicklistValues();
            
            for( Schema.PicklistEntry f : ple)
            {
                options.add(new SelectOption(f.getLabel(), f.getValue()));      
            }
            
            return options;
        }
        
        private void convertCheckboxValuesToPicklistValues(String fieldName, List<String> checklist) {
                // Convert checkboxes back to original Picklist type before saving
                String picklist = '';
                for (String s : checklist)
                {
                        picklist += s + ';'; 
                }
                
                m_pc.put(fieldName, picklist);
        }
        
        private List<String> convertPicklistValuesToCheckboxValues(String picklist) {
            List<String> checklist = new List<String>();
            
            if (picklist != null && picklist != '') {
                List<String> picklistSplit = picklist.split(';');
                for (String s : picklistSplit)
                {
                    checklist.add(s);
                }
            }
        
            return checklist;
        }
        // ======================= TESTS
        //
        //
        // Example url to Edit Plan Check page: 
        // https://musw.na4.visual.force.com/apex/PlanCheck?id=a0o6000000011kB&retURL=%2Fa0o6000000011kB&sfdc.override=1
        static testmethod void NewPlanCheck_CancelTest() {
                        
            MUSW__Parcel__c par = new MUSW__Parcel__c(Name='1234666999');
            insert par;
            MUSW__Permit__c perm = new MUSW__Permit__c(MUSW__Parcel__c=par.id);
            insert perm;
            
            
            // new plan check (no "id" parameter in the url means new plan check)
            pageReference p = Page.PlanCheck;
            p.getParameters().put('retURL', perm.id); // coming from permit page
            Test.setCurrentPage( p );
            
            PlanCheckController pcc = new PlanCheckController();
            pageReference pFakeEditMode = pcc.Initialize();
            
            // need to fake the returned pageReference to include "id"
            MUSW__Plan_Check__c[] pcr = [select id from MUSW__Plan_Check__c where MUSW__Parcel__c =: par.id]; 
            pFakeEditMode.getParameters().put('id', pcr[0].id);
            Test.setCurrentPage( pFakeEditMode );
            
            // call these guys again to simulate page redirecting to fakeEditMode
            pcc = new PlanCheckController();
            pcc.Initialize();
            System.assert(pcc.PlanCheck.MUSW__Height__c != null);
            System.assert(pcc.parcelExists == true); // call this to increase the coverage requirement by salesforce
            System.assert(pcc.parentLabel == 'Permit');
            
            // cancel (should delete)
            pcc.cancel();
            pcr = [select id from MUSW__Plan_Check__c where MUSW__Parcel__c =: par.id];
            System.assert(pcr.size() == 0);
            
            // dummy line to force the tests to pass
            ////PlanCheckController x = new PlanCheckController(new ApexPages.StandardController(new MUSW__Plan_Check__c()));
        }
                
                static testmethod void NewPlanCheck_SaveTest() {
                        
                        MUSW__Parcel__c par = new MUSW__Parcel__c(Name='1234666999');
                        insert par;
                        MUSW__Permit__c perm = new MUSW__Permit__c(MUSW__Parcel__c=par.id);
                        insert perm;
                        
                        
                        // new plan check (no "id" parameter in the url means new plan check)
                        pageReference p = Page.PlanCheck;
            p.getParameters().put('retURL', perm.id); // coming from permit page
            Test.setCurrentPage( p );
            
            PlanCheckController pcc = new PlanCheckController();
                        pageReference pFakeEditMode = pcc.Initialize();
                        
                        // need to fake the returned pageReference to include "id"
                        MUSW__Plan_Check__c[] pcr = [select id from MUSW__Plan_Check__c where MUSW__Parcel__c =: par.id]; 
                        pFakeEditMode.getParameters().put('id', pcr[0].id);
                        Test.setCurrentPage( pFakeEditMode );
                        
                        // call these guys again to simulate page redirecting to fakeEditMode
            pcc = new PlanCheckController();
            pcc.Initialize();
            
                        // save
                        pcc.save();
                        pcr = [select id from MUSW__Plan_Check__c where MUSW__Parcel__c =: par.id];
                        System.assert(pcr.size() == 1);
                }
                
                static testmethod void EditPlanCheck_SaveTest() {
                        
                        MUSW__Parcel__c par = new MUSW__Parcel__c(Name='1234666999');
                        insert par;
                        MUSW__Permit__c perm = new MUSW__Permit__c(MUSW__Parcel__c=par.id);
                        insert perm;
                        MUSW__Plan_Check__c pc = new MUSW__Plan_Check__c(MUSW__Parcel__c=par.id);
                        insert pc;
                        
                        
                        // edit plan check (need to pass "id" to url)
                        pageReference p = Page.PlanCheck;
                        p.getParameters().put('id', pc.id);
                        p.getParameters().put('retURL', perm.id); // coming from permit page
            
                        Test.setCurrentPage( p );
            
                        PlanCheckController pcc = new PlanCheckController();
                        pageReference pEditMode = pcc.Initialize();
                        System.assert(pEditMode == null);
                        
                        // change checkbox
                        pcc.PlanCheck.MUSW__Height__c = 14;
                        pcc.save();
                        
                        MUSW__Plan_Check__c[] pcr = [select id, MUSW__height__c from MUSW__Plan_Check__c where MUSW__Parcel__c =: par.id];
                        System.assert(pcr[0].MUSW__height__c == 14);
                }
}