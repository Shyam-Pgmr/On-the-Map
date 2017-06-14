//
//  OMHttpManager.swift
//  On the Map
//
//  Created by Shyam on 13/06/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import UIKit

extension HttpClient {
    
    
    /// Login API
    ///
    /// - Parameters:
    ///   - username: Email of user
    ///   - password: password of user
    ///   - completionHandler: Handler to be called when task is finished
    func login(username:String, password:String, completionHandler: @escaping (_ success:Bool, _ errorString:String?) -> Void) {
        
        let parameters = [String:AnyObject]()
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        // Make the request
        
        let _ = taskForPOSTMethod(Constants.UrlComponents.HostOfUdacityAPI, method: Constants.UrlMethod.Session, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            // Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(false, error.localizedDescription)
            } else {
                completionHandler(true, nil)
            }
        }
    }
    
}
