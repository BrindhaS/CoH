global class CaseModel {
    @future (callout=true) global static void Geocode(string anId, string anAddress)
    {
        AlreadyFired = true;
        
        if (String.IsBlank(anId)) {
            system.debug('case id is blank');
            return;
        }
        
        Case aCase = [ select id, address_x__c, address_y__c from Case where id = :anId ];
        
        if (String.IsBlank(anAddress)) {
            system.debug('case address is blank');
            return;
        }
            
        ESRILocator locator = ESRILocator.NewInstance();
        ESRILocator.FindAddressResponse response = locator.findAddressCandidates(anAddress);
        
        if (response.isEmpty()){
             aCase.Address_X__c = null;
             aCase.Address_Y__c = null;
             update aCase;
             return;
        }
        
        aCase.Address_X__c = response.candidates[0].location.x;
        aCase.Address_Y__c = response.candidates[0].location.y;
        system.debug('Callout Done'+ response.candidates[0].location.x +response.candidates[0].location.y );
        update aCase;
    }
    
    public static void HandleInsert(list<Case> newList, list<Case> oldList)
    {
        if (AlreadyFired)
            return;
        
        if (newList.size() == 1)
            GeoCode(newList[0].id, newList[0].street__c);
    }
    
    private static boolean AlreadyFired = false;
}