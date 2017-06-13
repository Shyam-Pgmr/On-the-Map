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
            let alertController = UIAlertController(title: Constants.Alert.Title.Validation, message: validationMessage, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: Constants.Alert.ActionTitle.OK, style: .default , handler: { (action) in
                textFieldToFocus.becomeFirstResponder()
            })
            alertController.addAction(okAction)
            
            present(alertController, animated: true)
            
            return false
        }
        
        return true
    }
    
    func login() {
        
        guard validate() else {
            return
        }
    }
    
    func openSignupScreen() {
        
        if let signupURL = URL(string: Constants.URL.SignupURL) {
        
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
