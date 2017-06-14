//
//  Constants.swift
//  On the Map
//
//  Created by Shyam on 13/06/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import Foundation

struct Constants {
    
    // MARK: Alert
    struct Alert {
        
        struct Title {
            static let Validation = "Validation"
            static let ServerError = "Server Error"
            static let Oops = "Oops"
            static let Success = "Success"

        }
        
        struct Message {
            static let EmptyEmail = "Email Can't be empty"
            static let EmptyPassword = "Password can't be empty"
            static let LoginSuccess = "Logged in successfully"
            static let InvalidCredentials = "Invalid credential"
        }
        
        struct ActionTitle {
            static let OK = "OK"
        }
        
    }
    
    struct Segue {
        static let PresentHome = "PresentHome"
    }
    
}
