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
    
    var location:Location
    var firstName:String
    var lastName:String
    var mediaURL:String
    var mapString:String
    var createdAt:Double
    var updatedAt:Double
    
    init(studentDictionary:[String:AnyObject]) {
        
        self.firstName = studentDictionary[Keys.FirstName] as? String ?? ""
        self.lastName = studentDictionary[Keys.LastName] as? String ?? ""
        self.mediaURL = studentDictionary[Keys.MediaURL] as? String ?? ""
        self.mapString = studentDictionary[Keys.MapString] as? String ?? ""
        self.createdAt = studentDictionary[Keys.CreatedAt] as? Double ?? 0
        self.updatedAt = studentDictionary[Keys.UpdatedAt] as? Double ?? 0
        
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
