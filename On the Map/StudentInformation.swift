//
//  OMStudent.swift
//  On the Map
//
//  Created by Shyam on 14/06/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import UIKit

struct StudentInformation {

    struct Location {
        var latitude:Double
        var longitude:Double
        
        init() {
            latitude = 0
            longitude = 0
        }
    }

    var userID:String
    var location:Location
    var firstName:String
    var lastName:String
    var mediaURL:String
    var mapString:String
    
    init() {

        self.userID = ""
        self.firstName = ""
        self.lastName = ""
        self.mediaURL = ""
        self.mapString = ""        
        self.location = Location()
    }
    
    init(studentDictionary:[String:Any]) {
        
        self.userID = studentDictionary[Keys.UniqueKey] as? String ?? ""
        self.firstName = studentDictionary[Keys.FirstName] as? String ?? ""
        self.lastName = studentDictionary[Keys.LastName] as? String ?? ""
        self.mediaURL = studentDictionary[Keys.MediaURL] as? String ?? ""
        self.mapString = studentDictionary[Keys.MapString] as? String ?? ""
        
        var location = Location()
        location.latitude = studentDictionary[Keys.Latitude] as? Double ?? 0
        location.longitude = studentDictionary[Keys.Longitude] as? Double ?? 0
        self.location = location
    }
    
}

extension StudentInformation {
    
    struct Keys {
        static let objectID = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
    }
}
