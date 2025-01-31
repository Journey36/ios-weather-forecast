//
//  ForecastListViewController.swift
//  WeatherForecast
//
//  Created by Journey36 on 2021/09/06.
//

import UIKit
import CoreLocation

final class ViewController: UIViewController {
    // MARK: - Properties -
    // MARK: Stored Properties
    private let manager: CLLocationManager = .init()
    private let dataTaskManager: DataTaskManager = .init()
    private var currentWeatherData: CurrentWeather?
    private var forecastListData: ForecastList?
    private var currentAddress: String?
    private lazy var forecastListView: ForecastListView = .init()
    private let refreshControl: UIRefreshControl = .init()
    
    // MARK: - Methods -
    // MARK: Custom
    private func configureConstraints() {
        view.addSubview(forecastListView)
        forecastListView.translatesAutoresizingMaskIntoConstraints = false
        forecastListView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        forecastListView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        forecastListView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        forecastListView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func convertAddress(from location: CLLocation) {
        let geocoder: CLGeocoder = .init()
        let locale: Locale = .init(identifier: "ko_KR")
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { placemark, error in
            if error != nil {
                return
            }
            
            guard let placemark: CLPlacemark = placemark?.first, let administrativeArea: String = placemark.administrativeArea else {
                return
            }
            
            if let locality: String = placemark.locality {
                self.currentAddress = "\(administrativeArea) \(locality)"
            } else {
                self.currentAddress = "\(administrativeArea)"
            }
        }
    }
    
    private func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(updateUI), for: .valueChanged)
        forecastListView.refreshControl = refreshControl
    }
    
    @objc func updateUI() {
        manager.startUpdatingLocation()
        DispatchQueue.main.async {
            self.forecastListView.reloadData()
        }
    }

    func finishRefreshing() {
        if forecastListView.refreshControl?.isRefreshing == true {
            manager.stopUpdatingLocation()
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.requestWhenInUseAuthorization()
        
        forecastListView.delegate = self
        forecastListView.dataSource = self
        configureConstraints()
        configureRefreshControl()
    }
}

// MARK: - Extensions -
// MARK: Core Location
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation: CLLocation = locations.last else { return }
        
        let latitude: String = .init(currentLocation.coordinate.latitude)
        let longitude: String = .init(currentLocation.coordinate.longitude)
        let currentCoordinate: CurrentLocation = (latitude, longitude)
        convertAddress(from: currentLocation)
        
        dataTaskManager.fetchWeatherData(on: currentCoordinate, type: .current) { [weak self] (result: Result<CurrentWeather, ErrorTransactor>) in
            switch result {
            case .success(let data):
                self?.currentWeatherData = data
                DispatchQueue.main.async {
                    self?.forecastListView.reloadSections(IndexSet(integer: 0), with: .none)
                }
            case .failure:
                print(ErrorTransactor.networkError(.dataFetchingFailure))
            }
        }
        
        dataTaskManager.fetchWeatherData(on: currentCoordinate, type: .forecast) { [weak self] (result: Result<ForecastList, ErrorTransactor>) in
            switch result {
            case .success(let data):
                self?.forecastListData = data
                DispatchQueue.main.async {
                    self?.forecastListView.reloadSections(IndexSet(integer: 1), with: .none)
                }
            case .failure:
                print(ErrorTransactor.networkError(.dataFetchingFailure))
            }
        }

    finishRefreshing()
    }

    @available(iOS 14, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .denied, .restricted:
            presentAlert(.locationSevicesRefusal)
            break
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .denied, .restricted:
            presentAlert(.locationSevicesRefusal)
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        switch error {
        case CLError.denied:
            presentAlert(.locationSevicesRefusal)
        default:
            manager.stopUpdatingLocation()
        }
    }
}

// MARK: Table View
extension ViewController: UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return ForecastType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : forecastListData?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let currentWeatherCell: CurrentWeatherCell = tableView.dequeueReusableCell(withIdentifier: CurrentWeatherCell.identifier, for: indexPath) as? CurrentWeatherCell else {
                return UITableViewCell()
            }

            currentWeatherCell.configureCell(with: currentWeatherData, at: currentAddress)
            if let weatherIcon: [Weather] = currentWeatherData?.weather, let imageID: String = weatherIcon.first?.icon {
                dataTaskManager.fetchWeatherIcon(imageID) { (result: Result<UIImage, ErrorTransactor>) in
                    switch result {
                    case .success(let data):
                        DispatchQueue.main.async {
                            currentWeatherCell.weatherIconImageView.image = data
                        }
                    case .failure:
                        print(ErrorTransactor.networkError(.dataFetchingFailure))
                    }
                }
            }

            return currentWeatherCell
        }
        
        guard let forecastListCell: ForecastListCell = tableView.dequeueReusableCell(withIdentifier: ForecastListCell.identifier, for: indexPath) as? ForecastListCell else {
            return UITableViewCell()
        }
        
        forecastListCell.configureCell(with: forecastListData, indexPath: indexPath)
        if let weatherIcons: [Weather] = forecastListData?.list[indexPath.row].weather, let imageID: String = weatherIcons.first?.icon {
            dataTaskManager.fetchWeatherIcon(imageID) { (result: Result<UIImage, ErrorTransactor>) in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        forecastListCell.weatherIconImageView.image = data
                    }
                case .failure:
                    print(ErrorTransactor.networkError(.dataFetchingFailure))
                }
            }
        }
        return forecastListCell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
}
