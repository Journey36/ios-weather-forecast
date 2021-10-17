//
//  WeatherForecastDataSource.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/09/06.
//

import UIKit
import CoreLocation

class WeatherForecastDataSource: NSObject {
    typealias DataLoadedAction = () -> Void
    typealias DataRequestFailedAction = () -> Void
    
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
    
    private var dataLoadedAction: DataLoadedAction?
    private var dataRequestFailedAction: DataRequestFailedAction?

    
    private var currentAddress: Address?
    private var isCurrentAddressDataRequestFailed: Bool? = nil
    private var isCurrentAddressDataLoaded: Bool {
        return currentAddress != nil
    }
    private var currentWeatherData: CurrentWeatherData?
    private var isCurrentWeatherDataRequestFailed: Bool? = nil
    private var isCurrentWeatherDataLoaded: Bool {
        return currentWeatherData != nil
    }
    
    private var fiveDayforecastItems: [FiveDayForecastData.Item] = []
    private var isFiveDayForecastDataRequestFailed: Bool? = nil
    private var isFiveDayForecastDataLoaded: Bool {
        return !fiveDayforecastItems.isEmpty
    }
    
    private var isAlldataLoaded: Bool {
        return isCurrentAddressDataLoaded && isCurrentWeatherDataLoaded && isFiveDayForecastDataLoaded
    }
    private var isAnyDataRequestFailed: Bool {
        guard let isCurrentAddressDataRequestFailed = isCurrentAddressDataRequestFailed,
              let isCurrentWeatherDataRequestFailed = isCurrentWeatherDataRequestFailed,
              let isFiveDayForecastDataRequestFailed = isFiveDayForecastDataRequestFailed else {
            return false
        }
        
        return isCurrentAddressDataRequestFailed || isCurrentWeatherDataRequestFailed || isFiveDayForecastDataRequestFailed
    }
    
    func registerCells(with tableView: UITableView) {
        tableView.register(CurrentWeatherCell.self, forCellReuseIdentifier: CurrentWeatherCell.identifier)
        tableView.register(FiveDayForecastCell.self, forCellReuseIdentifier: FiveDayForecastCell.identifier)
    }
    
    init(dataLoadedAction: @escaping DataLoadedAction, dataRequestFailedAction: @escaping DataRequestFailedAction) {
        self.dataLoadedAction = dataLoadedAction
        self.dataRequestFailedAction = dataRequestFailedAction
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
              isAlldataLoaded else {
            return 0
        }

        switch section {
        case .currentWeather:
            return 1
        case .fiveDayForecast:
            return fiveDayforecastItems.count
        }
    }
}

extension WeatherForecastDataSource {
    func requestAllData(by location: CLLocation) {
        requestCurrentAddress(by: location)
        requestCurrentWeatehrData(by: location.coordinate)
        requestFiveDayForecastData(by: location.coordinate)
    }
    
    private func requestCurrentAddress(by location: CLLocation) {
        isCurrentAddressDataRequestFailed = nil
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let errorCode = error {
                print(#function, errorCode)
                self.isCurrentAddressDataRequestFailed = true
                if self.isAnyDataRequestFailed {
                    self.dataRequestFailedAction?()
                }
                return
            }
            guard let administrativeArea = placemarks?.first?.administrativeArea,
                  let locality = placemarks?.first?.locality else {
                return
            }
            self.currentAddress = Address(administrativeArea: administrativeArea, locality: locality)
            self.isCurrentAddressDataRequestFailed = false
            if self.isAlldataLoaded {
                self.dataLoadedAction?()
            }
        }
    }
        
    private func requestCurrentWeatehrData(by coordinate: CLLocationCoordinate2D) {
        isCurrentWeatherDataRequestFailed = nil
        
        OpenWeatherAPIConstatns.currentWeatherAPI.request(by: coordinate) { result in
            switch result {
            case .success(let data):
                self.currentWeatherData = data
                self.isCurrentWeatherDataRequestFailed = false
                if self.isAlldataLoaded {
                    self.dataLoadedAction?()
                }
            case .failure(let error):
                print(#function, error)
                self.isCurrentWeatherDataRequestFailed = true
                if self.isAnyDataRequestFailed {
                    self.dataRequestFailedAction?()
                }
            }
        }
    }
    
    private func requestFiveDayForecastData(by coordinate: CLLocationCoordinate2D) {
        isFiveDayForecastDataRequestFailed = nil
        
        OpenWeatherAPIConstatns.fiveDayForecastAPI.request(by: coordinate) { result in
            switch result {
            case .success(let data):
                self.fiveDayforecastItems = data.items
                self.isFiveDayForecastDataRequestFailed = false
                if self.isAlldataLoaded {
                    self.dataLoadedAction?()
                }
            case .failure(let error):
                print(#function, error)
                self.isFiveDayForecastDataRequestFailed = true
                if self.isAnyDataRequestFailed {
                    self.dataRequestFailedAction?()
                }
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
