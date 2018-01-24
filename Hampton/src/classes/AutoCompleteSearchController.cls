global class AutoCompleteSearchController
{
    @RemoteAction
    global static String[] search(String txt)
    {
        //Sobject[] ps = database.query('select ' + fld + ' from ' + obj + ' where ' + fld + ' like \'' + txt + '%\' limit 8');
        MUSW__Parcel__C[] ps =[select MUSW__Street__c from MUSW__Parcel__C where  MUSW__Street_Number__c=:txt order by MUSW__Street__c ASC];
        
        String[] res = new String[]{};
        for (MUSW__Parcel__C p : ps) res.add(p.MUSW__Street__c);
        return res;
    }
    
    @RemoteAction
    global static String redirect(String obj, String fld, String selection)
    {
        String pid;
        if (selection != null && selection != '')
        {
            Sobject[] ps = database.query('select Id from ' + obj + ' where ' + fld + ' = \'' + selection + '\'');
            
            if (ps.size() > 0) pid = '/' + ps[0].Id;
        }
        
        return pid;
    }
}