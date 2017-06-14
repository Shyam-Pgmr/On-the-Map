//
//  OMPostingViewController.swift
//  On the Map
//
//  Created by Shyam on 15/06/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class OMPostingViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var mediaURLTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Properties
    var studentInfo = OMSharedModel.shared().currentStudent
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: Action

    @IBAction func saveBarButtonTapAction(_ sender: UIBarButtonItem) {
        
        
    }
    
    @IBAction func cancelBarButtonTapAction(_ sender: UIBarButtonItem) {
        
        dismiss(animated:true)
    }
    
    // MARK: Helpers
    
    private func setupView() {
        
    }
    
    private func startLoading() {
        loadingView.alpha = 1
    }
    
    private func stopLoading() {
        loadingView.alpha = 0
    }
    
    private func saveInformation() {
        
        guard validateForSaving() else {
            return
        }
        
        
    }
    
    private func validateForSaving() -> Bool {
        
        if studentInfo.mapString.isEmpty {
         
            Utility.Alert.show(title: Constants.Alert.Title.Validation, message: Constants.Alert.Message.EmptyAddress, viewController: self, handler: { (action) in
                self.addressTextField.becomeFirstResponder()
            })
            return false
        }
        
        if studentInfo.mediaURL.isEmpty {
            Utility.Alert.show(title: Constants.Alert.Title.Validation, message: Constants.Alert.Message.EmptyMediaURL, viewController: self, handler: { (action) in
                self.mediaURLTextField.becomeFirstResponder()
            })
            return false
        }

        return true
    }
    
    func validateAddressField() -> Bool {
        
        if let text = addressTextField.text, text.isEmpty {
            Utility.Alert.show(title: Constants.Alert.Title.Validation, message: Constants.Alert.Message.EmptyAddress, viewController: self, handler: { (action) in
                self.addressTextField.becomeFirstResponder()
            })
            return false
        }
        
        return true
    }
    
    func getGeoCodeFromAddress() {
        
        guard validateAddressField() else {
            return
        }
        
        addressTextField.resignFirstResponder()
        startLoading()
        
        let geocorder = CLGeocoder()
        let address = addressTextField.text!
        geocorder.geocodeAddressString(address) { (placeMarkArray, error) in
            
            if error == nil {
                if let placeMark = placeMarkArray?.first {
                    self.addAnnotationIntoMap(using: placeMark)
                }
            }
            else {
                Utility.Alert.show(title: Constants.Alert.Title.Oops, message: error.debugDescription, viewController: self, handler: { (action) in
                })
            }
            
            self.stopLoading()
        }
    }
    
    func addAnnotationIntoMap(using placeMark:CLPlacemark) {
        
        mapView.addAnnotation(MKPlacemark(placemark: placeMark))
        
        // Zoom into that location
        if let coord = placeMark.location?.coordinate {
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: coord, span: span);
            mapView.setRegion(region, animated: true)
            
            // Caching
            studentInfo.location = StudentInformation.Location(latitude: coord.latitude, longitude: coord.longitude)
            studentInfo.mapString = addressTextField.text!
        }
    }
}

// MARK: TextField Delegate

extension OMPostingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == addressTextField {
            getGeoCodeFromAddress()
        }
        else {
            studentInfo.mediaURL = mediaURLTextField.text!
            textField.resignFirstResponder()
        }
        
        return true
    }
}
