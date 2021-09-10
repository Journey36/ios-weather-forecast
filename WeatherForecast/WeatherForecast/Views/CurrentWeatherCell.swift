//
//  CurrentWeatherCell.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/09/10.
//

import UIKit

class CurrentWeatherCell: UITableViewCell {
    static var identifier: String {
        return "\(self)"
    }
    
    // MARK: - Properties
    
    private let weatehrIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let minAndMaxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
        setUpConstraints()
    }
    
    
    // MARK: - Methods
    
    private func addSubviews() {
        contentView.addSubview(weatehrIconImageView)
        contentView.addSubview(addressLabel)
        contentView.addSubview(minAndMaxTemperatureLabel)
        contentView.addSubview(currentTemperatureLabel)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            // 수평 레이아웃
            weatehrIconImageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            weatehrIconImageView.widthAnchor.constraint(equalToConstant: 100),
            weatehrIconImageView.widthAnchor.constraint(equalTo: weatehrIconImageView.heightAnchor),
            
            addressLabel.leadingAnchor.constraint(equalTo: weatehrIconImageView.trailingAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            
            minAndMaxTemperatureLabel.leadingAnchor.constraint(equalTo: addressLabel.leadingAnchor),
            minAndMaxTemperatureLabel.trailingAnchor.constraint(equalTo: addressLabel.trailingAnchor),
            
            currentTemperatureLabel.leadingAnchor.constraint(equalTo: addressLabel.leadingAnchor),
            currentTemperatureLabel.trailingAnchor.constraint(equalTo: addressLabel.trailingAnchor),
            
            // 수직 레이아웃
            weatehrIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            weatehrIconImageView.heightAnchor.constraint(equalTo: currentTemperatureLabel.heightAnchor, multiplier: 1.0),
            
            addressLabel.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: contentView.layoutMarginsGuide.topAnchor, multiplier: 1),
            
            minAndMaxTemperatureLabel.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: addressLabel.lastBaselineAnchor, multiplier: 1.5),
            
            currentTemperatureLabel.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: minAndMaxTemperatureLabel.lastBaselineAnchor, multiplier: 1.5),
            
            contentView.layoutMarginsGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: currentTemperatureLabel.lastBaselineAnchor, multiplier: 1)
        ])
    }
    
    func configure(addressText: String, minAndMaxTemperatureText: String, currentTemperatureText: String) {
        addressLabel.text = addressText
        minAndMaxTemperatureLabel.text = minAndMaxTemperatureText
        currentTemperatureLabel.text = currentTemperatureText
    }
    
    func configure(iconImage: UIImage) {
        weatehrIconImageView.image = iconImage
    }
}
