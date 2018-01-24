global with sharing class HamptonTriggerService
{
    private static Boolean locked = false;
    private static Integer counter = 0;
    
    public static void setLock()
    {
        BGBK.RulesEngineState.setLock();
        counter++;
        locked = true;
    }
    
    public static void releaseLock()
    {
        counter--;
        if (counter == 0)
        {
            BGBK.RulesEngineState.releaseLock();
            locked = false;
        }
    }
    
    public static Boolean isLocked()
    {
        return locked;
    }
    
    public static Boolean isRulesEngineActive()
    {
        Boolean active = false;
        Map<String, BGBK__GlobalSettings__c> gsMap = BGBK__GlobalSettings__c.getAll();
        if (gsMap.containsKey('Default'))
        {
            BGBK__GlobalSettings__c gs = BGBK__GlobalSettings__c.getValues('Default');
            active = Boolean.valueOf(gs.BGBK__rulesEngineActive__c);
        }
        
        return active;
    }
    
    @future
    public static void updateSubmissionTotals(Id[] subIds)
    {
        if (subIds.size() > 0)
        {
            MUSW__Submission__c[] subs = [select Id, Total_Approved_Reviews__c, Total_Failed_Reviews__c, Total_Reviews__c, (select Id, Status2__c from Milestones__r) from MUSW__Submission__c where Id in :subIds];
            
            for (MUSW__Submission__c s : subs)
            {
                Integer countTotal = 0, countFailed = 0, countApproved = 0;
                for (MUSW__Milestone__c m : s.Milestones__r)
                {
                    countTotal++;
                    if (m.Status2__c == 'Approved') countApproved++;
                    else if (m.Status2__c == 'Failed') countFailed++;
                }
                
                s.Total_Reviews__c = countTotal;
                s.Total_Approved_Reviews__c = countApproved;
                s.Total_Failed_Reviews__c = countFailed;
            }
            
            //HamptonTriggerService.setLock();
            update subs;
            //HamptonTriggerService.releaseLock();
        }
    }
    
    WebService static void voidReceipt(Id rId)
    {
        MUSW__Receipt__c r = [select Id, MUSW__Amount_Tendered__c, MUSW__Paid_By__c, MUSW__Payment_Gateway_Transaction_Number__c, (select Id from MUSW__Fees__r), (select Id from BGBK__Payments__r) from MUSW__Receipt__c where Id = :rId];
        
        try
        {
            if (!Test.isRunningTest()) 
            {
                if (r.MUSW__Payment_Gateway_Transaction_Number__c != null && r.MUSW__Paid_By__c != null)
                {
                    IPaymentGateway gateway = new PaymentGateway();
                    gateway.void(r.MUSW__Paid_By__c, r.MUSW__Payment_Gateway_Transaction_Number__c, r.MUSW__Amount_Tendered__c);
                }
            }
            
            delete r.MUSW__Fees__r;
            delete r.BGBK__Payments__r;
            
            r = [select Id, MUSW__Amount_Tendered__c from MUSW__Receipt__c where Id = :rId];
            r.MUSW__Amount_Rejected__c = r.MUSW__Amount_Tendered__c;
            update r;
        }
        catch (System.Dmlexception e)
        {
            String err = 'FIELD_CUSTOM_VALIDATION_EXCEPTION, ';
            String msg;
            if (e.getMessage().contains(err))
            {
                msg = e.getMessage().substring(e.getMessage().indexOf(err) + err.length(), e.getMessage().indexOf(': []'));
            }
            else msg = e.getMessage();
            
            throw new MUSW.BGException(msg, true);
        }
    }
    
    /*
     *  Groups IV's by whatever criteria if Inspection.Days_to_next is blank
     */
    public static Map<String, Inspection_Violation__c[]> groupIVs(Inspection_Violation__c[] ivs)
    {
        Map<String, Inspection_Violation__c[]> ivGrouped = new Map<String, Inspection_Violation__c[]>(); // <days_to_correct, IVs>
        String key;
        for (Inspection_Violation__c iv : ivs)
        {
            // true if Inspection already there (for reinspections)
            if (iv.Days_to_correct__c != null) key = iv.Days_to_correct__c.toPlainString();
            else key = iv.Violation__r.Days_to_correct__c.toPlainString();
            
            if (ivGrouped.containsKey(key)) ivGrouped.get(key).add(iv);
            else ivGrouped.put(key, new Inspection_Violation__c[]{iv});
        }
        
        return ivGrouped;
    }
    
    public static MUSW__Inspection__c createReinspectionFromIV(MUSW__Inspection__c initInsp, MUSW__Violation__c v, Inspection_Violation__c iv)
    {
        MUSW__Inspection__c ins = initInsp.clone(false, true);
                    
        ins.Name = null;
        ins.MUSW__Type__c = (v.MUSW__Status__c == 'Contractor Completed') ? 'Re-inspection Contractor Completion' : 'Re-inspection';
        ins.MUSW__Status__c = 'Pending';
        ins.Close_Inspection__c = false;
        ins.MUSW__On_Itinerary__c = false;
        ins.Letter_Generated__c = false;
        ins.MUSW__Scheduled_Start_Date__c = null;
        ins.Requested_DateTime__c = null;
        ins.Completed_DateTime__c = null;
        ins.MUSW__Completed_Date__c = null;
        ins.MUSW__Closed_DateTime__c = null;
        ins.Due_DateTime__c = 
            (iv.Due_DateTime__c != null) 
            ? DateTime.newInstanceGmt(iv.Due_DateTime__c.year(), iv.Due_DateTime__c.month(), iv.Due_DateTime__c.day(), iv.Due_DateTime__c.hour(), iv.Due_DateTime__c.minute(), iv.Due_DateTime__c.second())
            : null;
        ins.MUSW__Previous_Inspection__c = initInsp.Id;
        ins.RecordTypeId = initInsp.RecordTypeId;
        
        if (ins.Group__c == 'Fire') ins.OwnerId = UserInfo.getUserId();
        
        // prior inspection may be on parent but IV may be unrelated (i.e. no parents)
        ins.MUSW__Permit__c = v.Permit2__c;
        ins.Complaint2__c = v.MUSW__Complaint2__c;
        
        return ins;
    }
    
    private static testmethod void testSubTotals()
    {
        MUSW__Parcel__c par = new MUSW__Parcel__c(Name='zsdfsf');
        insert par;
        MUSW__Permit2__c p = new MUSW__Permit2__c(MUSW__Type__c='Building', MUSW__Parcel__c=par.Id);
        insert p;
        MUSW__Submission__c s = new MUSW__Submission__c(MUSW__Permit2__c=p.Id);
        insert s;
        MUSW__Milestone__c m = new MUSW__Milestone__c(Submission__c=s.Id, MUSW__Due_Date__c=system.today());
        insert m;
    }
    
    private static testmethod void testFinalPerm()
    {
        MUSW__Parcel__c par = new MUSW__Parcel__c(Name='zsdfsf');
        insert par;
        MUSW__Permit2__c p = new MUSW__Permit2__c(MUSW__Type__c='Building', MUSW__Parcel__c=par.Id);
        insert p;
        
        MUSW__Permit2__c[] subs = [select id from MUSW__Permit2__c where Permit2__c = :p.Id];
        if (subs.size() > 0)
        {
            for (MUSW__Permit2__c pp : subs)
            {
                pp.MUSW__Status__c = 'Finaled';
            }
            update subs;
        }
        
        p.MUSW__Status__c = 'Finaled';
        update p;
    }
     private static testmethod void testReceiptVoid()
    {
        Account a = new Account (Name='lastname');
        insert a;
        MUSW__Receipt__c r= new MUSW__Receipt__c( MUSW__Amount_Tendered__c =100, MUSW__Paid_By__c = a.Id, MUSW__Payment_Gateway_Transaction_Number__c='23456');
        insert r;
        BGBK__Payment__c p = new BGBK__Payment__c (BGBK__Amount__c = 100,BGBK__Receipt__c = r.Id);
        insert p;        
        MUSW__Fee_Payment__c fp = new MUSW__Fee_Payment__c( BGBK__Payment__c = p.Id,MUSW__Receipt__c = r.Id);        
        
        HamptonTriggerService.voidReceipt(r.Id);
        HamptonTriggerService.isLocked();
        
    }
}