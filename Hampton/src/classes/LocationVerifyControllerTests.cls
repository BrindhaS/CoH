/**
 * This class contains unit tests for GIS location verify .
 */
@isTest (seeAllData=true)
private class LocationVerifyControllerTests{
    static testMethod void testIntersectionSearchAndSave(){
        PageReference pageRef = Page.LocationVerify;
        Test.setCurrentPage(pageRef); 

        Case newCase= new Case (Status = 'New',Origin ='Email', Disposition__c = 'Pending GIS Validation');
        insert newCase; 
        Test.startTest();
        ApexPages.CurrentPage().getparameters().put('id', newCase.id);
        ApexPages.StandardController standardController = new ApexPages.StandardController(newCase);
        LocationVerifyController controller = new LocationVerifyController(standardController);
        
        // negative case1
        controller.selectionIndex = null; 
        System.assertEquals(null,controller.save()); 

        //search case for intersection

        //negative case 2
        controller.cas.Intersection_Street_1__c = null;
        controller.searchIntersection();
        System.assertEquals(0,controller.intersections .size()); 

        //negative case 3
        controller.cas.Intersection_Street_1__c = 'teach';
        controller.cas.Intersection_Street_2__c = null;
        controller.searchIntersection();
        System.assertEquals(0,controller.intersections .size()); 
        
        //postive case       
        List<LocationVerifyController.Intersection> interList = new List<LocationVerifyController.Intersection>(); 
        LocationVerifyController.Intersection intersection1 = new LocationVerifyController.Intersection();
        intersection1.street1 = 'teach';
        intersection1.street2 = 'shell';
        
        
        controller.cas.Intersection_Street_1__c = intersection1.street1;
        controller.cas.Intersection_Street_2__c = intersection1.street2;

        Test.setMock(HttpCalloutMock.class, new MockGISIntersectionHttpResponseGenerator ());
        
        controller.searchIntersection();
        
        
        
        for(LocationVerifyController.Intersection intersec :controller.intersections ){
            if(intersec.street1.contains(intersection1.street1) ){
                System.assertEquals(intersection1.street2,intersec.street2); 
//                intersection1.streetFrom = intersec.streetFrom;
//                intersection1.streetTo = intersec.streetTo;
                break;   
            }
        }
//        interList.add(intersection1); 
//        controller.intersections.clear();
//        controller.intersections.addAll(interList);      
        //save address by intersection
        controller.selectionIndex = '0';
        controller.isMissingGISAddress = false;
        controller.save();
        //1. verify the redirect page
        String nextPage = controller.redirect().getUrl();
        System.assertEquals('/' + newCase.id + '?nooverride=true',nextPage );         
        //verify the case record.
        controller.cas = [Select id, Disposition__c, CaseNumber,Street_Number__c,Street_Name__c,City__c,State__c,Zip__c,Place__c,Intersection_Street_1__c,Intersection_Street_2__c  from Case where id=:controller.cas.Id];
//        System.assertEquals(intersection1.street1,controller.cas.Intersection_Street_1__c);         
        System.assertEquals(controller.cas.Intersection_Street_2__c,controller.cas.Intersection_Street_2__c);         
//        System.assertEquals(intersection1.streetFrom,controller.cas.Street_From__c);         
//        System.assertEquals(intersection1.streetTo,controller.cas.Street_To__c);         
        System.assertEquals(null,controller.cas.Street_Number__c);         
        System.assertEquals(null,controller.cas.Street_Name__c );         
        System.assertEquals(null,controller.cas.City__c);         
        System.assertEquals(null,controller.cas.State__c);         
        System.assertEquals(null,controller.cas.Zip__c);         
        System.assertEquals(null,controller.cas.Place__c );         
        
        //reload the page to verify tab. It should be 'Intersection' tab.
        ApexPages.CurrentPage().getparameters().put('id', newCase.id);
        ApexPages.StandardController standardController2 = new ApexPages.StandardController(newCase);
        LocationVerifyController controller2 = new LocationVerifyController(standardController2);
        System.assertEquals('intersection',controller2.selectedTab );           
        
        Test.stopTest();     
    }

