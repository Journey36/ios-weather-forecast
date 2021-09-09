//
//  WeatherForecastDataSource.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/09/06.
//

import UIKit
import CoreLocation

class WeatherForecastDataSource: NSObject {
//    let sampleData: [(date: String, temperature: String)] = [
//        ("12/03(월) 00시", "1.9"),
//        ("12/03(월) 03시", "2.0"),
//        ("12/03(월) 06시", "3.8"),
//        ("12/03(월) 09시", "3.8"),
//        ("12/03(월) 12시", "11.5"),
//        ("12/03(월) 15시", "12.9"),
//        ("12/03(월) 18시", "5.6"),
//        ("12/03(월) 21시", "0.5"),
//        ("12/04(화) 00시", "1.9"),
//        ("12/04(화) 03시", "2.0"),
//        ("12/04(화) 06시", "3.8"),
//        ("12/04(화) 09시", "3.8"),
//        ("12/04(화) 12시", "11.5"),
//        ("12/04(화) 15시", "12.9"),
//        ("12/04(화) 18시", "5.6"),
//        ("12/04(화) 21시", "0.5"),
//    ]
    typealias FiveDayForecastUpdatedAction = () -> Void
    
    private lazy var locationManager: LocationManager = {
        let locationManager = LocationManager(locationUpdatedAction: { location in
            self.findCurrentAddress(by: location)
            
            OpenWeatherAPIConstatns.currentWeatherAPI.request(by: location.coordinate) { result in
                switch result {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    print(error)
                }
            }
            
            self.requestFiveDayForecastData(by: location.coordinate)
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
    
    private var fiveDayforecastItems: [FiveDayForecastData.Item] = []
    private var fiveDayForecastUpdatedAction: FiveDayForecastUpdatedAction?
    
    func registerCells(with tableView: UITableView) {
        tableView.register(FiveDayForecastCell.self, forCellReuseIdentifier: FiveDayForecastCell.identifier)
    }
    
    init(fiveDayForecastUpdatedAction: @escaping FiveDayForecastUpdatedAction) {
        self.fiveDayForecastUpdatedAction = fiveDayForecastUpdatedAction
        super.init()
        locationManager.requestLocation()
    }
    
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

extension WeatherForecastDataSource {
    private func requestFiveDayForecastData(by coordinate: CLLocationCoordinate2D) {
        OpenWeatherAPIConstatns.fiveDayForecastAPI.request(by: coordinate) { result in
            switch result {
            case .success(let data):
                //print(data)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fiveDayforecastItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FiveDayForecastCell.identifier, for: indexPath) as? FiveDayForecastCell else {
            fatalError("Unable to dequeue \(FiveDayForecastCell.self)")
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

extension FiveDayForecastData.Item {
    static private let DateAndTimeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "MM/dd(E) HH시"
        return dateFormatter
    }()
    
    private var date: Date {
        return Date(timeIntervalSince1970: TimeInterval(utcUnix))
    }
    
    var dateAndTimeText: String {
        return Self.DateAndTimeFormatter.string(from: date)
    }
}

extension Temperature {
    var currentCelsiusText: String {
        return String(format: "%.1fº", currentCelsius)
    }
}

extension Weather {
    var iconURL: String {
        return OpenWeatherAPIConstatns.weatherIconBaseURL + "\(iconID).png"
    }
}
