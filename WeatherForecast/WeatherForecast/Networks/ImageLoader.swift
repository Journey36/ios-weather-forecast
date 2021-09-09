//
//  ImageLoader.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/09/09.
//

import UIKit

enum ImageLoaderError: Error {
    case unknown
    case invalidURL
}

struct ImageLoader {
    let url: String
    
    func load(completion: @escaping (Result<UIImage, ImageLoaderError>) -> Void) {
        // 0. URL 체크
        guard let url = URL(string: self.url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        // 1. 캐시에 이미지 있으면 가져오기
        let cacheKey = NSString(string: self.url)
        if let cachedImage = Self.imageCache.object(forKey: cacheKey) {
            DispatchQueue.main.async {
                completion(.success(cachedImage))
            }
            return
        }
        
        // 2. 캐시에 이미지 없으면 url로 요청
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard (response as? HTTPURLResponse)?.statusCode == 200,
                  error == nil,
                  let data = data,
                  let image = UIImage(data: data) else {
                completion(.failure(.unknown))
                return
            }
            // 3. 받아온 이미지 캐싱
            Self.imageCache.setObject(image, forKey: cacheKey)
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }.resume()
    }
}

// MARK: - NSCache
extension ImageLoader {
    static private var imageCache = NSCache<NSString, UIImage>()
    
    static func clearImageCache() {
        imageCache.removeAllObjects()
    }
}
