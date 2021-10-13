//
//  DataTaskManager.swift
//  WeatherForecast
//
//  Created by Journey36 on 2021/09/07.
//

import UIKit

struct DataTaskManager {
    private let session: URLSession = .shared
    
    func fetchWeatherData<T: Decodable>(on coordinates: CurrentLocation, type: ForecastType, completion: @escaping (Result<T, ErrorTransactor.NetworkError>) -> Void) {
        guard let apiURL: URL = try? URLManager.setURL(coordinates, with: type) else {
            return
        }
        
        session.dataTask(with: apiURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if let _: Error = error {
                completion(.failure(ErrorTransactor.NetworkError.invalidURL))
            }
            
            guard let response: HTTPURLResponse = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                return completion(.failure(ErrorTransactor.NetworkError.unexpactableResponse))
            }
            
            guard let data: Data = data else {
                return completion(.failure(ErrorTransactor.NetworkError.dataFetchingFailure))
            }
            
            do {
                let decoder: JSONDecoder = .init()
                let weatherData: T = try decoder.decode(T.self, from: data)
                completion(.success(weatherData))
            } catch {
                completion(.failure(.dataFetchingFailure))
            }
            
        }.resume()
    }

    func fetchWeatherIcon(_ imageID: String, completion: @escaping (Result<UIImage, ErrorTransactor.NetworkError>) -> Void) {
        guard let targetURL: URL = try? URLManager.setImageURL(of: imageID) else {
            return
        }

        session.dataTask(with: targetURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if let _: Error = error {
                completion(.failure(ErrorTransactor.NetworkError.invalidURL))
            }

            guard let response: HTTPURLResponse = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                return completion(.failure(ErrorTransactor.NetworkError.unexpactableResponse))
            }

            guard let data: Data = data, let iconImage: UIImage = .init(data: data) else {
                return completion(.failure(ErrorTransactor.NetworkError.dataFetchingFailure))
            }
            
            return completion(.success(iconImage))
        }.resume()
    }
}
