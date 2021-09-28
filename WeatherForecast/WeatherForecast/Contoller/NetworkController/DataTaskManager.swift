//
//  DataTaskManager.swift
//  WeatherForecast
//
//  Created by Journey36 on 2021/09/07.
//

import Foundation

struct DataTaskManager {
    let session: URLSession = .shared
    
    func fetchWeatherData<T: Decodable>(on coordinates: CurrentLocation, type: ForecastType, completion: @escaping (Result<T, ErrorHandler>) -> Void) {
        guard let apiURL: URL = try? URLManager.setURL(coordinates, with: type) else {
            return completion(.failure(.SystemError(type: .invalidURL)))
        }
        
        session.dataTask(with: apiURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if let _: Error = error {
                return completion(.failure(.SystemError(type: .unableToComplete)))
            }
            
            guard let response: HTTPURLResponse = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                return completion(.failure(.SystemError(type:  .invalidResponse)))
            }
            
            guard let data: Data = data else {
                return completion(.failure(.SystemError(type: .invalidData)))
            }
            
            do {
                let decoder: JSONDecoder = .init()
                let currentWeatherData: T = try decoder.decode(T.self, from: data)
                return completion(.success(currentWeatherData))
            } catch {
                completion(.failure(.SystemError(type: .invalidData)))
            }
            
        }.resume()
    }
}
