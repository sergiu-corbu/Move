//
//  MapViewModel.swift
//  Move
//
//  Created by Sergiu Corbu on 22.04.2021.
//

import Foundation
import CoreLocation
import MapKit

class MapViewModel: NSObject, CLLocationManagerDelegate ,ObservableObject, UITextFieldDelegate {
	static var shared: MapViewModel = MapViewModel()
	
    let locationManager = CLLocationManager()
    @Published var showLocation: Bool = false
    @Published var scooterLocation: String = ""
    @Published var cityName: String = "Allow location"
    @Published var selectedScooter: Scooter?
	
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
            case .authorizedWhenInUse, .authorizedAlways: //when app is open
                startTrackingUserLocation()
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .denied, .restricted:
                break
            @unknown default:
                assert(false, "handle new added case")
                break
        }
    }
    
    func startTrackingUserLocation() {
        showLocation = true
        locationManager.startUpdatingLocation()
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
    
    func locationGeocode(location coordinates: CLLocationCoordinate2D, _ completion: @escaping (String) -> Void) {
        let geocoder = CLGeocoder()
        let scooterLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        geocoder.reverseGeocodeLocation(scooterLocation) { [weak self] (placemarks, error) in
           // guard let self = self else { return }
            
            if let error = error { print(error); return }
            
            guard let placemark = placemarks?.first else { return }
            
            let result = placemark.thoroughfare! + " " + placemark.subThoroughfare!
            completion(result)
        }
    }
    
    func selectScooter(scooter: Scooter) {
        locationGeocode(location: scooter.coordinates) { address in
            var scooter = scooter
            scooter.addressName = address
            self.selectedScooter = scooter
        }
    }
}

extension MapViewModel {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else { return }
		let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
		DispatchQueue.main.async {
			self.locationManager.startUpdatingLocation()
			
		}
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
}
