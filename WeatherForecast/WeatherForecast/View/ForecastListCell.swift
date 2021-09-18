//
//  ForecastListViewCell.swift
//  WeatherForecast
//
//  Created by Journey36 on 2021/09/16.
//

import UIKit

final class ForecastListCell: UITableViewCell {
    // MARK:- Properties
    //MARK: Type Properties
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
        return weatherIconImageView
    }()

    // MARK:- Methods
    // MARK: Custom
    func configureCell(with data: ForecastList?, indexPath: IndexPath) {
        guard let data: ForecastList = data else {
            return
        }

        dateTimeLabel.text = data.list[indexPath.row].timestamp
        averageTemperatureLabel.text = "\(data.list[indexPath.row].temperature.current)"
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
            dateTimeLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),

            averageTemperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            averageTemperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            averageTemperatureLabel.heightAnchor.constraint(equalTo: dateTimeLabel.heightAnchor, multiplier: 0.7)
        ])

        dateTimeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    // MARK: Override
    override func prepareForReuse() {
        super.prepareForReuse()
        dateTimeLabel.text = nil
        averageTemperatureLabel.text = nil
    }

    // MARK:- Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureConstraints()
    }
}
