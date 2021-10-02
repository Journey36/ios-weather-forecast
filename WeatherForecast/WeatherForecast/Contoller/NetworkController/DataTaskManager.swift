//
//  DataTaskManager.swift
//  WeatherForecast
//
//  Created by Journey36 on 2021/09/07.
//

import UIKit

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
                // FIXME: 네이밍 변경 요망
                let currentWeatherData: T = try decoder.decode(T.self, from: data)
                return completion(.success(currentWeatherData))
            } catch {
                completion(.failure(.SystemError(type: .invalidData)))
            }
            
        }.resume()
    }

    func fetchWeatherIcon(_ imageID: String, completion: @escaping (Result<UIImage, ErrorHandler>) -> Void) {
        guard let targetURL: URL = try? URLManager.setImageURL(of: imageID) else {
            // TODO: 에러 핸들링
            return
        }

        session.dataTask(with: targetURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if let _: Error = error {
                return
            }

            guard let response: HTTPURLResponse = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                return
            }

            guard let data: Data = data, let iconImage: UIImage = .init(data: data) else {
                return
            }
            
            return completion(.success(iconImage))
        }.resume()
    }
}
