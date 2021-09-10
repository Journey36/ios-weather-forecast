//
//  WeatherForecast.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/01/19.
//

import Foundation
import CoreLocation

struct FiveDayForecastData: Decodable {
    let count: Int
    let items: [Item]
    let city: City
    
    enum CodingKeys: String, CodingKey {
        case count = "cnt"
        case items = "list"
        case city
    }
    
    struct Item: Decodable {
        let utcUnix: Int
        let temperature: Temperature
        private let weathers: [Weather]
        var weather: Weather {
            return weathers[0]
        }
        let utcText: String
        
        enum CodingKeys: String, CodingKey {
            case utcUnix = "dt"
            case temperature = "main"
            case weathers = "weather"
            case utcText = "dt_txt"
        }
    }
    
    struct City: Decodable {
        let id: Int
        let name: String
        let coordinate: CLLocationCoordinate2D
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case coordinate = "coord"
        }
    }
}


