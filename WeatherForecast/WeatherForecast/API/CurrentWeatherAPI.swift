//
//  CurrentWeatherAPI.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/01/24.
//

import Foundation
import CoreLocation

class CurrentWeatherAPI {
    enum APIError: Error {
        case invalidURL
        case requestFailed
        case noData
        case invalidData
    }
    
    static let shared: CurrentWeatherAPI = CurrentWeatherAPI()
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather?"
    private let apiKey = "d581ffc8458e8085899bfe16c04fe7da"
    private var urlSession = URLSession(configuration: .default)
    
    private init() {}
    
    func getData(coordinate: CLLocationCoordinate2D, completionHandler: @escaping (Result<CurrentWeatherData, APIError>) -> Void) {
        guard let url = URL(string: "\(baseURL)lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&units=metric&appid=\(apiKey)") else {
            completionHandler(.failure(.invalidURL))
            return
        }
        
        let dataTask = urlSession.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                completionHandler(.failure(.requestFailed))
                return
            }
            guard let data = data else {
                completionHandler(.failure(.noData))
                return
            }
            
            if let decodedData: CurrentWeatherData = try? JSONDecoder().decode(CurrentWeatherData.self, from: data) {
                completionHandler(.success(decodedData))
            } else {
                completionHandler(.failure(.invalidData))
            }
        }
        dataTask.resume()
    }
}
