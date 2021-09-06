//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/01/19.
//

import Foundation
import CoreLocation

struct CurrentWeatherData: Decodable {
    let coordinate: CLLocationCoordinate2D
    private let weathers: [Weather]
    var weather: Weather? {
        return weathers.first
    }
    let temperature: Temperature
    let utc: Int
    let cityID: Int
    let cityName: String
    
    enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case weathers = "weather"
        case temperature = "main"
        case utc = "dt"
        case cityID = "id"
        case cityName = "name"
    }
}
