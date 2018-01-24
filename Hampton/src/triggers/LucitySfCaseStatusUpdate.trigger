trigger LucitySfCaseStatusUpdate on Case (before update) {
  for (Case c : Trigger.new) {
  
    if(null==c.Lucity_Status_Type__c)
  {
  c.Lucity_Status_Type__c='';
  }
  
   if((c.Lucity_Public_Works__c== TRUE) || (c.Lucity_Parks__c == TRUE))   {
      if(c.Lucity_Status_Type__c.equalsIgnoreCase('New Request'))      
          c.Status = 'New';
      else if(c.Lucity_Status_Type__c.equalsIgnoreCase('Transferred') || c.Lucity_Status_Type__c.equalsIgnoreCase('Transfered'))      
          c.Status = 'Transferred ';
      else if(c.Lucity_Status_Type__c.equalsIgnoreCase('Return to 311 Call Center'))      
          c.Status = 'Returned by Lucity';          
      else if(c.Lucity_Status_Type__c.equalsIgnoreCase('Assigned to WO'))      
          c.Status = 'In-Progress ';
      else if((c.Lucity_Status_Type__c.equalsIgnoreCase('Request on hold'))||(c.Lucity_Status_Type__c.equals('WO On Hold')))      
          c.Status = 'On Hold '; 
      else if(c.Lucity_Status_Type__c.equalsIgnoreCase('WO Cancelled'))
      {      
          c.Status = 'Closed'; 
          c.Reason = 'Duplicate Request';       
      } 
      else if((c.Lucity_Status_Type__c.equalsIgnoreCase('WO Completed'))||(c.Lucity_Status_Type__c.equalsIgnoreCase('Completed')))
      {      
          c.Status = 'Closed'; 
          c.Reason = 'Completed';       
      } 
    }
    }
    }