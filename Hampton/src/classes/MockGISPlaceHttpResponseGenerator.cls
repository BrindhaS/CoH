@isTest
global class MockGISPlaceHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
//      String endpoint = 'http://webgis.hampton.gov/ArcGIS/rest/services/AddressesAndCntrline/MapServer/0/query?text=&geometry=&geometryType=esriGeometryPoint&inSR=&spatialRel=esriSpatialRelIntersects&relationParam=&objectIds=&where=PlaceName+like+%27%25Barron+Elementary+School%25%27&time=&returnCountOnly=false&returnIdsOnly=false&returnGeometry=true&maxAllowableOffset=&outSR=&outFields=FullAdd%2CADDRESS%2CADDRESS_NUMERIC%2CCITY%2CSTATE%2CZIP%2CPlaceName%2CPOINT_X%2CPOINT_Y&f=pjson';
        String endpoint = 'http://webgis.hampton.gov/ArcGIS/rest/services/AddressesAndCntrline4/MapServer/0/query?text=&geometry=&geometryType=esriGeometryPoint&inSR=&spatialRel=esriSpatialRelIntersects&relationParam=&objectIds=&where=PlaceName+like+%27%25Barron+Elementary+School%25%27&time=&returnCountOnly=false&returnIdsOnly=false&returnGeometry=true&maxAllowableOffset=&outSR=&outFields=ADDRESS_NUMERIC%2C++ADDRESS_ALPHA%2CName%2C+TYPE_ABBR+%2C+Fulladd%2C+DIRECTION+%2C+ADD_TYPE+%2CSUB_ADD%2C++CITY%2C+STATE%2C+ZIP%2CPlaceName%2CPOINT_X%2CPOINT_Y&f&f=pjson';
        
        String body = '{' +
                        '  "displayFieldName" : "NAME",' +
                        '  "fieldAliases" : {' +
                        '    "FullAdd" : "FullAdd",' +
                        '    "ADDRESS" : "ADDRESS",' +
                        '    "ADDRESS_NUMERIC" : "ADDRESS_NUMERIC",' +
                        '    "CITY" : "CITY",' +
                        '    "STATE" : "STATE",' +
                        '    "ZIP" : "ZIP",' +
                        '    "PlaceName" : "PlaceName",' +
                        '    "POINT_X" : "POINT_X",' +
                        '    "POINT_Y" : "POINT_Y"' +
                        '  },' +
                        '  "geometryType" : "esriGeometryPoint",' +
                        '  "spatialReference" : {' +
                        '    "wkid" : 2284' +
                        '  },' +
                        '  "fields" : [' +
                        '    {' +
                        '      "name" : "FullAdd",' +
                        '      "type" : "esriFieldTypeString",' +
                        '      "alias" : "FullAdd",' +
                        '      "length" : 100' +
                        '    },' +
                        '    {' +
                        '      "name" : "ADDRESS",' +
                        '      "type" : "esriFieldTypeString",' +
                        '      "alias" : "ADDRESS",' +
                        '      "length" : 10' +
                        '    },' +
                        '    {' +
                        '      "name" : "ADDRESS_NUMERIC",' +
                        '      "type" : "esriFieldTypeDouble",' +
                        '      "alias" : "ADDRESS_NUMERIC"' +
                        '    },' +
                        '    {' +
                        '      "name" : "CITY",' +
                        '      "type" : "esriFieldTypeString",' +
                        '      "alias" : "CITY",' +
                        '      "length" : 10' +
                        '    },' +
                        '    {' +
                        '      "name" : "STATE",' +
                        '      "type" : "esriFieldTypeString",' +
                        '      "alias" : "STATE",' +
                        '      "length" : 12' +
                        '    },' +
                        '    {' +
                        '      "name" : "ZIP",' +
                        '      "type" : "esriFieldTypeString",' +
                        '      "alias" : "ZIP",' +
                        '      "length" : 10' +
                        '    },' +
                        '    {' +
                        '      "name" : "PlaceName",' +
                        '      "type" : "esriFieldTypeString",' +
                        '      "alias" : "PlaceName",' +
                        '      "length" : 50' +
                        '    },' +
                        '    {' +
                        '      "name" : "POINT_X",' +
                        '      "type" : "esriFieldTypeDouble",' +
                        '      "alias" : "POINT_X"' +
                        '    },' +
                        '    {' +
                        '      "name" : "POINT_Y",' +
                        '      "type" : "esriFieldTypeDouble",' +
                        '      "alias" : "POINT_Y"' +
                        '    }' +
                        '  ],' +
                        '  "features" : [' +
                        '    {' +
                        '      "attributes" : {' +
                        '        "ADDRESS_NUMERIC" : 45,' +
                        '        "ADDRESS_ALPHA" : null,' +
                        '        "NAME" : "FOX HILL",' +
                        '        "TYPE_ABBR" : "RD",' +
                        '        "DIRECTION" : " ",' +
                        '        "ADD_TYPE" : "UNIT",' +
                        '        "SUB_ADD" : "C",' +
                        '        "CITY" : "HAMPTON",' +
                        '        "STATE" : "VIRGINIA",' +
                        '        "ZIP" : "23669",' +
                        '        "PlaceName" : "Barron Elementary School",' +
                        '        "POINT_X" : -76.342216070000006,' +
                        '        "POINT_Y" : 37.048155029999997' +
                        '      },' +
                        '      "geometry" : {' +
                        '        "x" : 12112582.517748281,' +
                        '        "y" : 3548287.688909933' +
                        '      }' +
                        '    }' +
                        '  ]' +
                        '}';
        System.debug('actual endpoint =' + req.getEndpoint());
        System.assertEquals(endpoint, req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
//        res.setBody('{"features" : [,"attributes" : {,"FullAdd" : "45 FOX HILL RD","CITY" : "HAMPTON","STATE" : "VIRGINIA","ZIP" : "23669","PlaceName" : "Barron Elementary School","POINT_X" : -76.342216070000006,"POINT_Y" : 37.048155029999997},"geometry" : {,}]}');
        res.setBody(body);
        res.setStatusCode(200);
        return res;
    }

}