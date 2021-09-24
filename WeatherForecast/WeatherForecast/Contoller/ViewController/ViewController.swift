//
//  ForecastListViewController.swift
//  WeatherForecast
//
//  Created by Journey36 on 2021/09/06.
//

import UIKit
import CoreLocation

final class ViewController: UIViewController {
    // MARK: - Properties
    // MARK: Stored Properties
    private var manager: CLLocationManager = .init()
    private var dataTaskManager: DataTaskManager = .init()
    private var currentWeatherData: CurrentWeather?
    private var forecastListData: ForecastList?
    private var currentAddress: String?
    private lazy var forecastListView: ForecastListView = .init()

    // MARK: - Methods
    // MARK: Custom
    private func configureConstraints() {
        view.addSubview(forecastListView)
        forecastListView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
        forecastListView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        forecastListView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        forecastListView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        forecastListView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }

    private func convertAddress(from location: CLLocation) {
        let geocoder: CLGeocoder = .init()
        geocoder.reverseGeocodeLocation(location) { placemark, error in
            if error != nil {
                return
            }

            guard let placemark: CLPlacemark = placemark?.first, let administrativeArea: String = placemark.administrativeArea, let locality: String = placemark.locality else {
                return
            }

            self.currentAddress = "\(administrativeArea) \(locality)"
        }
    }

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()

        forecastListView.delegate = self
        forecastListView.dataSource = self
        configureConstraints()
    }
}

// MARK: - Extensions
// MARK: Core Location
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation: CLLocation = locations.last else { return }

        let latitude: String = .init(currentLocation.coordinate.latitude)
        let longitude: String = .init(currentLocation.coordinate.longitude)
        let currentCoordinate: CurrentLocation = (latitude, longitude)
        convertAddress(from: currentLocation)

        dataTaskManager.fetchWeatherData(on: currentCoordinate, type: .current) { [weak self] (result: Result<CurrentWeather, ErrorHandler>) in
            switch result {
                case .success(let data):
                    self?.currentWeatherData = data
                    DispatchQueue.main.async {
                        self?.forecastListView.reloadSections(IndexSet.init(integer: 0), with: .none)
                    }
                case .failure:
                    ErrorHandler.SystemError(type: .invalidData)
            }
        }

        dataTaskManager.fetchWeatherData(on: currentCoordinate, type: .forecast) { [weak self] (result: Result<ForecastList, ErrorHandler>) in
            switch result {
                case .success(let data):
                    self?.forecastListData = data
                    DispatchQueue.main.async {
                        self?.forecastListView.reloadSections(IndexSet.init(integer: 1), with: .none)
                    }
                case .failure:
                    ErrorHandler.SystemError(type: .invalidData)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
}

// MARK: Table View
extension ViewController: UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableView.estimateRowHeight(of: indexPath.section)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return ForecastType.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }

        guard let forecastListData: ForecastList = forecastListData else {
            return 0
        }

        return forecastListData.list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let currentWeatherCell: CurrentWeatherCell = .init()

            currentWeatherCell.configureCell(with: currentWeatherData, at: currentAddress)
            return currentWeatherCell
        }

        guard let forecastListCell: ForecastListCell = tableView.dequeueReusableCell(withIdentifier: ForecastListCell.identifier) as? ForecastListCell else {
            return UITableViewCell()
        }

        forecastListCell.configureCell(with: forecastListData, indexPath: indexPath)
        return forecastListCell
    }
}
