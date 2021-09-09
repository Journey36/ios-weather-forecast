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
    private var isLocationRequested = false
    
    init(locationUpdatedAction: @escaping LocationUpdatedAction) {
        self.locationUpdatedAction = locationUpdatedAction
        super.init()
        
        delegate = self
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
        
    }
}
