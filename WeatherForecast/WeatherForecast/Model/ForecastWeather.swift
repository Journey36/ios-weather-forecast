//
//  ForecastWeather.swift
//  WeatherForecast
//
//  Created by Journey36 on 2021/08/24.
//

import Foundation

struct ForecastWeather: Decodable {
    let temperature: Temperature
    let weather: [Weather]
    let timestamp: String

    enum CodingKeys: String, CodingKey {
        case temperature = "main"
        case weather
        case timestamp = "dt_txt"
    }
}
