//
//  OMMapViewController.swift
//  On the Map
//
//  Created by Shyam on 14/06/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import UIKit
import MapKit

class OMMapViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: Action
    

    // MARK: Helpers
    
    func setupRefreshDelegate() {
        
        if let tabBarController = self.tabBarController as? OMTabViewController {
            tabBarController.tabViewControllerDelegate = self
        }
    }
    
    func setupView() {
        
        setupRefreshDelegate()
    }
    
    func populateMapWithStudentPins() {
        
    }
    
}

extension OMMapViewController: OMTabViewControllerDelegate {
    
    func refreshView() {
        populateMapWithStudentPins()
    }
    
    func startLoading() {
        
    }
    
    func stopLoading() {
        
    }
    
}

