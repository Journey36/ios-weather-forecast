//
//  CurrentWeatherCell.swift
//  WeatherForecast
//
//  Created by Journey36 on 2021/09/17.
//

import UIKit

class CurrentWeatherCell: UITableViewCell {
    // MARK: - Properties
    // MARK: Type Properties
    static let identifier: String = .init(describing: CurrentWeatherCell.self)
    
    // MARK: UI Components
    let weatherIconImageView: UIImageView = {
        let weatherIconImageView: UIImageView = .init()
        weatherIconImageView.contentMode = .scaleAspectFit
        return weatherIconImageView
    }()
    
    private let labelStackView: UIStackView = {
        let labelStackView: UIStackView = .init()
        labelStackView.axis = .vertical
        labelStackView.distribution = .equalSpacing
        labelStackView.spacing = 5
        return labelStackView
    }()
    
    let currentLocationLabel: UILabel = {
        let currentLocationLabel: UILabel = .init()
        currentLocationLabel.setDynamicType(style: .footnote)
        currentLocationLabel.numberOfLines = 0
        currentLocationLabel.lineBreakMode = .byWordWrapping
        if #available(iOS 13.0, *) {
            currentLocationLabel.textColor = .label
        } else {
            currentLocationLabel.textColor = .white
        }
        return currentLocationLabel
    }()
    
    let temperatureMinAndMaxLabel: UILabel = {
        let temperatureMinAndMaxLabel: UILabel = .init()
        temperatureMinAndMaxLabel.setDynamicType(style: .footnote)
        temperatureMinAndMaxLabel.numberOfLines = 0
        if #available(iOS 13.0, *) {
            temperatureMinAndMaxLabel.textColor = .label
        } else {
            temperatureMinAndMaxLabel.textColor = .white
        }
        return temperatureMinAndMaxLabel
    }()
    
    let currentTemperatureLabel: UILabel = {
        let currentTemperatureLabel: UILabel = .init()
        currentTemperatureLabel.setDynamicType(style: .largeTitle)
        currentTemperatureLabel.numberOfLines = 0
        if #available(iOS 13.0, *) {
            currentTemperatureLabel.textColor = .label
        } else {
            currentTemperatureLabel.textColor = .white
        }
        return currentTemperatureLabel
    }()
    
    // MARK: - Methods
    // MARK: Custom
    func configureCell(with data: CurrentWeather?, at address: String?) {
        guard let data: CurrentWeather = data else {
            return
        }
        
        currentLocationLabel.text = address
        temperatureMinAndMaxLabel.text = "최저 \(data.temperature.minimum.tenthsRounded)\(Units.temperatureUnit) 최고 \(data.temperature.maximum.tenthsRounded)\(Units.temperatureUnit)"
        currentTemperatureLabel.text = "\(data.temperature.current.tenthsRounded)\(Units.temperatureUnit)"
    }

    private func hideLeftSeparatorInset() {
        separatorInset.left = .greatestFiniteMagnitude
    }
    
    private func configureConstraints() {
        contentView.addSubview(weatherIconImageView)
        contentView.addSubview(labelStackView)
        labelStackView.addArrangedSubview(currentLocationLabel)
        labelStackView.addArrangedSubview(temperatureMinAndMaxLabel)
        labelStackView.addArrangedSubview(currentTemperatureLabel)
        
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        currentLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureMinAndMaxLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weatherIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherIconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            weatherIconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            weatherIconImageView.trailingAnchor.constraint(equalTo: labelStackView.leadingAnchor, constant: -10),
            weatherIconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            weatherIconImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),

            labelStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelStackView.topAnchor.constraint(equalTo: weatherIconImageView.topAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            labelStackView.bottomAnchor.constraint(equalTo: weatherIconImageView.bottomAnchor)
        ])
    }
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureConstraints()
        hideLeftSeparatorInset()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureConstraints()
        hideLeftSeparatorInset()
    }
}
