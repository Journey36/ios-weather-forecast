//
//  LoacationManager.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/09/06.
//

import CoreLocation

class LocationManager: CLLocationManager {
    typealias LocationUpdatedAction = (CLLocation) -> Void
    
    
    private var locationUpdatedAction: LocationUpdatedAction?
    
    init(locationUpdatedAction: @escaping LocationUpdatedAction) {
        self.locationUpdatedAction = locationUpdatedAction
        super.init()
        
        delegate = self
    }
    
    func requestAuthorization() {
        requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {
            return
        }
        locationUpdatedAction?(currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
