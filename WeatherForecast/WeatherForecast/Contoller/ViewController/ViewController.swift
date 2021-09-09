//
//  ForecastListViewController.swift
//  WeatherForecast
//
//  Created by Journey36 on 2021/09/06.
//

import UIKit
import CoreLocation

final class ViewController: UIViewController {
    private var manager: CLLocationManager = .init()
    private var dataTaskManager: DataTaskManager = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }
}

// MARK:- Extensions
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation: CLLocation = locations.first else { return }

        let latitude: String = .init(currentLocation.coordinate.latitude)
        let longitude: String = .init(currentLocation.coordinate.longitude)
        let currentCoordinate: CurrentLocation = (latitude, longitude)

        dataTaskManager.fetchWeatherData(on: currentCoordinate, type: .current) { [weak self] (result: Result<CurrentWeather, ErrorHandler>) in
            switch result {
                case .success(let data):
                    print("현재 날씨 : \(data)")
                case .failure:
                    ErrorHandler.SystemError(type: .invalidData)
            }
        }

        dataTaskManager.fetchWeatherData(on: currentCoordinate, type: .forecast) { [weak self] (result: Result<ForecastList, ErrorHandler>) in
            switch result {
                case .success(let data):
                    print("5일 예보 : \(data)")
                case .failure:
                    ErrorHandler.SystemError(type: .invalidData)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
}
