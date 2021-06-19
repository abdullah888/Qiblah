//
//  LocalSolarTime.swift
//  AlQiblah
//
//  Created by abdullah FH  on 09/11/1442 AH.
//

import Combine
import Foundation
import CoreLocation

class LocalSolarTime: NSObject, ObservableObject, CLLocationManagerDelegate {
    var objectWillChange = PassthroughSubject<Void, Never>()
    var userCoordinate: Double = .zero {
        didSet {
            objectWillChange.send()
        }
    }
    
    var objectsWillChange = PassthroughSubject<Void, Never>()
    var localSolarTime: String = "" {
        didSet {
            objectsWillChange.send()
        }
    }
    
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
            self.userCoordinate = location.coordinate.longitude
        }
        
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        
        let gamma = (2*Double.pi) / 365*((Double(dayOfYear(Day: day, Month: month))-1+(Double((hour-12))/24)))
        let eqtime = 229.18*(0.000075+0.001868*cos(gamma)-0.032077*sin(gamma)-0.014615*cos(2*gamma)-0.040849*sin(2*gamma))
        let time_offset = eqtime+4*userCoordinate
        let tst = Double(hour)*60+Double(minutes)+Double(second)/60+time_offset
        let solarHour = Int(tst/60)
        let solarMinutes = Int(tst-Double((Int(tst/60))*60))
        let solarTime = Calendar.current.date(bySettingHour: solarHour-3, minute: solarMinutes, second: second, of: Date())!
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        self.localSolarTime = formatter.string(from: solarTime)
    }
    
    func dayOfYear(Day: Int, Month: Int) -> Int {
        switch Month {
        case 1:
            return Day
        case 2:
            return Day + 31
        case 3:
            return Day + 60
        case 4:
            return Day + 91
        case 5:
            return Day + 121
        case 6:
            return Day + 152
        case 7:
            return Day + 182
        case 8:
            return Day + 213
        case 9:
            return Day + 244
        case 10:
            return Day + 274
        case 11:
            return Day + 305
        case 12:
            return Day + 335
        default:
            return Day
        }
    }
}
