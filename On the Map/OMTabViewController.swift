//
//  OMTabViewController.swift
//  On the Map
//
//  Created by Shyam on 14/06/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import UIKit

class OMTabViewController: UITabBarController {
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: API
    func getStudentInformation() {
        
        startLoading()
        let _ = HttpClient.shared().getStudentLocation { (success, studentLocations, errorMessage) in
            Utility.runOnMain {
                if success {
                    if let studentLocations = studentLocations {
                        OMSharedModel.shared().studentInformations = studentLocations
                        self.refreshScreens()
                    }
                }
                else {
                    Utility.Alert.show(title: Constants.Alert.Title.Oops, message: errorMessage!, viewController: self, handler: { (action) in
                    })
                }
                self.stopLoading()
            }
        }
    }
    
    // MARK: Action
    @IBAction func logoutBarButtonTapAction(_ sender:UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func refreshBarButtonTapAction(_ sender: UIBarButtonItem) {
        
        getStudentInformation()
    }
    
    // MARK: Helpers
    
    func setupView() {
    
        getStudentInformation()
    }
    
    
    func startLoading() {
        
    }
    
    func stopLoading() {
        
    }
    
    func refreshScreens() {
        
    }
    
}
