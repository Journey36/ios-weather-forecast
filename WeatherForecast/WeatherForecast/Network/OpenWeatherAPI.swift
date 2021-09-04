//
//  OpenWeatherAPI.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/09/03.
//

import Foundation

//enum OpenWeatherError: Int, Error {
//    // 에러 구분 이유 설명
//    case invalidURL
//    case requestFailed
//    case clientError
//    case serverError
//    case unknownResponse
//    case jsonError
//}
//
//struct OpenWeatherAPI {
//    private var urlBase = "api.openweathermap.org/data/2.5/"
//    private var apiKey = "d581ffc8458e8085899bfe16c04fe7da"
//    var urlPostfix: String
//    //var coordinate: Coordinate
////    private var queryItems: [URLQueryItem] {
////        [
////            URLQueryItem(name: "lat", value: "\(coordinate.latitude)"),
////            URLQueryItem(name: "lon", value: "\(coordinate.longitude)"),
////            URLQueryItem(name: "appid", value: apiKey)
////        ]
////    }
//    
//    func request(coordinate: Coordinate, completionHandler: @escaping (Result<CurrentWeatherData, APIClientError>) -> Void) {
//        
//    }
//}
//
//extension OpenWeatherAPI {
//    static let currentWeather = OpenWeatherAPI(urlPostfix: "weather")
//}
//
//OpenWeatherAPI
