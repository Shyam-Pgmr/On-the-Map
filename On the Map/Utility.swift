//
//  Utility.swift
//  On the Map
//
//  Created by Shyam on 14/06/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import Foundation
import UIKit

class Utility: NSObject {
    
    // MARK: AlertView
    struct Alert {
        
        
        /// Present Simple AlertController with 'Alert' Style and a OK AlertAction
        ///
        /// - Parameters:
        ///   - title: Title of Alert
        ///   - message: message of Alert
        ///   - viewController: ViewController that will be used to present AlertController
        ///   - handler: Handler for Ok AlertAction
        static func show(title:String, message:String, viewController:UIViewController, handler:@escaping ((UIAlertAction)->Void)) {
            
            let alertController = UIAlertController(title:title, message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: Constants.Alert.ActionTitle.OK, style: .default , handler: handler)
            alertController.addAction(okAction)
            
            viewController.present(alertController, animated: true)
        }
    }

    
    /// Executes given block of Code in Main Thread
    ///
    /// - Parameter block: block that should be exected on Main Thread
    class func runOnMain(block: @escaping (Void)->Void) {
        DispatchQueue.main.async {
            block()
        }
    }
    
    // MARK: Helpers
    class func shared() -> Utility {
        struct Singelton {
            static var sharedInstance = Utility()
        }
        return Singelton.sharedInstance
    }
}
