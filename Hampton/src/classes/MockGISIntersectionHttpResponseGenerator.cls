@isTest
global class MockGISIntersectionHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
//        String endpoint = 'http://webgis.hampton.gov/ArcGIS/rest/services/AddressesAndCntrline/MapServer/1/query?text=&geometry=&geometryType=esriGeometryPoint&inSR=&spatialRel=esriSpatialRelIntersects&relationParam=&objectIds=&where=CNTRNAME+like+%27%25teach%25%27+and+%28CROSS_FROM+like+%27%25shell%25%27+or+CROSS_TO+like+%27%25shell%25%27%29&time=&returnCountOnly=false&returnIdsOnly=false&returnGeometry=true&maxAllowableOffset=&outSR=&outFields=CROSS_FROM%2CCROSS_TO%2CCNTRNAME%2CStartX%2CStartY%2CEndX%2CEndY%2COBJECTID&f=pjson';
       /*
        String body = '{'+
                      ' "displayFieldName" : "CNTRNAME", ' + 
                      '"fieldAliases" : {' +
                      '  "CNTRNAME" : "Street Name",' +
                      '  "TOADDRR" : "TOADDRR",' +
                      '  "CROSS_FROM" : "CROSS_FROM",' +
                      '  "CROSS_TO" : "CROSS_TO",' +
                      '  "StartX" : "StartX",' +
                      '  "StartY" : "StartY",' +
                      '  "EndX" : "EndX",' +
                      '  "EndY" : "EndY",' +
                      '  "OBJECTID" : "OBJECTID",' +
                      '  "CLASS" : "Road Class",' +
                      '  "CNTRTYPE" : "Street Type (Abbr)",' +
                      '  "CNTRTYPEFULL" : "Street Type",' +
                      '  "RouteType" : "RouteType",' +
                      '  "CNTRPFIX" : "Prefix (Abbr)",' +
                      '  "MP" : "MP"' +
                      '},' +
                      '"geometryType" : "esriGeometryPolyline",' +
                      '"spatialReference" : {' +
                      '  "wkid" : 2284' +
                      '},' +
                      '"fields" : [' +
                      '  {' +
                      '    "name" : "CNTRNAME",' +
                      '    "type" : "esriFieldTypeString",' +
                      '    "alias" : "Street Name",' +
                      '    "length" : 30' +
                      '  },' +
                      ' {' +
                      '    "name" : "TOADDRR",' +
                      '    "type" : "esriFieldTypeDouble",' +
                      '     "alias" : "TOADDRR"' +
                      '  },' +
                      '  {' +
                      '    "name" : "CROSS_FROM",' +
                      '    "type" : "esriFieldTypeString",' +
                      '    "alias" : "CROSS_FROM",' +
                      '    "length" : 50' +
                      '  },' +
                      '  {' +
                      '    "name" : "CROSS_TO",' +
                      '    "type" : "esriFieldTypeString",' +
                      '    "alias" : "CROSS_TO",' +
                      '    "length" : 50' +
                      '  },' +
                      '  {' +
                      '    "name" : "StartX",' +
                      '    "type" : "esriFieldTypeDouble",' +
                      '    "alias" : "StartX"' +
                      '  },' +
                      '  {' +
                      '    "name" : "StartY",' +
                      '    "type" : "esriFieldTypeDouble",' +
                      '    "alias" : "StartY"' +
                      '  },' +
                      '  {' +
                      '    "name" : "EndX",' +
                      '    "type" : "esriFieldTypeDouble",' +
                      '    "alias" : "EndX"' +
                      '  },' +
                      '  {' +
                      '    "name" : "EndY",' +
                      '    "type" : "esriFieldTypeDouble",' +
                      '    "alias" : "EndY"' +
                      '  },' +
                      '  {' +
                      '    "name" : "OBJECTID",' +
                      '    "type" : "esriFieldTypeOID",' +
                      '    "alias" : "OBJECTID"' +
                      '  },' +
                      '  {' +
                      '    "name" : "CLASS",' +
                      '    "type" : "esriFieldTypeString",' +
                      '    "alias" : "Road Class",' +
                      '    "length" : 25' +
                      '  },' +
                      '  {' +
                      '    "name" : "CNTRTYPE",' +
                      '    "type" : "esriFieldTypeString",' +
                      '    "alias" : "Street Type (Abbr)",' +
                      '    "length" : 15' +
                      '  },' +
                      '  {' +
                      '    "name" : "CNTRTYPEFULL",' +
                      '    "type" : "esriFieldTypeString",' +
                      '    "alias" : "Street Type",' +
                      '    "length" : 15' +
                      '  },' +
                      '  {' +
                      '    "name" : "RouteType",' +
                      '    "type" : "esriFieldTypeString",' +
                      '    "alias" : "RouteType",' +
                      '    "length" : 15' +
                      '  },' +
                      '  {' +
                      '    "name" : "CNTRPFIX",' +
                      '    "type" : "esriFieldTypeString",' +
                      '    "alias" : "Prefix (Abbr)",' +
                      '    "length" : 5' +
                      '  },' +
                      '  {' +
                      '    "name" : "MP",' +
                      '    "type" : "esriFieldTypeString",' +
                      '    "alias" : "MP",' +
                      '    "length" : 5' +
                      '  }' +
                      '],' +
                      '"features" : [' +
                      '  {' +
                      '    "attributes" : {' +
                      '      "CNTRNAME" : "TEACH",' +
                      '      "TOADDRR" : 642,' +
                      '      "CROSS_FROM" : "SHELL",' +
                      '      "CROSS_TO" : "JAMESTOWN",' +
                      '      "StartX" : -76.379541459999999,' +
                      '      "StartY" : 37.008948140000001,' +
                      '      "EndX" : -76.380992169999999,' +
                      '      "EndY" : 37.01035753,' +
                      '      "OBJECTID" : 10519,' +
                      '      "CLASS" : "Residential",' +
                      '      "CNTRTYPE" : "ST",' +
                      '      "CNTRTYPEFULL" : " ",' +
                      '      "RouteType" : " ",' +
                      '      "CNTRPFIX" : " ",' +
                      '      "MP" : "308"' +
                      '    },' +
                      '    "geometry" : {' +
                      '      "paths" : [' +
                      '        [' +
                      '          [' +
                      '            12102013.000157803,' +
                      '            3533769.7501500845' +
                      '          ],' +
                      '          [' +
                      '            12101999.999837786,' +
                      '            3533783.7500220984' +
                      '          ],' +
                      '          [' +
                      '            12101971.999965757,' +
                      '            3533814.0001341254' +
                      '          ],' +
                      '          [' +
                      '            12101933.000157729,' +
                      '            3533858.2499901652' +
                      '          ],' +
                      '          [' +
                      '            12101861.999965653,' +
                      '            3533944.2501182407' +
                      '          ],' +
                      '          [' +
                      '            12101772.000093579,' +
                      '            3534045.999878332' +
                      '          ],' +
                      '          [' +
                      '            12101695.999837503,' +
                      '            3534135.5000384152' +
                      '          ],' +
                      '          [' +
                      '            12101615.999837428,' +
                      '            3534229.5000385046' +
                      '          ],' +
                      '          [' +
                      '            12101577.999837399,' +
                      '            3534273.2499265522' +
                      '          ]' +
                      '        ]' +
                      '      ]' +
                      '    }' +
                      '  }' +
                      ']' +
                    '}';
        */// this is old format of return fields
        String endpoint = 'http://webgis.hampton.gov/ArcGIS/rest/services/AddressesAndCntrline4/MapServer/1/query?text=&geometry=&geometryType=esriGeometryPoint&inSR=4326&spatialRel=esriSpatialRelIntersects&relationParam=&objectIds=&where=Name+like+%27%25teach%25%27+and+Name+like+%27%25shell%25%27&time=&returnCountOnly=false&returnIdsOnly=false&returnGeometry=true&maxAllowableOffset=&outSR=&outFields=name%2C+lat%2C+long%2CShape&f=pjson';
        String body =   '{'+
                        '  "displayFieldName" : "Name",' +
                        '  "fieldAliases" : {' +
                        '    "Name" : "Name",' +
                        '    "LAT" : "LAT",' +
                        '    "LONG" : "LONG"' +
                        '  },' +
                        '  "geometryType" : "esriGeometryMultipoint",' +
                        '  "spatialReference" : {' +
                        '    "wkid" : 2284' +
                        '  },' +
                        '  "fields" : [' +
                        '    {' +
                        '      "name" : "Name",' +
                        '      "type" : "esriFieldTypeString",' +
                        '      "alias" : "Name",' +
                        '      "length" : 250' +
                        '    },' +
                        '    {' +
                        '      "name" : "LAT",' +
                        '      "type" : "esriFieldTypeDouble",' +
                        '      "alias" : "LAT"' +
                        '    },' +
                        '    {' +
                        '      "name" : "LONG",' +
                        '      "type" : "esriFieldTypeDouble",' +
                        '      "alias" : "LONG"' +
                        '    }' +
                        '  ],' +
                        '  "features" : [' +
                        '    {' +
                        '      "attributes" : {' +
                        '        "Name" : "HEWINS & SHELL & TEACH",' +
                        '        "LAT" : 37.008948140000001,' +
                        '        "LONG" : -76.379541459999999' +
                        '      },' +
                        '      "geometry" : {' +
                        '        "points" : [' +
                        '          [' +
                        '            12102013.000157803,' +
                        '            3533769.7501500845' +
                        '          ]' +
                        '        ]' +
                        '      }' +
                        '    }' +
                        '  ]' +
                        '} ';
       
        System.debug('actual endpoint =' + req.getEndpoint());
        System.assertEquals(endpoint.trim(), req.getEndpoint().trim());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
//        res.setBody('{"features" : [,"attributes" : {,"CNTRNAME" : "TEACH","CROSS_FROM" : "SHELL","CROSS_TO" : "JAMESTOWN","StartX" : -76.379541459999999,"StartY" : 37.008948140000001,"EndX" : -76.380992169999999,"EndY" : 37.01035753},"geometry" : {,}]}');
        res.setBody(body);
        res.setStatusCode(200);
        return res;
    }
}