    static testMethod void testStreetSearchAndSave(){
        PageReference pageRef = Page.LocationVerify;
        Test.setCurrentPage(pageRef); 

        Case newCase= new Case (Status = 'New',Origin ='Email', Disposition__c = 'Pending GIS Validation');
        insert newCase; 
        Test.startTest();
        ApexPages.CurrentPage().getparameters().put('id', newCase.id);
        ApexPages.StandardController standardController = new ApexPages.StandardController(newCase);
        LocationVerifyController controller = new LocationVerifyController(standardController);
        //by default the selected tab should 'Street Address'
        System.assertEquals('street',controller.selectedTab );
        // negative case1
        controller.selectionIndex = null; 
        System.assertEquals(null,controller.save()); 

        //search case for Street Address tab
        
        //negative case 1
        controller.cas.Street_Number__c = null;
        controller.searchStreet();
        System.assertEquals(0,controller.addresses.size()); 
        //negative case 2
        controller.cas.Street_Number__c = '452';
        controller.cas.Street_Name__c = null;
        controller.searchStreet();
        System.assertEquals(null,controller.addresses); 
        
        //positive case
        List<LocationVerifyController.Address> addressList = new List<LocationVerifyController.Address>(); 
        
        LocationVerifyController.Address address1 = new LocationVerifyController.Address();
        address1.streetNumber = '45';
        address1.street = 'FOX HILL RD';
        address1.addType = 'UNIT';
        address1.subAdd = 'C';
        
        controller.cas.Street_Number__c = address1.streetNumber ;
        controller.cas.Street_Name__c = address1.street ;
        Test.setMock(HttpCalloutMock.class, new MockGISStreetHttpResponseGenerator ());

        controller.searchStreet();
        system.debug('add=' +controller.addresses );

        for(LocationVerifyController.Address address:controller.addresses){
            if(address.street.contains('FOX HILL') ){
                System.assertEquals(true,address.streetNumber.contains(address1.streetNumber )); 
                address1.streetNumber = address.streetNumber;
                address1.street = address.street;
                address1.subAdd = address.subAdd;
                address1.addType = address.addType;
                address1.city = address.city;
                address1.state = address.state;
                address1.zip = address.zip;
                address1.placeName = address.placeName;
                //break;   
            }
        }

       // System.assertEquals(6,controller.addresses.size());//totalRecords
       // System.assertEquals(6,controller.totalStreet);//totalRecords

//        addressList.add(address1); 
//        controller.addresses.clear();
//        controller.addresses.addAll(addressList);         
        //save address by intersection
        controller.selectionIndex = '0';
        controller.isMissingGISAddress = false;
        controller.save();
        //1. verify the redirect page
        String nextPage = controller.redirect().getUrl();
        System.assertEquals('/' + newCase.id + '?nooverride=true',nextPage );         
        //verify the case record.
        controller.cas = [Select id, Disposition__c, CaseNumber,Street_Number__c,Street_Name__c,City__c,State__c,Zip__c,Place__c,Intersection_Street_1__c,Intersection_Street_2__c  from Case where id=:controller.cas.Id];
        System.assertEquals(address1.streetNumber.trim(),controller.cas.Street_Number__c.trim());         
        System.assertEquals(address1.street.trim(), controller.cas.Street_Name__c.trim() );         
        System.assertEquals(address1.city,controller.cas.City__c);         
        System.assertEquals(address1.state,controller.cas.State__c);         
        System.assertEquals(address1.zip,controller.cas.Zip__c);         
        System.assertEquals(address1.placeName,controller.cas.Place__c );         

        //reload the page to verify tab. It should be 'Intersection' tab.
        ApexPages.CurrentPage().getparameters().put('id', newCase.id);
        ApexPages.StandardController standardController2 = new ApexPages.StandardController(newCase);
        LocationVerifyController controller2 = new LocationVerifyController(standardController2);
        System.assertEquals('street',controller2.selectedTab ); 
               
        Test.stopTest();     
    }
    static testMethod void testPlaceNameSearchAndSave(){
        PageReference pageRef = Page.LocationVerify;
        Test.setCurrentPage(pageRef); 

        Case newCase= new Case (Status = 'New',Origin ='Email', Disposition__c = 'Pending GIS Validation');
        insert newCase; 
        Test.startTest();
        ApexPages.CurrentPage().getparameters().put('id', newCase.id);
        ApexPages.StandardController standardController = new ApexPages.StandardController(newCase);
        LocationVerifyController controller = new LocationVerifyController(standardController);
        //by default the selected tab should 'Street Address'
        System.assertEquals('street',controller.selectedTab );
        // negative case1
        controller.selectionIndex = null; 
        System.assertEquals(null,controller.save()); 

        //search case for Place tab
        
        //negative case 1
        controller.cas.Place__c = null;
        controller.searchPlace();
        System.assertEquals(0,controller.addresses.size()); 
 
        
        //positive case
        List<LocationVerifyController.Address> addressList = new List<LocationVerifyController.Address>(); 
        
        LocationVerifyController.Address place1 = new LocationVerifyController.Address();
        place1.placeName = 'Barron Elementary School';
        controller.cas.Place__c = place1.placeName ;

        Test.setMock(HttpCalloutMock.class, new MockGISPlaceHttpResponseGenerator());
        controller.searchPlace();


        for(LocationVerifyController.Address address:controller.places){
            if(address.placeName.equals('Barron Elementary School') ){
                System.assertEquals('45',address.streetNumber.trim()); 
                place1.streetNumber = address.streetNumber;
                place1.street = address.street;
                place1.subAdd = address.subAdd;
                place1.addType = address.addType;                
                place1.city = address.city;
                place1.state = address.state;
                place1.zip = address.zip;
                place1.placeName = address.placeName;
                break;   
            }
        }
//        addressList.add(place1); 
//        controller.addresses.clear();
//        controller.addresses.addAll(addressList);         
        //save address by place
        controller.selectionIndex = '0';
        controller.isMissingGISAddress = false;
        controller.save();
        //1. verify the redirect page
        String nextPage = controller.redirect().getUrl();
        System.debug('nextPage=' + nextPage);
        System.assertEquals('/' + newCase.id + '?nooverride=true',nextPage );         
        //verify the case record.
        controller.cas = [Select id, Disposition__c, CaseNumber,Street_Number__c,Street_Name__c,City__c,State__c,Zip__c,Place__c,Intersection_Street_1__c,Intersection_Street_2__c  from Case where id=:controller.cas.Id];
        System.assertEquals(place1.streetNumber.trim(),controller.cas.Street_Number__c.trim());         
        System.assertEquals(place1.street.trim(), controller.cas.Street_Name__c.trim() );         
        System.assertEquals(place1.city,controller.cas.City__c);         
        System.assertEquals(place1.state,controller.cas.State__c);         
        System.assertEquals(place1.zip,controller.cas.Zip__c);         
        System.assertEquals(place1.placeName,controller.cas.Place__c );         

        //reload the page to verify tab. It should be 'place' tab.
        ApexPages.CurrentPage().getparameters().put('id', newCase.id);
        ApexPages.StandardController standardController2 = new ApexPages.StandardController(newCase);
        LocationVerifyController controller2 = new LocationVerifyController(standardController2);
        System.assertEquals('place',controller2.selectedTab ); 
               
        Test.stopTest();     
    }


