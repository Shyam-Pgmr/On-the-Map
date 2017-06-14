//
//  OMLoginViewController.swift
//  On the Map
//
//  Created by Shyam on 13/06/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import UIKit

class OMLoginViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: Action
    
    @IBAction func loginButtonTapAction(_ sender: UIButton) {
        login()
    }
    
    @IBAction func signupButtonTapAction(_ sender: UIButton) {
        openSignupScreen()
    }
    
    // MARK: Helper
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true) // To close keyboard when tapped on screen
    }
    
    private func addBorderToLoginButton() {
        
        loginButton.layer.cornerRadius = 4.0
    }
    
    private func setupView() {
        
        addBorderToLoginButton()
    }
    
    private func validate() -> Bool {
        
        var validationMessage = ""
        var textFieldToFocus:UITextField!
        
        if emailTextField.text!.isEmpty {
            validationMessage = Constants.Alert.Message.EmptyEmail
            textFieldToFocus = emailTextField
        }
        else if passwordTextField.text!.isEmpty {
            validationMessage = Constants.Alert.Message.EmptyPassword
            textFieldToFocus = passwordTextField
        }
        
        guard validationMessage.isEmpty else {
            
            // Show validation Alert
            Utility.Alert.show(title: Constants.Alert.Title.Validation, message: validationMessage, viewController: self, handler: { (action) in
                textFieldToFocus.becomeFirstResponder()
            })
            
            return false
        }
        
        return true
    }
    
    private func startLoading() {
        view.isUserInteractionEnabled = false
        loginButton.isHidden = true
    }
    
    private func stopLoading() {
        view.isUserInteractionEnabled = true
        loginButton.isHidden = false
    }
    
    func login() {
        
        guard validate() else {
            return
        }
        
        view.endEditing(true) // Close Keyboard
        let username = emailTextField.text!
        let password = passwordTextField.text!
        
        startLoading()
        
        HttpClient.shared().login(username: username, password: password) { (success, errorMessage) in
            
            if success {
                HttpClient.shared().getUserDetail(completionHandler: { (success, errorMessage) in
                    
                    Utility.runOnMain {
                        if success {
                            self.clearFields()
                            self.openHomeScreen()
                        }
                        else {
                            self.showError(message: errorMessage!)
                        }
                        self.stopLoading()
                    }
                })
            }
            else {
                Utility.runOnMain {
                    self.showError(message: errorMessage!)
                    self.stopLoading()
                }
            }
        }
    }
    
    private func clearFields() {
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    private func showError(message:String) {
        
        Utility.Alert.show(title: Constants.Alert.Title.Oops, message: message, viewController: self, handler: { (action) in
            // Focus Email Field
            self.emailTextField.becomeFirstResponder()
        })
    }
    
    private func openSignupScreen() {
        
        Utility.openUrlInDefaultBrowser(url: HttpClient.UrlPath.SignupURL, from: self)
    }
    
    private func openHomeScreen() {
        
        performSegue(withIdentifier: Constants.Segue.PresentHome, sender: self)
    }
    
}

// MARK: TextField Delegate

extension OMLoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
            login()
        }
        
        return true
    }
    
}
