//
//  WFError.swift
//  WeatherForecast
//
//  Created by Journey36 on 2021/09/07.
//

import Foundation

struct ErrorTransactor: Error {
    enum NetworkError: Error {
        case invalidURL
        case unexpactableResponse
        case dataFetchingFailure
    }

    enum AuthorizationError: Error {
        case locationSevicesRefusal
    }

    private init() {}
}

extension ErrorTransactor.NetworkError: CustomStringConvertible {
    var description: String {
        switch self {
        case .invalidURL:
            return "API URL이 올바르지 않습니다."
        case .unexpactableResponse:
            return "기대하는 응답 코드를 받지 못했습니다."
        case .dataFetchingFailure:
            return "데이터를 받아오는 데 실패했습니다."
        }
    }
}

extension ErrorTransactor.AuthorizationError: CustomStringConvertible {
    var description: String {
        switch self {
        case .locationSevicesRefusal:
            return "위치 서비스 권한을 거부하셨기 때문에, 위치 정보를 불러올 수 없습니다."
        }
    }
}
