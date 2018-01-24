trigger InspectionViolationAddInspection on Inspection_Violation__c (before insert)
{
    /*  creates Inspections for IV's inserted by DRE as a result of a re-inspection request
     *  uses the DREgen flag to determine if IV was created by DRE
     */
    
    Map<Id, Inspection_Violation__c[]> inspIvsMap = new Map<Id, Inspection_Violation__c[]>();
    Id[] insIds = new Id[]{};
    Id[] vids = new Id[]{};
    for (Inspection_Violation__c iv : trigger.new)
    {
        if (iv.DREgen__c)
        {
            if (inspIvsMap.containsKey(iv.Inspection__c)) inspIvsMap.get(iv.Inspection__c).add(iv);
            else inspIvsMap.put(iv.Inspection__c, new Inspection_Violation__c[]{iv});
            
            insIds.add(iv.Inspection__c);
            vids.add(iv.Violation__c);
        }
    }
    if (insIds.size() == 0 && vids.size() == 0) return;
    
    // query for related Inspections and Violations
    MUSW__Inspection__c[] insq = database.query('select ' + MUSW.UtilityDb.getFieldsFor_Str('MUSW__Inspection__c', false) + ', RecordTypeId from MUSW__Inspection__c where Id in :insIds');
    Map<Id, MUSW__Inspection__c> insqMap = new Map<Id, MUSW__Inspection__c>(insq);
    
    MUSW__Violation__c[] vq = [select MUSW__Status__c, MUSW__Complaint2__c, Permit2__c from MUSW__Violation__c where Id in :vids];
    Map<Id, MUSW__Violation__c> vqMap = new Map<Id, MUSW__Violation__c>(vq);
    
    // create one/many Inspections for each IV, depending on whether Days_to_next is specified
    MUSW__Inspection__c[] reinsList = new MUSW__Inspection__c[]{};
    Map<Inspection_Violation__c, MUSW__Inspection__c> ivReinsMap = new Map<Inspection_Violation__c, MUSW__Inspection__c>();
    for (Id insId : inspIvsMap.keySet())
    {
    	// if Days_to_next specified: one re-Inspection for all IV's
        if (insqMap.get(insId).Days_to_Next_Inspection__c != null)
        {
            Inspection_Violation__c iv = inspIvsMap.get(insId)[0];
            MUSW__Inspection__c reins = HamptonTriggerService.createReinspectionFromIV(
                insqMap.get(insId), vqMap.get(iv.Violation__c), iv);
            reinsList.add(reins);
            
            for (Inspection_Violation__c ivx : inspIvsMap.get(insId)) ivReinsMap.put(ivx, reins);
        }
        else // group by IV.days_to_correct, and create one re-inspection for group
        {
            Map<String, Inspection_Violation__c[]> ivGrouped = HamptonTriggerService.groupIVs(inspIvsMap.get(insId));
            
            // for each key create a re-inspection
            for (String key : ivGrouped.keySet())
            {
                Inspection_Violation__c iv = ivGrouped.get(key)[0];
                MUSW__Inspection__c reins = HamptonTriggerService.createReinspectionFromIV(
                    insqMap.get(insId), vqMap.get(iv.Violation__c), iv);
                reinsList.add(reins);
                
                for (Inspection_Violation__c ivx : ivGrouped.get(key)) ivReinsMap.put(ivx, reins);
            }
        }
    }
    
    if (reinsList.size() > 0)
    {
        insert reinsList;
        
        // overwrite IV.Inspection with the corresponding newly inserted Inspection
        for (Inspection_Violation__c iv : ivReinsMap.keySet())
        {
            iv.Inspection__c = ivReinsMap.get(iv).Id;
        }
    }
}