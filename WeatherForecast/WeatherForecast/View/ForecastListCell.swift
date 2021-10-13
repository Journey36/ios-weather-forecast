//
//  ForecastListViewCell.swift
//  WeatherForecast
//
//  Created by Journey36 on 2021/09/16.
//

import UIKit

final class ForecastListCell: UITableViewCell {
    // MARK: - Properties
    // MARK: Type Properties
    static let identifier: String = .init(describing: ForecastListCell.self)
    private var commonConstraints: [NSLayoutConstraint] = []
    private var generalConstraints: [NSLayoutConstraint] = []
    private var accessibilityConstraints: [NSLayoutConstraint] = []
    private let anchorIntervalConstant: CGFloat = 10
    private let imageViewHeight: CGFloat = 30
    private let imageViewHeightForA11y: CGFloat = 105
    
    // MARK: UI Components
    let dateTimeLabel: UILabel = {
        let dateTimeLabel: UILabel = .init()
        dateTimeLabel.setDynamicType(style: .body)
        dateTimeLabel.lineBreakMode = .byWordWrapping
        dateTimeLabel.numberOfLines = 0
        if #available (iOS 13, *) {
            dateTimeLabel.textColor = .label
        } else {
            dateTimeLabel.textColor = .white
        }
        return dateTimeLabel
    }()
    
    let averageTemperatureLabel: UILabel = {
        let averageTemperatureLabel: UILabel = .init()
        averageTemperatureLabel.setDynamicType(style: .body)
        if #available(iOS 13, *) {
            averageTemperatureLabel.textColor = .label
        } else {
            averageTemperatureLabel.textColor = .white
        }
        return averageTemperatureLabel
    }()
    
    let weatherIconImageView: UIImageView = {
        let weatherIconImageView: UIImageView = .init()
        weatherIconImageView.contentMode = .scaleAspectFit
        return weatherIconImageView
    }()
    
    // MARK: - Methods
    // MARK: Custom
    func configureCell(with data: ForecastList?, indexPath: IndexPath) {
        guard let data: ForecastList = data else {
            return
        }
        
        dateTimeLabel.text = format(date: data.list[indexPath.row].timestamp)
        averageTemperatureLabel.text = "\(data.list[indexPath.row].temperature.current.tenthsRounded)\(Units.temperatureUnit)"
    }
    
    private func configureConstraints() {
        contentView.addSubview(dateTimeLabel)
        contentView.addSubview(averageTemperatureLabel)
        contentView.addSubview(weatherIconImageView)
        
        dateTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        averageTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false

        commonConstraints = [
            dateTimeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: anchorIntervalConstant),
            dateTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: anchorIntervalConstant),
            weatherIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherIconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -anchorIntervalConstant),
            weatherIconImageView.widthAnchor.constraint(equalTo: weatherIconImageView.heightAnchor)
        ]
        generalConstraints = [
            dateTimeLabel.trailingAnchor.constraint(lessThanOrEqualTo: averageTemperatureLabel.leadingAnchor, constant: -anchorIntervalConstant),
            dateTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -anchorIntervalConstant),
            dateTimeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            averageTemperatureLabel.lastBaselineAnchor.constraint(equalTo: dateTimeLabel.lastBaselineAnchor),
            averageTemperatureLabel.trailingAnchor.constraint(equalTo: weatherIconImageView.leadingAnchor, constant: -anchorIntervalConstant),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: imageViewHeight)
        ]
        accessibilityConstraints = [
            dateTimeLabel.trailingAnchor.constraint(lessThanOrEqualTo: weatherIconImageView.leadingAnchor, constant: anchorIntervalConstant),
            averageTemperatureLabel.leadingAnchor.constraint(equalTo: dateTimeLabel.leadingAnchor),
            averageTemperatureLabel.trailingAnchor.constraint(equalTo: weatherIconImageView.leadingAnchor, constant: -anchorIntervalConstant),
            averageTemperatureLabel.topAnchor.constraint(equalTo: dateTimeLabel.bottomAnchor, constant: anchorIntervalConstant),
            averageTemperatureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -anchorIntervalConstant),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: imageViewHeightForA11y)
        ]
        averageTemperatureLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        averageTemperatureLabel.setContentHuggingPriority(.required, for: .vertical)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
            updateLayoutConstraints()
        }
    }

    private func updateLayoutConstraints() {
        configureConstraints()
        NSLayoutConstraint.activate(commonConstraints)
        if traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
            NSLayoutConstraint.deactivate(generalConstraints)
            NSLayoutConstraint.activate(accessibilityConstraints)
        } else {
            NSLayoutConstraint.activate(generalConstraints)
            NSLayoutConstraint.deactivate(accessibilityConstraints)
        }
    }
    
    private func format(date: String) -> String? {
        let isoFormatter: ISO8601DateFormatter = .init()
        isoFormatter.formatOptions = [.withFullDate, .withSpaceBetweenDateAndTime, .withTime, .withColonSeparatorInTime]
        let dateFormatter: DateFormatter = .init()
        dateFormatter.locale = .init(identifier: "ko_KR")
        let calendar: Calendar = Calendar.current
        guard let formattedDate: Date = isoFormatter.date(from: date) else {
            return nil
        }
        
        guard let weekday: Int = calendar.dateComponents([.weekday], from: formattedDate).weekday else {
            return nil
        }
        
        let dayOfWeek: Character = dateFormatter.weekdaySymbols[weekday - 1].removeFirst()
        dateFormatter.dateFormat = "MM/dd(\(dayOfWeek)) HH시"
        guard let newDate: String = dateFormatter.string(for: formattedDate) else {
            return nil
        }
        
        return newDate
    }
    
    // MARK: Override
    override func prepareForReuse() {
        super.prepareForReuse()
        dateTimeLabel.text = nil
        averageTemperatureLabel.text = nil
    }
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        updateLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateLayoutConstraints()
    }
}
