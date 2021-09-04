//
//  APIClient.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/08/27.
//

import Foundation

enum APIClientError: Error {
    case unknown
    case invalidURL
    case requestFailed
    case clientError
    case serverError
    case unknownResponse
    case jsonError
}

struct APIClient<ResponseData: Decodable> {
    let baseURL: String
    let queryItems: [URLQueryItem]?
    
    private var url: URL? {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = queryItems
        return urlComponents?.url
    }
    
    init(baseURL: String, queryItems: [URLQueryItem]? = nil) {
        self.baseURL = baseURL
        self.queryItems = queryItems
    }
    
    private func decodeData(from: Data) -> ResponseData? {
        return try? JSONDecoder().decode(ResponseData.self, from: from)
    }
    
    private func checkResponse(with statusCode: Int) throws {
        switch statusCode {
        case 200...299:
            break // success
        case 400...499:
            throw APIClientError.clientError
        case 500...599:
            throw APIClientError.serverError
        default:
            throw APIClientError.unknownResponse
        }
    }
    
    func request(completionHandler: @escaping (Result<ResponseData, APIClientError>) -> Void) {
        guard let url = url else {
            completionHandler(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse,
                  error == nil else {
                completionHandler(.failure(.requestFailed))
                return
            }
            
            do {
                try checkResponse(with: httpResponse.statusCode)
            } catch let apiClientError as APIClientError {
                completionHandler(.failure(apiClientError))
                return
            } catch {
                completionHandler(.failure(.unknown))
                return
            }
                        
            if let decodedData = decodeData(from: data) {
                completionHandler(.success(decodedData))
            } else {
                completionHandler(.failure(.jsonError))
            }
        }
        task.resume()
    }
}
