//
//  MapViewModel.swift
//  Move
//
//  Created by Sergiu Corbu on 22.04.2021.
//

import Foundation
import CoreLocation
import MapKit

class MapViewModel: NSObject, CLLocationManagerDelegate ,ObservableObject {
    
    let locationManager = CLLocationManager()
    @Published var showLocation: Bool = false
    @Published var scooterLocation: String = ""
    @Published var cityName: String = "Allow location"
    
    override init() {
        super.init()
        checkLocationServices()
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            print("erppppr")
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
            case .authorizedWhenInUse: //when app is open
                startTrackingUserLocation()
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .denied:
                break
            default:
                break
        }
    }
    
    func startTrackingUserLocation() {
        showLocation = true
        locationManager.stopUpdatingLocation()
        geoCode()
        
    }
    
    func geoCode() {
        let geocoder = CLGeocoder()
        guard let location = locationManager.location else { print("error while unwrapping"); return }
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let error = error { print(error); return }
            
            guard let placemark = placemarks?.first else { return }
            
            self.cityName = placemark.locality ?? "Not defined"
        }
    }
    
    func scooterGeocode(location coordinates: [Double]) {
        let geocoder = CLGeocoder()
        let scooterLocation = CLLocation(latitude: coordinates[1], longitude: coordinates[0])
        geocoder.reverseGeocodeLocation(scooterLocation) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let error = error { print(error); return }
            
            guard let placemark = placemarks?.first else { return }
            self.scooterLocation = placemark.thoroughfare! + " " + placemark.subThoroughfare!
        }
    }
}

extension MapViewModel {
    
    /*func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { // updating location
     guard let location = locations.last else { return }
     let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
     let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 700, longitudinalMeters: 700)*/
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
}
/*
class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    private let geocoder = CLGeocoder()
    let locationManager = CLLocationManager()
    let willChange = PassthroughSubject<Void, Never>()
    
    @Published var status: CLAuthorizationStatus? {
        willSet {
            willChange.send()
        }
    }
    
    @Published var location: CLLocation? {
        willSet {
            willChange.send()
        }
    }
    @Published var placemark: CLPlacemark? {
        willSet {
            willChange.send()
        }
    }
    
    override init(){
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        geocode()
    }
    
    func geocode() {
        
        guard let location = location else {
            print("no location")
            return
        }
        geocoder.reverseGeocodeLocation(location, completionHandler: {(response, error) in
            if error == nil {
                guard let response = response else { print("no response"); return}
                self.placemark = response.first
                if let place = self.placemark {
                    self.location = place.location
                }
                
            }
        })
    }
    
    
     func checkLocationServices() -> Bool {
     if CLLocationManager.locationServicesEnabled() {
     
     return true
     } else {
     print("enable location services in settings")
     return false
     }
     }
    
    private func geocode() {
     guard let location = self.location else { return }
     geocoder.reverseGeocodeLocation(location, completionHandler: { (result, error) in
     if error == nil {
     if let result = result, let loc = result.first {
     self.city = loc.locality
     }
     } else {
     self.city = "Unknown location"
     }
     })
     }
    
}



 import Foundation
 import CoreLocation
 
 class LocationManager: NSObject, ObservableObject {
 
 private let locationManager = CLLocationManager()
 private let geocoder = CLGeocoder()
 
 @Published var location: CLLocation?
 
 override init() {
 super.init()
 
 locationManager.desiredAccuracy = kCLLocationAccuracyBest
 locationManager.distanceFilter = kCLDistanceFilterNone
 locationManager.requestWhenInUseAuthorization()
 locationManager.requestAlwaysAuthorization()
 locationManager.startUpdatingLocation()
 locationManager.delegate = self
 }
 private func geocode() {
 guard let location = self.location else { return }
 geocoder.reverseGeocodeLocation(location, completionHandler: { (result, error) in
 if error == nil {
 if let result = result, let loc = result.first {
 self.city = loc.locality
 }
 } else {
 self.city = "Unknown location"
 }
 })
 }
 
 }
 
 extension LocationManager: CLLocationManagerDelegate {
 
 func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
 
 guard let location = locations.last else { return }
 
 DispatchQueue.main.async {
 self.location = location
 }
 
 }
 
 }
 */
