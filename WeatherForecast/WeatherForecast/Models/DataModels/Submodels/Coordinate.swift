//
//  Coordinate.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/01/20.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Decodable {
    
    
//    let latitude: Double
//    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
    
    public init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try values.decode(Double.self, forKey: .latitude)
        longitude = try values.decode(Double.self, forKey: .longitude)
    }
}
