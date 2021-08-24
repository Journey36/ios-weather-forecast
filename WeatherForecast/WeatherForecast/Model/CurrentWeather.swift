//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Journey36 on 2021/08/24.
//

import Foundation

struct CurrentWeather: Decodable {
    let weather: [Weather]
    let temperature: Temperature
    let city: String

    enum CodingKeys: String, CodingKey {
        case weather
        case temperature = "main"
        case city = "name"
    }
}
