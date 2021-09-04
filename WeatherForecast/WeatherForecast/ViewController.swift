//
//  WeatherForecast
//  ViewController.swift
//
//  Created by Kyungmin Lee on 2021/01/22.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController {
    // MARK: - Properties
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        return locationManager
    }()
    private var currentCoordinate: CLLocationCoordinate2D! {
        didSet {
            findCurrentAddress()
        }
    }
    private var currentAddress: Address! {
        didSet {
            print("\(currentAddress.administrativeArea) \(currentAddress.locality)")
        }
    }
    private var currentWeather: CurrentWeatherData!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestCurrentCoordinate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // for test
//        let seoulCoord = CLLocationCoordinate2D(latitude: 37.572849, longitude: 126.976829)
        let coord = Coordinate(latitude: 37.572849, longitude: 126.976829)
        OpenWeatherAPIList.currentWeather.request(coordinate: coord) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
        
        OpenWeatherAPIList.fiveDayForecast.request(coordinate: coord) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Methods
    private func requestCurrentCoordinate() {
        locationManager.requestLocation()
    }
    
    private func findCurrentAddress() {
        let currentLocation = CLLocation(latitude: currentCoordinate.latitude, longitude: currentCoordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(currentLocation, preferredLocale: nil) { (placemarks, error) in
            if let errorCode = error {
                print(errorCode)
                return
            }
            if let administrativeArea = placemarks?.first?.administrativeArea, let locality = placemarks?.first?.locality {
                self.currentAddress = Address(administrativeArea: administrativeArea, locality: locality)
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentCoordinate = locations.last?.coordinate {
            self.currentCoordinate = currentCoordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}
