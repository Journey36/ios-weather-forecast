//
//  ForecastListView.swift
//  WeatherForecast
//
//  Created by Journey36 on 2021/09/16.
//

import UIKit

final class ForecastListView: UITableView {
    private let sideInsets: UIEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 10)
    // MARK: - Methods
    // MARK: Custom
    private func registerCells() {
        register(ForecastListCell.self, forCellReuseIdentifier: ForecastListCell.identifier)
        register(CurrentWeatherCell.self, forCellReuseIdentifier: CurrentWeatherCell.identifier)
    }
    
    private func configureAttributes() {
        separatorInset = sideInsets
        allowsSelection = false
        let backgroundImageLiteral: UIImage = .init(imageLiteralResourceName: "Background")
        backgroundView = UIImageView(image: backgroundImageLiteral)
    }
    
    // MARK: - Initializers
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configureAttributes()
        registerCells()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureAttributes()
        registerCells()
    }
}
