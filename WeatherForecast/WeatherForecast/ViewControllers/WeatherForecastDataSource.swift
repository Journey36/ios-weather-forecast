//
//  WeatherForecastDataSource.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/09/06.
//

import UIKit
import CoreLocation

class WeatherForecastDataSource: NSObject {
    typealias CurrentWeahterUpdatedAction = () -> Void
    typealias FiveDayForecastUpdatedAction = () -> Void
    
    enum WeathrForecastSection: Int, CaseIterable {
        case currentWeather
        case fiveDayForecast
        
        var cellIdentifier: String {
            switch self {
            case .currentWeather:
                return CurrentWeatherCell.identifier
            case .fiveDayForecast:
                return FiveDayForecastCell.identifier
            }
        }
    }
    
//    private lazy var locationManager: LocationManager = {
//        let locationManager = LocationManager(locationUpdatedAction: { location in
//            self.requestAllData(by: location)
//        })
//        locationManager.requestAuthorization()
//
//        return locationManager
//    }()
    
    private var currentAddress: Address?
    private var fiveDayforecastItems: [FiveDayForecastData.Item] = []
    private var fiveDayForecastUpdatedAction: FiveDayForecastUpdatedAction?
    private var currentWeatherData: CurrentWeatherData?
    private var currentWeatherUpdatedAction: CurrentWeahterUpdatedAction?
    
    func registerCells(with tableView: UITableView) {
        tableView.register(CurrentWeatherCell.self, forCellReuseIdentifier: CurrentWeatherCell.identifier)
        tableView.register(FiveDayForecastCell.self, forCellReuseIdentifier: FiveDayForecastCell.identifier)
    }
    
    init(currentWeatherUpdatedAction: @escaping CurrentWeahterUpdatedAction,
         fiveDayForecastUpdatedAction: @escaping FiveDayForecastUpdatedAction) {
        self.currentWeatherUpdatedAction = currentWeatherUpdatedAction
        self.fiveDayForecastUpdatedAction = fiveDayForecastUpdatedAction
        super.init()
    }
    
    
    
    private func dequeueAndConfigureCell(for indexPath: IndexPath, from tableView: UITableView) -> UITableViewCell {
        guard let section = WeathrForecastSection(rawValue: indexPath.section) else {
            fatalError("Section index out of range")
        }
        let identifier = section.cellIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        switch section {
        case .currentWeather:
            guard let cell = cell as? CurrentWeatherCell else {
                fatalError("Fail cast CurrentWeatherCell")
            }
            guard let data = currentWeatherData else {
                fatalError("Fail currentWeatherData")
            }
            guard let addressText = currentAddress?.text else {
                fatalError("Fail addressText")
            }
            
            cell.configure(addressText: addressText,
                           minAndMaxTemperatureText: data.temperature.minAndMaxCelsiusText,
                           currentTemperatureText: data.temperature.currentCelsiusText)
            ImageLoader(url: data.weather.icon2xURL).load() { result in
                switch result {
                case .success(let image):
                    if tableView.indexPath(for: cell)?.row == indexPath.row {
                        cell.configure(iconImage: image)
                    }
                case .failure(let error):
                    print(error)
                }
            }
            return cell
        case .fiveDayForecast:
            guard let cell = cell as? FiveDayForecastCell else {
                fatalError("Fail cast FiveDayForecastCell")
            }
            let item = fiveDayforecastItems[indexPath.row]
            cell.configure(dateAndTimeText: item.dateAndTimeText, temperatureText: item.temperature.currentCelsiusText)
            
            ImageLoader(url: item.weather.iconURL).load() { result in
                switch result {
                case .success(let image):
                    if tableView.indexPath(for: cell)?.row == indexPath.row {
                        cell.configure(iconImage: image)
                    }
                case .failure(let error):
                    print(error)
                }
            }
            return cell
        }
    }
    
    private func numberOfRows(in section: Int) -> Int {
        guard let section = WeathrForecastSection(rawValue: section),
              let _ = currentAddress else {
            return 0
        }
        
        switch section {
        case .currentWeather:
            return currentWeatherData == nil ? 0 : 1
        case .fiveDayForecast:
            return fiveDayforecastItems.count
        }
    }
    
    func removeAllData() {
        currentAddress = nil
        currentWeatherData = nil
        fiveDayforecastItems.removeAll()
    }
}

extension WeatherForecastDataSource {
    func requestAllData(by location: CLLocation) {
        self.requestCurrentAddress(by: location)
        self.requestCurrentWeatehrData(by: location.coordinate)
        self.requestFiveDayForecastData(by: location.coordinate)
    }
    
    private func requestCurrentAddress(by location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let errorCode = error {
                print(errorCode)
                return
            }
            if let administrativeArea = placemarks?.first?.administrativeArea,
               let locality = placemarks?.first?.locality {
                self.currentAddress = Address(administrativeArea: administrativeArea, locality: locality)
            }
        }
    }
    
    private func requestCurrentWeatehrData(by coordinate: CLLocationCoordinate2D) {
        OpenWeatherAPIConstatns.currentWeatherAPI.request(by: coordinate) { result in
            switch result {
            case .success(let data):
                self.currentWeatherData = data
                self.currentWeatherUpdatedAction?()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func requestFiveDayForecastData(by coordinate: CLLocationCoordinate2D) {
        OpenWeatherAPIConstatns.fiveDayForecastAPI.request(by: coordinate) { result in
            switch result {
            case .success(let data):
                self.fiveDayforecastItems = data.items
                self.fiveDayForecastUpdatedAction?()
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension WeatherForecastDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return WeathrForecastSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dequeueAndConfigureCell(for: indexPath, from: tableView)
    }
}

// MARK: - Model Extensions

private extension FiveDayForecastData.Item {
    static private let DateAndTimeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "MM/dd (E) HH시"
        return dateFormatter
    }()
    
    private var date: Date {
        return Date(timeIntervalSince1970: TimeInterval(utcUnix))
    }
    
    var dateAndTimeText: String {
        return Self.DateAndTimeFormatter.string(from: date)
    }
}

private extension Temperature {
    var currentCelsiusText: String {
        return celsiusText(from: currentCelsius)
    }
    
    var minAndMaxCelsiusText: String {
        let min = celsiusText(from: minimumCelsius)
        let max = celsiusText(from: maximumCelsius)
        return "최저 \(min) 최고 \(max)"
    }
    
    private func celsiusText(from celsius: Double) -> String {
        return String(format: "%.1fº", celsius)
    }
}

private extension Weather {
    var iconURL: String {
        return OpenWeatherAPIConstatns.weatherIconBaseURL + "\(iconID).png"
    }
    
    var icon2xURL: String {
        return OpenWeatherAPIConstatns.weatherIconBaseURL + "\(iconID)@2x.png"
    }
}

private extension Address {
    var text: String {
        return administrativeArea + " " + locality
    }
}
