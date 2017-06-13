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
    
    func addBorderToLoginButton() {
        
        loginButton.layer.cornerRadius = 4.0
    }
    
    func setupView() {
        
        addBorderToLoginButton()
    }
    
    func validate() -> Bool {
        
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
    
    func startLoading() {
        view.isUserInteractionEnabled = false
        loginButton.isHidden = true
    }
    
    func stopLoading() {
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
            
            Utility.runOnMain {
                if success {
                    Utility.Alert.show(title: Constants.Alert.Title.Success, message: Constants.Alert.Message.LoginSuccess, viewController: self, handler: { (action) in
                        
                    })
                }
                else {
                    Utility.Alert.show(title: Constants.Alert.Title.Oops, message: errorMessage!, viewController: self, handler: { (action) in
                        // Focus Email Field
                        self.emailTextField.becomeFirstResponder()
                    })
                }
                self.stopLoading()
            }
        }
    }
    
    func openSignupScreen() {
        
        if let signupURL = URL(string: HttpClient.Constants.URL.SignupURL) {
        
            UIApplication.shared.open(signupURL, options: [:], completionHandler: nil)
        }
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
