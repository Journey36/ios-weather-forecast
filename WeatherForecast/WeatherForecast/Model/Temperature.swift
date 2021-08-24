//
//  Temperature.swift
//  WeatherForecast
//
//  Created by Journey36 on 2021/08/24.
//

import Foundation

struct Temperature: Decodable {
    let current: Double
    let maximum: Double
    let minimum: Double

    enum CodingKeys: String, CodingKey {
        case current = "temp"
        case minimum = "temp_min"
        case maximum = "temp_max"
    }
}
