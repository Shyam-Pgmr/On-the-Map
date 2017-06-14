//
//  OMSharedModel.swift
//  On the Map
//
//  Created by Shyam on 14/06/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import UIKit

class OMSharedModel: NSObject {

    // MARK: Properties
    var studentInformations = [StudentInformation]()
    var currentStudent = StudentInformation()
    
    override init() {
        super.init()
    }
    
    class func shared() -> OMSharedModel {
        struct Singelton {
            static var sharedInstance = OMSharedModel()
        }
        return Singelton.sharedInstance
    }
    
}
