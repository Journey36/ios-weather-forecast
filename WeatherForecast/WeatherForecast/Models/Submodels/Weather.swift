//
//  Weather.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/01/19.
//

import Foundation

struct Weather: Decodable {
    let conditionID: Int
    let group: String
    let iconID: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case conditionID = "id"
        case group = "main"
        case description
        case iconID = "icon"
    }
}
