//
//  LoadingView.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/10/12.
//

import UIKit

class LoadingView: UIView {
    enum Status {
        case location
        case weatherData
        
        var message: String {
            switch self {
            case .location:
                return "현재 위치 찾는 중..."
            case .weatherData:
                return "날씨 데이터 로드 중..."
            }
        }
    }
    
    private var status: Status = .location {
        didSet {
            messageLabel.text = status.message
        }
    }
    
    private let loadingContentsActivityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            activityIndicatorView.style = .large
        } else {
            activityIndicatorView.style = .whiteLarge
        }
        return activityIndicatorView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureSubviews()
    }
    
    private func configureSubviews() {
        addSubviews()
        configureAutoLayout()
        messageLabel.text = status.message
        messageLabel.textColor = loadingContentsActivityIndicatorView.color
        loadingContentsActivityIndicatorView.startAnimating()
    }
    
    private func addSubviews() {
        addSubview(loadingContentsActivityIndicatorView)
        addSubview(messageLabel)
    }
    
    private func configureAutoLayout() {
        loadingContentsActivityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadingContentsActivityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        messageLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        messageLabel.topAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.topAnchor).isActive = true
        messageLabel.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: loadingContentsActivityIndicatorView.bottomAnchor, multiplier: 1).isActive = true
        messageLabel.bottomAnchor.constraint(greaterThanOrEqualTo: loadingContentsActivityIndicatorView.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    func set(status: Status) {
        self.status = status
    }
}
