//
//  ForecastList.swift
//  WeatherForecast
//
//  Created by Journey36 on 2021/08/24.
//

import Foundation

struct ForecastList: Decodable {
    let list: [ForecastWeather]
    let count: Int

    enum CodingKeys: String, CodingKey {
        case list
        case count = "cnt"
    }
}
