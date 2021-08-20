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
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
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
        let seoulCoord = CLLocationCoordinate2D(latitude: 37.572849, longitude: 126.976829)
        CurrentWeatherAPI.shared.getData(coordinate: seoulCoord) { result in
            switch result {
            case .success(let currentWeather):
                print("\(currentWeather.cityName): \(currentWeather.temperature.currentCelsius)도")
                print(currentWeather)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        WeatherForecastAPI.shared.getData(coordinate: seoulCoord) { result in
            switch result {
            case .success(let weatherForecast):
                print("\(weatherForecast.city.name): \(weatherForecast.items[0].temperature.currentCelsius)도 - \(weatherForecast.items[0].utc)UTC")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Methods
    private func requestCurrentCoordinate() {
        locationManager.startUpdatingLocation()
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

// MARK: - CLLocationManagerDelegate Methods
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentCoordinate = locations.last?.coordinate {
            locationManager.stopUpdatingLocation()
            self.currentCoordinate = currentCoordinate
        }
    }
}
