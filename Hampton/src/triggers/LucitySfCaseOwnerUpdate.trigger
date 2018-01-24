trigger LucitySfCaseOwnerUpdate on Case (before update) {
  
  
  
  
  
  for (Case c : Trigger.new) {
  
  /*if(null==c.Lucity_Status_Code__c )
  {
  c.Lucity_Status_Code__c =0.00;
  } */
  
  
   if((c.Lucity_Public_Works__c == TRUE) || (c.Lucity_Parks__c == TRUE))   {
      if((c.Lucity_Status_Code__c == 10))
      {
        if(c.Lucity_Dept_Code__c.equals('420')) 
        {
        Group que = [select name,id from Group where name = 'PW - Engineering'];
        c.OwnerId = que.id;
        }
        else if(c.Lucity_Dept_Code__c.equals('430')) 
        {
         Group que = [select name,id from Group where name = 'PW - Traffic'];
        c.OwnerId = que.id;
        }        
        else if(c.Lucity_Dept_Code__c.equals('440'))
        {
         Group que = [select name,id from Group where name = 'PW - Streets'];
        c.OwnerId = que.id;
        } 
       
        else if(c.Lucity_Dept_Code__c.equals('460')) 
        {
         Group que = [select name,id from Group where name = 'PW - Drainage'];
        c.OwnerId = que.id;
        }  
       
        else if(c.Lucity_Dept_Code__c.equals('470'))
        {
         Group que = [select name,id from Group where name = 'PW - Solid Waste'];
        c.OwnerId = que.id;
        }  
       
        else if(c.Lucity_Dept_Code__c.equals('475'))  
       {
         Group que = [select name,id from Group where name = 'PW - Facilities'];
        c.OwnerId = que.id;
        } 
        else if(c.Lucity_Dept_Code__c.equals('485'))
        {
         Group que = [select name,id from Group where name = 'PW - Wastewater'];
        c.OwnerId = que.id;
        } 
      else if(c.Lucity_Dept_Code__c.equals('1')) 
        {
         Group que = [select name,id from Group where name = 'Parks - Athletics'];
        c.OwnerId = que.id;
        } 
      else if(c.Lucity_Dept_Code__c.equals('2'))  
       {
         Group que = [select name,id from Group where name = 'Parks - Facilities'];
        c.OwnerId = que.id;
        } 
      else if(c.Lucity_Dept_Code__c.equals('3'))  
        {
         Group que = [select name,id from Group where name = 'Parks - Athletics'];
        c.OwnerId = que.id;
        } 
      else if(c.Lucity_Dept_Code__c.equals('4'))  
        {
         Group que = [select name,id from Group where name = 'Parks - Trees'];
        c.OwnerId = que.id;
        }     
  
  }
  if(c.Lucity_Status_Code__c == 952)
  {
   Group que = [select name,id from Group where name = '311 Quality Support'];
        c.OwnerId = que.id;
  }
}
}
}