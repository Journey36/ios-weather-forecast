//
//  LoacationManager.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/09/06.
//

import CoreLocation

class LocationManager: CLLocationManager {
    typealias LocationUpdatedAction = (CLLocation) -> Void
    typealias LocationDeniedAction = () -> Void
    typealias LocationFailedAction = () -> Void
    
    private var locationUpdatedAction: LocationUpdatedAction?
    private var locationDeniedAction: LocationDeniedAction?
    private var locationFailedAction: LocationFailedAction?
    private var currentLocation: CLLocation?
    
    init(locationUpdatedAction: @escaping LocationUpdatedAction,
         locationDeniedAction: @escaping LocationDeniedAction,
         locationFailedAction: @escaping LocationFailedAction) {
        self.locationUpdatedAction = locationUpdatedAction
        self.locationDeniedAction = locationDeniedAction
        self.locationFailedAction = locationFailedAction
        super.init()
        
        delegate = self
        desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    
    func requestAuthorization() {
        requestWhenInUseAuthorization()
    }
    
    override func requestLocation() {
        super.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastUpdatedLocation = locations.last else {
            return
        }
        guard let currentLocation = currentLocation else {
            self.currentLocation = lastUpdatedLocation
            locationUpdatedAction?(lastUpdatedLocation)
            return
        }
        guard lastUpdatedLocation.timestamp > currentLocation.timestamp else {
            return
        }
        self.currentLocation = lastUpdatedLocation
        locationUpdatedAction?(lastUpdatedLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let error = error as? CLError else {
            return
        }
        
        stopUpdatingLocation()
        
        switch error.code {
        case .denied:
            print("didFailWithError - denied")
            locationDeniedAction?()
        case .locationUnknown:
            print("didFailWithError - locationUnknown")
            locationFailedAction?()
        default:
            print("didFailWithError - \(error.localizedDescription))")
            locationFailedAction?()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            print("didChangeAuthorization - authorizedWhenInUse")
            requestLocation()
        case .denied:
            print("didChangeAuthorization - denied")
            locationDeniedAction?()
        case .notDetermined:
            print("didChangeAuthorization - notDetermined")
        default:
            print("didChangeAuthorization - \(status.rawValue)")
        }
    }
}
