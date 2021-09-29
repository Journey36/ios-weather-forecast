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
    
    private static func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        return label
    }
    
    private static func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    // MARK: - Properties
    
    private let weatehrIconImageView = makeImageView()
    
    private let addressLabel: UILabel = {
        let label = makeLabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        return label
    }()
    
    private let minAndMaxTemperatureLabel: UILabel = {
        let label = makeLabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        return label
    }()
    
    private let currentTemperatureLabel: UILabel = {
        let label = makeLabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setUpAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
        setUpAutoLayout()
    }
    
    // MARK: - Public Methods
    
    func configure(addressText: String? = nil, minAndMaxTemperatureText: String? = nil, currentTemperatureText: String? = nil, iconImage: UIImage? = nil) {
        if let _ = addressText {
            addressLabel.text = addressText
        }
        if let _ = minAndMaxTemperatureText {
            minAndMaxTemperatureLabel.text = minAndMaxTemperatureText
        }
        if let _ = currentTemperatureText {
            currentTemperatureLabel.text = currentTemperatureText
        }
        if let _ = iconImage {
            weatehrIconImageView.image = iconImage
        }
    }
    
    // MARK: - Private Methods
    
    private func addSubviews() {
        contentView.addSubview(weatehrIconImageView)
        contentView.addSubview(addressLabel)
        contentView.addSubview(minAndMaxTemperatureLabel)
        contentView.addSubview(currentTemperatureLabel)
    }
    
    private func setUpAutoLayout() {
        // 수평 레이아웃
        weatehrIconImageView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor).isActive = true
        weatehrIconImageView.widthAnchor.constraint(equalTo: weatehrIconImageView.heightAnchor).isActive = true
        weatehrIconImageView.widthAnchor.constraint(equalTo: contentView.readableContentGuide.widthAnchor, multiplier: 0.3).isActive = true
        
        addressLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: weatehrIconImageView.trailingAnchor, multiplier: 1).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor).isActive = true
        
        minAndMaxTemperatureLabel.leadingAnchor.constraint(equalTo: addressLabel.leadingAnchor).isActive = true
        minAndMaxTemperatureLabel.trailingAnchor.constraint(equalTo: addressLabel.trailingAnchor).isActive = true
        
        currentTemperatureLabel.leadingAnchor.constraint(equalTo: addressLabel.leadingAnchor).isActive = true
        currentTemperatureLabel.trailingAnchor.constraint(equalTo: addressLabel.trailingAnchor).isActive = true
        
        
        
        // 수직 레이아웃
        weatehrIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        addressLabel.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: contentView.layoutMarginsGuide.topAnchor, multiplier: 1).isActive = true
        
        minAndMaxTemperatureLabel.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: addressLabel.lastBaselineAnchor, multiplier: 1.2).isActive = true
        
        currentTemperatureLabel.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: minAndMaxTemperatureLabel.lastBaselineAnchor, multiplier: 1.4).isActive = true
        
        contentView.layoutMarginsGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: currentTemperatureLabel.lastBaselineAnchor, multiplier: 1).isActive = true
    }
    
    
}
