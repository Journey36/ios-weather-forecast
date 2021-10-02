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
    
    // MARK: UI Components
    let dateTimeLabel: UILabel = {
        let dateTimeLabel: UILabel = .init()
        return dateTimeLabel
    }()
    
    let averageTemperatureLabel: UILabel = {
        let averageTemperatureLabel: UILabel = .init()
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
        
        NSLayoutConstraint.activate([
            dateTimeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dateTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            dateTimeLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            
            averageTemperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            averageTemperatureLabel.trailingAnchor.constraint(equalTo: weatherIconImageView.leadingAnchor, constant: -10),
            averageTemperatureLabel.heightAnchor.constraint(equalTo: dateTimeLabel.heightAnchor),

            weatherIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherIconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            weatherIconImageView.heightAnchor.constraint(equalTo: averageTemperatureLabel.heightAnchor)
        ])
        
        dateTimeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
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
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureConstraints()
    }
}
