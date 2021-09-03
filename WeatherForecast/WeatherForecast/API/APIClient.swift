//
//  APIClient.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/08/27.
//

import Foundation

enum APIClientError: Int, Error {
    // 에러 구분 이유 설명
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
    
    // 메서드로 분리하기 전이랑 코드 길이는 차이가 없지만, 디코딩 기능 자체를 분리함으로서 이후 JSON 디코딩 방법이 변경된다면 이 메서드만 수정하면 될 것이라 분리했다.
    private func decodeData(from: Data) -> ResponseData? {
        return try? JSONDecoder().decode(ResponseData.self, from: from)
    }
    
    func request(completionHandler: @escaping (Result<ResponseData, APIClientError>) -> Void) {
        guard let url = url else {
            completionHandler(.failure(.invalidURL))
            return
        }
        print(url)
        
        // 네트워크 요청은 분리하지 않았는데, 이 메서드 자체가 네트워크 요청이고 세부 에러를 컴플리션 핸들러로 처리해주기 위해 분리하지 않았다.
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse,
                  error == nil else {
                completionHandler(.failure(.requestFailed))
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                break // success
            case 400...499:
                completionHandler(.failure(.clientError))
                return
            case 500...599:
                completionHandler(.failure(.serverError))
                return
            default:
                completionHandler(.failure(.unknownResponse))
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
