//
//  DataTask.swift
//  DataTask
//
//  Created by Journey36 on 2021/08/27.
//

import Foundation

enum URLManager {
    private static let baseAPIURL: String = "http://api.openweathermap.org/data/2.5/"
    private static let baseIconURL: String = "https://openweathermap.org/img/wn/"
    private static let appID = Bundle.main.infoDictionary?["API_KEY"] as? String
    private static let units: String = "metric"
    
    static func setURL(_ coordinates: CurrentLocation, with type: ForecastType) throws -> URL? {
        guard let unwrappedAppID: String = appID else {
            throw ErrorHandler.SystemError(type: .invalidURL)
        }
        
        var components: URLComponents? = .init(string: baseAPIURL)
        components?.path += type.rawValue
        
        let latitude: URLQueryItem = .init(name: "lat", value: coordinates.latitude)
        let longitude: URLQueryItem = .init(name: "lon", value: coordinates.longitude)
        let units: URLQueryItem = .init(name: "units", value: units)
        let appID: URLQueryItem = .init(name: "appid", value: unwrappedAppID)
        components?.queryItems = [latitude, longitude, units, appID]
        return components?.url
    }

    static func setImageURL(of imageID: String) throws -> URL? {
        var components: URLComponents? = .init(string: baseIconURL)
        components?.path += "\(imageID)@2x.png"

        return components?.url
    }
}
