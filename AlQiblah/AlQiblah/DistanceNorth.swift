//
//  DistanceNorth.swift
//  AlQiblah
//
//  Created by abdullah FH  on 09/11/1442 AH.
//



import Foundation
import CoreLocation
import Combine

class DistanceNorth: NSObject, ObservableObject, CLLocationManagerDelegate {
    var objectWillChange = PassthroughSubject<Void, Never>()
    var meterDistance: String = "" {
        didSet {
            objectWillChange.send()
        }
    }
    
    private let destination = CLLocation(latitude: 21.386740, longitude: 39.901112)
    
    private let locationManager: CLLocationManager
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        
        self.locationManager.delegate = self
        self.setup()
    }
    
    private func setup() {
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.startUpdatingLocation()
            self.locationManager.startUpdatingHeading()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            self.meterDistance = String(format: "%.2f", location.distance(from: destination)/1000+79) 
        }
    }
}


