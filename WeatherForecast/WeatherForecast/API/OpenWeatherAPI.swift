//
//  CurrentWeatherAPI.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/01/24.
//

import Foundation

struct OpenWeatherAPI<ResponseData: Decodable> {
    var baseURL: String
    var apiKey: String
    var units: Units?
    var language: Language?
    var count: Int?
    
    enum Units {
        case standard
        case metric
        case imperial
        
        func queryItem() -> URLQueryItem {
            return URLQueryItem(name: "units", value: "\(self)")
        }
    }
    
    enum Language: String {
        case english = "en"
        case german = "de"
        case korean = "kr"
        case japanese = "ja"
        
        func queryItem() -> URLQueryItem {
            return URLQueryItem(name: "lang", value: "\(self.rawValue)")
        }
    }
    
    private func queryItems(coordinate: Coordinate) -> [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        queryItems += [URLQueryItem(name: "lat", value: "\(coordinate.latitude)"),
                       URLQueryItem(name: "lon", value: "\(coordinate.longitude)"),
                       URLQueryItem(name: "appid", value: apiKey),]
        if let units = units {
            queryItems.append(units.queryItem())
        }
        if let language = language {
            queryItems.append(language.queryItem())
        }
        if let count = count {
            queryItems.append(URLQueryItem(name: "cnt", value: "\(count)"))
        }
        return queryItems
    }
  
    func request(coordinate: Coordinate, completionHandler: @escaping (Result<ResponseData, APIClientError>) -> Void) {
        let queryItems = queryItems(coordinate: coordinate)
        let apiClient = APIClient<ResponseData>(baseURL: baseURL, queryItems: queryItems)
        apiClient.request() { result in
            switch result {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}


