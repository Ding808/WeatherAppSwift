//
//  LocationManager.swift
//  YueyangWeather
//
//  Created by Yueyang Ding on 2024-11-16.
//
import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()

    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    @Published var location: CLLocation = CLLocation()
    @Published var isLocationAvailable: Bool = false

    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            print("No valid locations found.")
            return
        }
        
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        self.location = location
        self.isLocationAvailable = true
        print("Updated Coordinates: Latitude \(latitude), Longitude \(longitude)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
        self.isLocationAvailable = false
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location access granted.")
            locationManager.startUpdatingLocation()
        case .denied:
            print("Location access denied.")
            self.isLocationAvailable = false
        case .restricted:
            print("Location access restricted.")
            self.isLocationAvailable = false
        case .notDetermined:
            print("Location permission not determined.")
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            print("Unknown authorization status.")
        }
    }
}
