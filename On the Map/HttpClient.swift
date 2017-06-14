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
    var sessionID : String? = nil
    
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
    
    func taskForGETMethod(_ host:String, method: String, parameters: [String:Any], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // Build the URL, Configure the request
        let request = NSMutableURLRequest(url: URLFromParameters(parameters, host: host, path: method))
        // Attact ApiKey and ApplicationID for Parse Host alone
        if host == UrlComponents.HostOfParseAPI {
            request.addValue(ParameterValues.ApiValue, forHTTPHeaderField:ParameterKeys.ApiKey)
            request.addValue(ParameterValues.ParseApplicationID, forHTTPHeaderField: ParameterKeys.ParseApplicationIDKey)
        }
        
        // Make the request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            // Was there an error?
            guard (error == nil) else {
                
                let nsError = (error! as NSError)
                if nsError.code == NSURLErrorNotConnectedToInternet {
                    sendError(ErrorDescription.NoInternetConnection)
                }
                else {
                    sendError("There was an error with your request: \(error!)")
                }
                return
            }

            // Did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                
                print(String(data: data!, encoding: String.Encoding.utf8) ?? "nothing")
                
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                var errorMessage = ""
                
                if statusCode == StatusCode.InvalidCredentials {
                    errorMessage = ErrorDescription.InvalidCredentials
                }
                else {
                    errorMessage = "Your request returned a status code \(statusCode!)"
                }
                
                sendError(errorMessage)
                return
            }

            // Was there any data returned?
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // Parse the data
            let shouldSkipBytes = (host == UrlComponents.HostOfUdacityAPI)
            self.convertDataWithCompletionHandler(data, shouldSkipBytes, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        task.resume()
        
        return task
    }
    
    // MARK: POST
    
    func taskForPOSTMethod(_ host:String, method: String, parameters: [String:Any], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // Build the URL, Configure the request
        let request = NSMutableURLRequest(url: URLFromParameters(parameters, host: host, path: method))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        // Attact ApiKey and ApplicationID for Parse Host alone
        if host == UrlComponents.HostOfParseAPI {
            request.addValue(ParameterValues.ApiValue, forHTTPHeaderField:ParameterKeys.ApiKey)
            request.addValue(ParameterValues.ParseApplicationID, forHTTPHeaderField: ParameterKeys.ParseApplicationIDKey)
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
                
                let nsError = (error! as NSError)
                if nsError.code == NSURLErrorNotConnectedToInternet {
                    sendError(ErrorDescription.NoInternetConnection)
                }
                else {
                    sendError("There was an error with your request: \(error!)")
                }
                return
            }
            
            // Did we get a successful 2XX response?
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                var errorMessage = ""
                
                if statusCode == StatusCode.InvalidCredentials {
                    errorMessage = ErrorDescription.InvalidCredentials
                }
                else {
                    errorMessage = "Your request returned a status code \(statusCode!)"
                }
                
                sendError(errorMessage)
                return
            }
            
            // Was there any data returned?
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // Parse the data
            let shouldSkipBytes = (host == UrlComponents.HostOfUdacityAPI)
            self.convertDataWithCompletionHandler(data, shouldSkipBytes, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        task.resume()
        
        return task
    }
    
    // MARK: Delete
    
    func taskForDELETEMethod(_ host:String, method: String, parameters: [String:Any], completionHandlerForDELETE: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // Build the URL, Configure the request
        let request = NSMutableURLRequest(url: URLFromParameters(parameters, host: host, path: method))
        request.httpMethod = "DELETE"
        
        if method == UrlMethod.Session {
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
        }
        
        // Make the request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForDELETE(nil, NSError(domain: "taskForDELETEMethod", code: 1, userInfo: userInfo))
            }
            
            // Was there an error?
            guard (error == nil) else {
                
                let nsError = (error! as NSError)
                if nsError.code == NSURLErrorNotConnectedToInternet {
                    sendError(ErrorDescription.NoInternetConnection)
                }
                else {
                    sendError("There was an error with your request: \(error!)")
                }
                return
            }
            
            // Did we get a successful 2XX response?
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                var errorMessage = ""
                
                if statusCode == StatusCode.InvalidCredentials {
                    errorMessage = ErrorDescription.InvalidCredentials
                }
                else {
                    errorMessage = "Your request returned a status code \(statusCode!)"
                }
                
                sendError(errorMessage)
                return
            }
            
            // Was there any data returned?
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // Parse the data
            let shouldSkipBytes = (host == UrlComponents.HostOfUdacityAPI)
            self.convertDataWithCompletionHandler(data, shouldSkipBytes, completionHandlerForConvertData: completionHandlerForDELETE)
        }
        
        task.resume()
        
        return task
    }
    
    // MARK: Helpers
    
    // Given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data,_ shouldSkipBytes:Bool, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var newData = data
        if shouldSkipBytes {
           newData = newData.subdata(in: Range(5..<newData.count))
        }

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
    private func URLFromParameters(_ parameters: [String:Any], host:String, path: String) -> URL {
        
        var components = URLComponents()
        components.scheme = HttpClient.UrlComponents.Scheme
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
    
    // MARK: URLComponents
    struct UrlComponents {
        static let Scheme = "https"
        static let HostOfParseAPI = "parse.udacity.com"
        static let HostOfUdacityAPI = "www.udacity.com"
    }
    
    // MARK: URL Methods
    struct UrlMethod {
        static let Session = "/api/session"
        static let Users = "/api/users/"
        static let StudentLocation = "/parse/classes/StudentLocation"
    }
    
    // MARK: URL
    struct UrlPath {
        static let SignupURL = "https://auth.udacity.com/sign-up"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let ApiKey = "X-Parse-REST-API-Key"
        static let ParseApplicationIDKey = "X-Parse-Application-Id"
        static let Limit = "limit"
        static let Order = "order"
        static let Skip = "skip"
    }
    
    struct ParameterValues {
        static let ApiValue = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    }
    
    struct StatusCode {
        static let InvalidCredentials = 403
    }
    
    struct ErrorDescription {
        static let InvalidCredentials = "Invalid Credentials"
        static let NoInternetConnection = "Check your Internet Connection"
    }

}

