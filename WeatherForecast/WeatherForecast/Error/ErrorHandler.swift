//
//  WFError.swift
//  WeatherForecast
//
//  Created by Journey36 on 2021/09/07.
//

import Foundation

enum ErrorHandler: Error {
    case SystemError(type: SystemError)
    case UserError(type: UserError)

}

enum SystemError: Error {
    case invalidURL
    case unableToComplete
    case invalidResponse
    case invalidData
}

enum UserError: Error {
    case locationServiceRefusal
}

extension SystemError: CustomStringConvertible {
    var description: String {
        switch self {
            case .invalidURL:
                return "API URL이 올바르지 않습니다."
            case.unableToComplete:
                return "요청을 처리하지 못했습니다."
            case .invalidResponse:
                return "서버로부터 응답을 받지 못했습니다."
            case .invalidData:
                return "서버로부터 데이터를 받지 못했습니다."
        }
    }
}

extension UserError: CustomStringConvertible {
    var description: String {
        switch self {
            case .locationServiceRefusal:
                return "위치 서비스 권한을 거부하셨기 때문에, 위치 정보를 불러올 수 없습니다."
        }
    }
}
