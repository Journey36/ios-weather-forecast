//
//  CurrentWeatherInformation.swift
//  WeatherForecast
//
//  Created by iluxsm on 2021/01/19.
//

import Foundation

struct CurrentWeather: Decodable {
    let city: String
    let temperature: Temperature
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case city = "name"
        case temperature = "main"
        case weather
    }
}
