/* This Class is used by Trigger on Case Object to update 
the Case Owner according to the Case Assignment Rule.
*/

public class CaseAssignmentProcessor {
     
     public static void processCases(Set<Id> id) {
          List<Case> casesToUpdate = new List<Case>();
          
           for(Case tempObj : [Select id,Owner.Name from Case where id IN :id])    {
                if(tempObj.Owner.Name != 'CitiWorks Reject')    {
                    Database.DMLOptions dmo = new Database.DMLOptions();
                    dmo.assignmentRuleHeader.useDefaultRule= true; 
                    tempObj.setOptions(dmo);
                    casesToUpdate.add(tempObj);
                }
           }
          
          CaseFieldUpdate.inFutureContext = true;
          try    {
              Database.upsert(casesToUpdate);
          }
          catch(System.DmlException dEx)    {
             System.debug('DML ERROR:' + dEx.getMessage());            
          }
     }
 
}