//
//  WFError.swift
//  WeatherForecast
//
//  Created by Journey36 on 2021/09/07.
//

import Foundation
import UIKit

enum ErrorTransactor: Error {
    case networkError(NetworkError)
    case authorizationError(AuthorizationError)
}
enum NetworkError: Error {
    case invalidURL
    case unexpactableResponse
    case dataFetchingFailure
}

enum AuthorizationError: Error {
    case locationSevicesRefusal
}

extension NetworkError: CustomStringConvertible {
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

extension AuthorizationError: CustomStringConvertible {
    var description: String {
        switch self {
        case .locationSevicesRefusal:
            return "위치 서비스 권한을 거부하셨기 때문에, 위치 정보를 불러올 수 없습니다."
        }
    }
}

extension ViewController {
    func presentAlert(_ error: AuthorizationError) {
        let message: String = """
        위치 정보 서비스를 사용하기 위해서는 권한이 필요합니다.
        권한 변경을 위해 설정으로 이동하겠습니다.
        """
        let alertController: UIAlertController = UIAlertController(title: error.description, message: message, preferredStyle: .alert)
        let moveToSettingAction: UIAlertAction = UIAlertAction(title: "확인", style: .default) { _ in
            if let appSetting: URL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(moveToSettingAction)
        present(alertController, animated: true)
    }
}
