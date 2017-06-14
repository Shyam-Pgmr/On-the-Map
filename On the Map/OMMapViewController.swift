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
    @IBOutlet weak var loadingView: UIView!
    
    // MARK: Properties
    
    var studentLocations = [StudentInformation]()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupRefreshDelegate()
    }

    // MARK: Helpers
    
    func setupRefreshDelegate() {
        
        if let tabBarController = self.tabBarController as? OMTabViewController {
            tabBarController.tabViewControllerDelegate = self
        }
    }
    
    func setupView() {
        
        startLoading()
    }
    
    func populateMapWithStudentPins() {
        
        func createAndAddAnnotationIntoMap(using studentInfo:StudentInformation) {
            
            let annotation = MKPointAnnotation()
            annotation.title = studentInfo.firstName + " " + studentInfo.lastName
            annotation.coordinate = CLLocationCoordinate2D(latitude: studentInfo.location.latitude, longitude:studentInfo.location.longitude)
            annotation.subtitle = studentInfo.mediaURL
            
            mapView.addAnnotation(annotation)
        }
        
        func zoomIntoFirstStudentLocation() {
            
            if let firstStudentInfo = studentLocations.first {
                let firstStudentCoord = CLLocationCoordinate2D(latitude: firstStudentInfo.location.latitude, longitude: firstStudentInfo.location.longitude)
                
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: firstStudentCoord, span: span);
                mapView.setRegion(region, animated: true)
            }
        }
        
        studentLocations = OMSharedModel.shared().studentInformations
        
        // Clear existing annoations in the Map
        if mapView.annotations.count > 0 {
            mapView.removeAnnotations(mapView.annotations)
        }
        
        // Add Pins representing Students into Map
        for studentInfo in studentLocations {
            createAndAddAnnotationIntoMap(using: studentInfo)
        }
        zoomIntoFirstStudentLocation()
    }
}

// MARK: OMTabViewController Delegate

extension OMMapViewController: OMTabViewControllerDelegate {
    
    func refreshView() {
        populateMapWithStudentPins()
    }
    
    func startLoading() {
        loadingView.alpha = 1
    }
    
    func stopLoading() {
        loadingView.alpha = 0
    }
    
}

// MARK: MapView Delegate

extension OMMapViewController:MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let pointAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PointAnnotationView")
        pointAnnotationView.canShowCallout = true
        pointAnnotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        return pointAnnotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let annotation = view.annotation as? MKPointAnnotation {
            
            if let mediaURLString = annotation.subtitle {
                
                Utility.openUrlInDefaultBrowser(url: mediaURLString, from: self)
            }
        }
    }
}

