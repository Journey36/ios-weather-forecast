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
    private lazy var locationManager: LocationManager = {
        let locationManager = LocationManager(locationUpdatedAction: { location in
            print("<<<<<< current location: \(location.coordinate)")
            
            self.findCurrentAddress(by: location)
            
            OpenWeatherAPIList.currentWeather.request(coordinate: location.coordinate) { result in
                switch result {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    print(error)
                }
            }
            
            OpenWeatherAPIList.fiveDayForecast.request(coordinate: location.coordinate) { result in
                switch result {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    print(error)
                }
            }
            
        })
        locationManager.requestWhenInUseAuthorization()
        
        return locationManager
    }()

    private var currentAddress: Address? {
        didSet {
            if let currentAddress = currentAddress {
                print("Current Address: \(currentAddress.administrativeArea) \(currentAddress.locality)")
            }
        }
    }
    private var currentWeather: CurrentWeatherData!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager.requestLocation()
    }
    
    // MARK: - Methods
    
    private func findCurrentAddress(by location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location, preferredLocale: nil) { (placemarks, error) in
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
