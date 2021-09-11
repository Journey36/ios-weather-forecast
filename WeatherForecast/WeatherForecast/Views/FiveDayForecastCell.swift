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
    
    // MARK: - Properties
    
    let dateLabel = makeLabel()
    let temperatureLabel = makeLabel()
    let iconImageView = UIImageView()
  
    private static func makeLabel() -> UILabel {
        let label = UILabel()
        
        /*
         setUpLabelsAndConstraints()의 auto adjusting constraints와 충돌할 수 있으므로 false로 해준다.
         이것은 레이블이 프로그래밍으로 생성됐을 때만 필요하다.
        */
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // 라인의 최대 리미트를 해제
        //label.numberOfLines = 0
        return label
    }
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLabelsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpLabelsAndConstraints()
    }
    
    // MARK: -

    private func setUpLabelsAndConstraints() {
        dateLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        dateLabel.adjustsFontForContentSizeCategory = true
        dateLabel.numberOfLines = 0
        
        temperatureLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        temperatureLabel.adjustsFontForContentSizeCategory = true
        temperatureLabel.numberOfLines = 1
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(iconImageView)
        
        // constraint 설정 (뷰에 추가한 후에 설정해야 함)
        
        // 수평
        dateLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: temperatureLabel.leadingAnchor).isActive = true
        
        temperatureLabel.textAlignment = .right
        temperatureLabel.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor).isActive = true
        
        iconImageView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor).isActive = true
        iconImageView.heightAnchor.constraint(equalTo: temperatureLabel.heightAnchor, multiplier: 2.0).isActive = true
        
        // 수직
        dateLabel.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: contentView.layoutMarginsGuide.topAnchor, multiplier: 1).isActive = true
        contentView.layoutMarginsGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: dateLabel.lastBaselineAnchor, multiplier: 1).isActive = true
    
        temperatureLabel.firstBaselineAnchor.constraint(equalTo: dateLabel.firstBaselineAnchor).isActive = true
        temperatureLabel.lastBaselineAnchor.constraint(equalTo: dateLabel.lastBaselineAnchor).isActive = true
        
        iconImageView.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor).isActive = true
        iconImageView.contentMode = .scaleAspectFit
        
    }
    
    func configure(dateAndTimeText: String, temperatureText: String) {
        dateLabel.text = dateAndTimeText
        temperatureLabel.text = temperatureText
    }
    
    func configure(iconImage: UIImage) {
        iconImageView.image = iconImage
    }
}
