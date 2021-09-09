//
//  DataTask.swift
//  DataTask
//
//  Created by Journey36 on 2021/08/27.
//

import Foundation
import CoreLocation

enum URLManager {
    private static let baseURL: String = "http://api.openweathermap.org/data/2.5/"
    private static let appID: String = "799620b941986e2acc5aa451c0f3b1d5"
    private static let units: String = "metric"

    static func setURL(_ coordinates: CurrentLocation, with type: ForecastType) -> URL? {
        var components: URLComponents? = .init(string: baseURL)
        components?.path += type.rawValue

        let latitude: URLQueryItem = .init(name: "lat", value: coordinates.latitude)
        let longitude: URLQueryItem = .init(name: "lon", value: coordinates.longitude)
        let units: URLQueryItem = .init(name: "units", value: units)
        let appID: URLQueryItem = .init(name: "appid", value: appID)
        components?.queryItems = [latitude, longitude, units, appID]
        return components?.url
    }
}
