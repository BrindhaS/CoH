/*
    Trigger is used by GIS Change Order to update 
    the value of Disposition field depending on Location Format.
*/

trigger SetDisposition on Case (before insert) {

    for(Case cn : Trigger.new)    {        
        if(cn.Location_Format__c != 'Service Location N/A' && cn.Location_Format__c != null &&  cn.Location_Format__c != '')    
            cn.Disposition__c = 'Pending GIS Validation';
             
    }
    
}