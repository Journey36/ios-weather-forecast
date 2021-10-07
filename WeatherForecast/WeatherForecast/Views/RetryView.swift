//
//  RetryView.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/10/07.
//

import UIKit

class RetryView: UIView {
    private static let contentColor = UIColor.init(displayP3Red: 99/255, green: 99/255, blue: 102/255, alpha: 1.0)
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textColor = contentColor
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let retryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        button.setTitle("재시도", for: .normal)
        button.setTitleColor(contentColor, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = contentColor.cgColor
        button.layer.cornerRadius = 5
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 50, bottom: 8, right: 50)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureSubviews()
    }
    
    init(message: String?) {
        self.init()
        messageLabel.text = message
    }
    
    private func configureSubviews() {
        addSubviews()
        configureAutoLayout()
    }
    
    private func addSubviews() {
        addSubview(retryButton)
        addSubview(messageLabel)
    }
    
    private func configureAutoLayout() {
        messageLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        messageLabel.topAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.topAnchor).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: retryButton.topAnchor, constant: -30).isActive = true
        
        retryButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        retryButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
