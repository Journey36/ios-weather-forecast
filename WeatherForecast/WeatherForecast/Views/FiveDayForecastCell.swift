//
//  FiveDayForecastCell.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/09/06.
//

import UIKit

class FiveDayForecastCell: UITableViewCell {
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
    
    private let dateLabel: UILabel = {
        let label = makeLabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
//        label.textColor = .systemBlue
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = makeLabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    
    private let iconImageView = makeImageView()
  
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
            
    // MARK: - Public Methods
    
    func configure(dateAndTimeText: String? = nil, temperatureText: String? = nil, iconImage: UIImage? = nil) {
        if let _ = dateAndTimeText {
            dateLabel.text = dateAndTimeText
        }
        if let _ = temperatureText {
            temperatureLabel.text = temperatureText
        }
        if let _ = iconImage {
            iconImageView.image = iconImage
        }
    }
    
    // MARK: - Private Methods
    private func setUp() {
        backgroundColor = .clear
        
        addSubviews()
        setUpAutoLayout()
    }
    
    private func addSubviews() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(iconImageView)
    }

    private func setUpAutoLayout() {
        // 수평 레이아웃
        dateLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor).isActive = true
        
        temperatureLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: dateLabel.trailingAnchor, multiplier: 1).isActive = true
        temperatureLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        temperatureLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        iconImageView.leadingAnchor.constraint(equalToSystemSpacingAfter: temperatureLabel.trailingAnchor, multiplier: 1).isActive = true
        iconImageView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalTo: contentView.readableContentGuide.widthAnchor, multiplier: 0.12).isActive = true
                
        // 수직 레이아웃
        dateLabel.firstBaselineAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: contentView.readableContentGuide.topAnchor, multiplier: 1).isActive = true
        
        temperatureLabel.firstBaselineAnchor.constraint(equalTo: dateLabel.firstBaselineAnchor).isActive = true
        temperatureLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        temperatureLabel.setContentHuggingPriority(.required, for: .vertical)
        
        iconImageView.centerYAnchor.constraint(equalTo: temperatureLabel.centerYAnchor).isActive = true
        iconImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor).isActive = true
    
        contentView.readableContentGuide.bottomAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: dateLabel.lastBaselineAnchor, multiplier: 1).isActive = true
        contentView.bottomAnchor.constraint(greaterThanOrEqualTo: iconImageView.bottomAnchor).isActive = true
    }
}
