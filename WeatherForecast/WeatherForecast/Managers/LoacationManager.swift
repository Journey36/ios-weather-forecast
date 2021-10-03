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
    typealias LocationFailedAction = (String) -> Void
    
    private var locationUpdatedAction: LocationUpdatedAction?
    private var locationDeniedAction: LocationDeniedAction?
    private var locationFailedAction: LocationFailedAction?
    private var isLocationRequested = false
    
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
        isLocationRequested = true
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {
            return
        }
        if isLocationRequested {
            isLocationRequested.toggle()
            locationUpdatedAction?(currentLocation)
        }
        
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
            locationFailedAction?("현재 위치를 찾을 수 없습니다. 잠시 후 다시 시도해주세요.")
        default:
            print("didFailWithError - \(error.localizedDescription))")
            locationFailedAction?(error.localizedDescription)
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
