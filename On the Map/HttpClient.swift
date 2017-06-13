//
//  HttpClient.swift
//  On the Map
//
//  Created by Shyam on 13/06/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import UIKit

class HttpClient: NSObject {

    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    // authentication state
    var requestToken: String? = nil
    var sessionID : String? = nil
    var userID : Int? = nil
    
    override init() {
        super.init()
    }
    
    // MARK: Shared Instance
    
    class func shared() -> HttpClient {
        struct Singelton {
            static let sharedInstance = HttpClient()
        }
        return Singelton.sharedInstance
    }
    
    // MARK: GET
    
    func taskForGETMethod(_ host:String, method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // Build the URL, Configure the request
        let request = NSMutableURLRequest(url: URLFromParameters(parameters, host: host, path: method))
        request.addValue(HttpClient.Constants.ParameterKeys.ApiKey, forHTTPHeaderField: HttpClient.Constants.ParameterValues.ApiValue)
        request.addValue(HttpClient.Constants.ParameterKeys.ParseApplicationIDKey, forHTTPHeaderField: HttpClient.Constants.ParameterValues.ParseApplicationID)
        
        // Make the request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            // Was there an error?
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            // Did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            // Was there any data returned?
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // Parse the data
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        task.resume()
        
        return task
    }
    
    // MARK: POST
    
    func taskForPOSTMethod(_ host:String, method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // Build the URL, Configure the request
        let request = NSMutableURLRequest(url: URLFromParameters(parameters, host: host, path: method))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        // Attact ApiKey and ApplicationID for Parse Host alone
        if host == Constants.UrlComponents.HostOfParseAPI {
            request.addValue(Constants.ParameterKeys.ApiKey, forHTTPHeaderField: HttpClient.Constants.ParameterValues.ApiValue)
            request.addValue(Constants.ParameterKeys.ParseApplicationIDKey, forHTTPHeaderField: HttpClient.Constants.ParameterValues.ParseApplicationID)
        }
        
        // Make the request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPostMethod", code: 1, userInfo: userInfo))
            }
            
            // Was there an error?
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            // Did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                sendError("Your request returned a status code \(statusCode!)")
                return
            }
            
            // Was there any data returned?
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // Parse the data
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        task.resume()
        
        return task
    }
    
    // MARK: Helpers
    
    // Given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        let newData = data.subdata(in: Range(5..<data.count))
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // create a URL from parameters
    private func URLFromParameters(_ parameters: [String:AnyObject], host:String, path: String) -> URL {
        
        var components = URLComponents()
        components.scheme = HttpClient.Constants.UrlComponents.Scheme
        components.host = host
        components.path = path
        components.queryItems = [URLQueryItem]()
        
        for (key,value) in parameters {
            let item = URLQueryItem(name: key, value: "\(value)")
            components.queryItems?.append(item)
        }
        
        return components.url!
    }
    
}

extension HttpClient {
    
    struct Constants {
        
        // MARK: URLComponents
        struct UrlComponents {
            static let Scheme = "https"
            static let HostOfParseAPI = "parse.udacity.com"
            static let HostOfUdacityAPI = "www.udacity.com"

        }
        
        // MARK: URL Methods
        struct UrlMethod {
            static let Session = "/api/session"
            static let StudentLocation = "/parse/classes/StudentLocation"
        }
        
        // MARK: URL
        struct URL {
            static let SignupURL = "https://auth.udacity.com/sign-up"
        }
        
        // MARK: Parameter Keys
        struct ParameterKeys {
            static let ApiKey = "X-Parse-REST-API-Key"
            static let ParseApplicationIDKey = "X-Parse-Application-Id"
        }
        
        struct ParameterValues {
            static let ApiValue = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
            static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        }
        
    }
}