    static testMethod void testRedirect(){
        PageReference pageRef = Page.LocationVerify;
        Test.setCurrentPage(pageRef); 

        Case newCase= new Case (Status = 'New',Origin ='Email', Disposition__c = 'Pending GIS Validation');
        insert newCase; 
        Test.startTest();
        ApexPages.CurrentPage().getparameters().put('id', newCase.id);
        ApexPages.StandardController standardController = new ApexPages.StandardController(newCase);
        LocationVerifyController controller = new LocationVerifyController(standardController);
        String nextPage = controller.redirect().getUrl();
        System.assertEquals('/' + newCase.id + '?nooverride=true',nextPage ); 
       
        Test.stopTest();   
    } 
       
    public static testMethod void testOverrideRedirect(){
        PageReference pageRef = Page.LocationVerify;
        Test.setCurrentPage(pageRef); 

        //override
        Case newCase= new Case (Status = 'New',Origin ='Email', Disposition__c = 'Not GIS');
        insert newCase; 
        Test.startTest();
        ApexPages.CurrentPage().getparameters().put('id', newCase.id);
        ApexPages.StandardController standardController = new ApexPages.StandardController(newCase);
        LocationVerifyController controller = new LocationVerifyController(standardController);
        String nextPage = controller.checkAndRedirect().getUrl();
        System.assertEquals('/' + newCase.id + '?nooverride=true',nextPage ); 
        
        //override Disposition__c = null
        Case newCase2= new Case (Status = 'New',Origin ='Email');
        insert newCase2; 
        
        ApexPages.CurrentPage().getparameters().put('id', newCase2.id);
        ApexPages.StandardController standardController2 = new ApexPages.StandardController(newCase2);
        LocationVerifyController controller2 = new LocationVerifyController(standardController2);
        String nextPage2 = controller2.checkAndRedirect().getUrl();
        System.assertEquals('/' + newCase2.id + '?nooverride=true',nextPage2 ); 
               
        Test.stopTest();
           
        
    }
    
    public static testMethod void testNooverrideRedirect(){
        PageReference pageRef = Page.LocationVerify;
        Test.setCurrentPage(pageRef); 

        //no override
        Case newCase= new Case (Status = 'New',Origin ='Email', Disposition__c = 'Pending GIS Validation');
        insert newCase; 
        Test.startTest();
        ApexPages.CurrentPage().getparameters().put('id', newCase.id);
        ApexPages.StandardController standardController = new ApexPages.StandardController(newCase);
        LocationVerifyController controller = new LocationVerifyController(standardController);
        String nextPage = (controller.checkAndRedirect()== null)?null:controller.checkAndRedirect().getUrl();
        System.assertEquals(null,nextPage ); 
//        System.assertEquals('/apex/LocationVerify?id=' + newCase.id + '&sfdc.override=1',nextPage ); 
       
//https://c.cs7.visual.force.com/apex/LocationVerify?id=500M0000003pq5h&sfdc.override=1


        Test.stopTest();
           
        
    }


}