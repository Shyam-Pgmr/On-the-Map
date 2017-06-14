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
        
        let _ = taskForPOSTMethod(UrlComponents.HostOfUdacityAPI, method: UrlMethod.Session, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            // Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(false, error.localizedDescription)
            } else {
                
                // Parse result for SessionID
                let resultsDictionary = results as! [String:Any]
                let sessionDictionary = resultsDictionary["session"] as! [String:Any]
                self.sessionID = sessionDictionary["id"] as? String
                
                completionHandler(true, nil)
            }
        }
    }
    
    
    /// Get Student Locations from Server
    ///
    /// - Parameter completionHandler: Handler to be called when task is finished
    func getStudentLocation(completionHandler: @escaping (_ success:Bool, _ studentArray:[StudentInformation]?, _ errorString:String?) -> Void) {
        
        var parameters = [String:Any]()
        parameters[ParameterKeys.Limit] = Constants.StudentLimit
        parameters[ParameterKeys.Order] = "-" + StudentInformation.Keys.UpdatedAt
        
        // Make the request
        
        let _ = taskForGETMethod(UrlComponents.HostOfParseAPI, method: UrlMethod.StudentLocation, parameters: parameters) { (results, error) in
            
            /// It will Create Array<StudentInformation> from Array<Dictionary>
            ///
            /// - Returns: Array containing StudentInformation objects
            func parseStudentDictionaryArray(resultToBeParsed:AnyObject?) -> [StudentInformation]{
                
                var parsedArray = [StudentInformation]()
                if let resultsDictionary = resultToBeParsed as? [String:Any] {
                    let resultsArray = resultsDictionary["results"] as! [[String:Any]]
                    
                    for studentDictionary in resultsArray {
                        
                        let student = StudentInformation(studentDictionary: studentDictionary)
                        parsedArray.append(student)
                    }
                }
                return parsedArray
            }
            
            // Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(false,nil, error.localizedDescription)
            } else {
                completionHandler(true,parseStudentDictionaryArray(resultToBeParsed: results), nil)
            }
        }
    }
    
}
