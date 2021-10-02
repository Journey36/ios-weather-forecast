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
    
    func configureRefreshControl() {
        let refresh: UIRefreshControl = .init()
        refresh.addTarget(self, action: #selector(updateUI(_:)), for: .valueChanged)
        forecastListView.refreshControl = refresh
    }
    
    @objc func updateUI(_ refreshCotnrol: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.manager.startUpdatingLocation()
            self.forecastListView.reloadData()
            self.manager.stopUpdatingLocation()
            refreshCotnrol.endRefreshing()
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
                print(ErrorHandler.SystemError(type: .invalidData))
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
                print (ErrorHandler.SystemError(type: .invalidData))
            }
        }
    }
    
    @available(iOS 14, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .denied, .notDetermined, .restricted:
            // TODO: 설정창 열어줌
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .denied, .notDetermined, .restricted:
            // TODO: 설정창 열어줌
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        switch error {
        case CLError.denied:
            // TODO: 설정 열어서 변경하도록 권유
            print(ErrorHandler.UserError(type: .locationServiceRefusal))
        default:
            // TODO: 재시도 하거나 다른 기타 처리 필요
            manager.stopUpdatingLocation()
        }
    }
}

// MARK: Table View
extension ViewController: UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableView.estimateRowHeight(of: indexPath.section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ForecastType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : forecastListData?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let currentWeatherCell: CurrentWeatherCell = .init()
            currentWeatherCell.configureCell(with: currentWeatherData, at: currentAddress)
            if let weatherIcon: [Weather] = currentWeatherData?.weather, let imageID: String = weatherIcon.first?.icon {
                dataTaskManager.fetchWeatherIcon(imageID) { (result: Result<UIImage, ErrorHandler>) in
                    switch result {
                    case .success(let data):
                        DispatchQueue.main.async {
                            currentWeatherCell.weatherIconImageView.image = data
                        }
                    case .failure:
                        print(ErrorHandler.SystemError(type: .invalidData))
                    }
                }
            }

            return currentWeatherCell
        }
        
        guard let forecastListCell: ForecastListCell = tableView.dequeueReusableCell(withIdentifier: ForecastListCell.identifier) as? ForecastListCell else {
            return UITableViewCell()
        }
        
        forecastListCell.configureCell(with: forecastListData, indexPath: indexPath)
        if let weatherIcons: [Weather] = forecastListData?.list[indexPath.row].weather, let imageID: String = weatherIcons.first?.icon {
            dataTaskManager.fetchWeatherIcon(imageID) { (result: Result<UIImage, ErrorHandler>) in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        forecastListCell.weatherIconImageView.image = data
                    }
                case .failure:
                    print(ErrorHandler.SystemError(type: .invalidData))
                }
            }
        }
        return forecastListCell
    }
}
