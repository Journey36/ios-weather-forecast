//
//  WeatherForecast.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/01/19.
//

import Foundation

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
        let utc: Int
        let temperature: Temperature
        private let weathers: [Weather]
        var weather: Weather? {
            return weathers.first
        }
        let dateTimeString: String
        
        enum CodingKeys: String, CodingKey {
            case utc = "dt"
            case temperature = "main"
            case weathers = "weather"
            case dateTimeString = "dt_txt"
        }
    }
    
    struct City: Decodable {
        let id: Int
        let name: String
        let coordinate: Coordinate
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case coordinate = "coord"
        }
    }
}
