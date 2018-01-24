public with sharing class InspectionMassRequestController
{
    public ParentVO[] pvos { get; set; }
    public MUSW__Permit_Contact__c lookupTemp { get; set; } // for search lookups on VF
    public String selections { get; set; }
    public String contactName { get; set; }
    public String contactNumber { get; set; }
    public String instructions { get; set; }
    
    public InspectionMassRequestController()
    {
        lookupTemp = new MUSW__Permit_Contact__c();
    }
    
    public void getPermits()
    {
        if (pvos == null) pvos = new ParentVO[]{};
        
        pvos.clear();
        
        Id cid = lookupTemp.MUSW__Contact__c;
        Id pid = lookupTemp.MUSW__Permit2__c;
        Id xid = lookupTemp.Parcel__c;
        if (cid == null && pid == null && xid == null) return;
        
        String whereClause = '';
        if (cid != null) whereClause = 'MUSW__Applicant__c = :cid';
        if (pid != null) whereClause += (whereClause == '') ? 'Id = :pid' : ' and Id = :pid';
        if (xid != null) whereClause += (whereClause == '') ? 'MUSW__Parcel__c = :xid' : ' and MUSW__Parcel__c = :xid';
        if (pid == null) whereClause += ' and MUSW__Status__c != \'Finaled\'';
        MUSW__Permit2__c[] ps = database.query('select Id, Name, MUSW__Street__c, MUSW__City__c, MUSW__Parcel__c, MUSW__Parcel__r.MUSW__Street2__c, MUSW__Parcel__r.MUSW__City__c, RecordType.Name, MUSW__Total_Balance__c, (select ' + MUSW.UtilityDb.getFieldsFor_Str('MUSW__Inspection__c', false) + ' from MUSW__Inspections__r where Requested_DateTime__c = null and IsClosed__c = \'No\') from MUSW__Permit2__c where ' + whereClause + ' and MUSW__Total_Balance__c <= 0');
        //MUSW__Permit2__c[] ps = database.query('select Id, Name, MUSW__Parcel__c, RecordType.Name, MUSW__Total_Balance__c, (select ' + MUSW.UtilityDb.getFieldsFor_Str('MUSW__Inspection__c', false) + ' from MUSW__Inspections__r where Requested_DateTime__c = null and IsClosed__c = \'No\') from MUSW__Permit2__c where ' + whereClause + ' and MUSW__Total_Balance__c <= 0');
        
        if (xid != null)
        {
        	MUSW__Parcel__c par = database.query('select Id, (select ' + MUSW.UtilityDb.getFieldsFor_Str('MUSW__Inspection__c', false) + ' from MUSW__Inspections__r where Requested_DateTime__c = null and IsClosed__c = \'No\') from MUSW__Parcel__c where Id = :xid');
        	
        	MUSW__Inspection__c newIns = new MUSW__Inspection__c(MUSW__Parcel__c=par.Id);
            ParentVO pvo = new ParentVO(par);
            pvo.ins.add(newIns);
            pvos.add(pvo);
        }
        
        for (MUSW__Permit2__c p : ps)
        {
            MUSW__Inspection__c newIns = new MUSW__Inspection__c(MUSW__Permit__c=p.Id, MUSW__Parcel__c=p.MUSW__Parcel__c);
            ParentVO pvo = new ParentVO(p);
            pvo.ins.add(newIns);
            pvos.add(pvo);
        }
        
        fillDown();
    }
    
    public pageReference save()
    {
    	if (String.isBlank(selections)) return null;
    	
    	Schema.FieldSet fs = Schema.SObjectType.MUSW__Inspection__c.fieldSets.Request_Details;
    	
        MUSW__Inspection__c[] ins2update = new MUSW__Inspection__c[]{};
        for (String s : selections.remove('rb').removeEnd(',').split(','))
        {
        	// format x_y
        	Integer pindex = Integer.valueOf(s.split('_')[0]);
        	Integer iindex = Integer.valueOf(s.split('_')[1]);
        	MUSW__Inspection__c ins = pvos[pindex].ins[iindex];
        	
        	// assert required fields
        	for (FieldSetMember fsm : fs.getFields())
        	{
        		if (fsm.getRequired() && ins.get(fsm.getFieldPath()) == null)
        		{
        			ins.addError('You must enter a value for ' + fsm.getLabel() + '.');
        			return null;
        		}
        	}
        	
    		ins.Requested_DateTime__c = system.now();
        	ins2update.add(ins);
        	system.debug('****UPDATE: ' + ins.Name);
        }
        
        try
        {
        	HamptonTriggerService.setLock();
            upsert ins2update;
            HamptonTriggerService.releaseLock();
        }
        catch (Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
            return null;
        }
        return cancel();
    }
    
    public pageReference cancel()
    {
        pageReference pr = new pageReference('/home/home.jsp');
        pr.setredirect(true);
        return pr;  
    }
    
    public void fillDown()
    {
        if (contactName != null || contactNumber != null || instructions != null)
        {
            for (ParentVO pvo : pvos)
            {
                for (MUSW__Inspection__c i : pvo.ins)
                {
                    i.Contact_Name__c = contactName;
                    i.Contact_Number__c = contactNumber;
                    i.Instructions__c = instructions;
                }
            }
        }
    }
    
    public class ParentVO
    {
        public MUSW__Permit2__c p { get; set; }
        public MUSW__Parcel__c par { get; set; }
        public MUSW__Inspection__c[] ins { get; set; }
        public String address { get; set; }
        
        public ParentVO(MUSW__Permit2__c p)
        {
            this.p = p;
            this.ins = p.MUSW__Inspections__r;
            this.address = (p.MUSW__Street__c != null) ? p.MUSW__Street__c + (p.MUSW__City__c != null ? ', ' + p.MUSW__City__c : '') : (p.MUSW__Parcel__r.MUSW__Street2__c != null ? p.MUSW__Parcel__r.MUSW__Street2__c + (p.MUSW__Parcel__r.MUSW__City__c != null ? ', ' + p.MUSW__Parcel__r.MUSW__City__c : '') : null);
        }
        
        public ParentVO(MUSW__Parcel__c par)
        {
            this.par = par;
            this.ins = par.MUSW__Inspections__r;
        }
    }
    
    @isTest(SeeAllData=true)
    private static void testCon_withParent()
    {
        MUSW__Parcel__c par = new MUSW__Parcel__c(Name='zsdfsf');
        insert par;
        MUSW__Permit2__c p = new MUSW__Permit2__c(MUSW__Parcel__c=par.Id);
        insert p;
        MUSW__Inspection__c i = new MUSW__Inspection__c(MUSW__Permit__c=p.Id, MUSW__Parcel__c=p.MUSW__Parcel__c);
        insert i;
        
        InspectionMassRequestController c = new InspectionMassRequestController();
        c.lookupTemp.MUSW__Permit2__c = p.Id;
        c.getPermits();
        c.instructions = 'abc';
        c.selections = '0_0';
        c.fillDown();
        c.save();
    }
}