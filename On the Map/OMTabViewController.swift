//
//  OMTabViewController.swift
//  On the Map
//
//  Created by Shyam on 14/06/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import UIKit

protocol OMTabViewControllerDelegate {
    func refreshView()
    func startLoading()
    func stopLoading()
}

class OMTabViewController: UITabBarController {
    
    // MARK: Properties
    var tabViewControllerDelegate: OMTabViewControllerDelegate?
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: API
    private func getStudentInformation() {
        
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
       
        logout()
    }
    
    @IBAction func refreshBarButtonTapAction(_ sender: UIBarButtonItem) {
        
        getStudentInformation()
    }
    
    // MARK: Helpers
    
    private func setupView() {
    
        getStudentInformation()
    }
    
    private func startLoading() {
        if let delegate = tabViewControllerDelegate  {
            delegate.startLoading()
        }
    }
    
    private func stopLoading() {
        if let delegate = tabViewControllerDelegate  {
            delegate.stopLoading()
        }
    }
    
    private func refreshScreens() {
        if let delegate = tabViewControllerDelegate  {
            delegate.refreshView()
        }
    }
    
    private func logout() {
        
        startLoading()
        
        HttpClient.shared().logout { (success, errorMessage) in
            
            Utility.runOnMain {
                if success {
                    self.dismiss(animated: true)
                }
                else {
                    Utility.Alert.show(title: Constants.Alert.Title.Oops, message: errorMessage!, viewController: self, handler: { (action) in
                    })
                }
                self.stopLoading()
            }
        }
    }
}
