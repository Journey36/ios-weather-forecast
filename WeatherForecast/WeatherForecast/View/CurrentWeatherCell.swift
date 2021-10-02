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
        return labelStackView
    }()
    
    let currentLocationLabel: UILabel = {
        let currentLocationLabel: UILabel = .init()
        currentLocationLabel.text = "-"
        currentLocationLabel.font = .preferredFont(forTextStyle: .footnote)
        currentLocationLabel.numberOfLines = 0
        return currentLocationLabel
    }()
    
    let temperatureMinAndMaxLabel: UILabel = {
        let temperatureMinAndMaxLabel: UILabel = .init()
        temperatureMinAndMaxLabel.text = "-"
        temperatureMinAndMaxLabel.font = .preferredFont(forTextStyle: .footnote)
        temperatureMinAndMaxLabel.numberOfLines = 0
        return temperatureMinAndMaxLabel
    }()
    
    let currentTemperatureLabel: UILabel = {
        let currentTemperatureLabel: UILabel = .init()
        currentTemperatureLabel.text = "-"
        currentTemperatureLabel.font = .preferredFont(forTextStyle: .largeTitle)
        currentTemperatureLabel.numberOfLines = 0
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
            weatherIconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            weatherIconImageView.widthAnchor.constraint(equalTo: labelStackView.widthAnchor, multiplier: 0.4),

            labelStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelStackView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            labelStackView.leadingAnchor.constraint(equalTo: weatherIconImageView.trailingAnchor, constant: 20)
        ])
        
        labelStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
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
