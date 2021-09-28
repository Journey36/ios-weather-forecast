//
//  ForecastListView.swift
//  WeatherForecast
//
//  Created by Journey36 on 2021/09/16.
//

import UIKit

final class ForecastListView: UITableView {
    // MARK: - Methods
    // MARK: Custom
    private func registerCells() {
        register(ForecastListCell.self, forCellReuseIdentifier: ForecastListCell.identifier)
        register(CurrentWeatherCell.self, forCellReuseIdentifier: CurrentWeatherCell.identifier)
    }
    
    private func configureAttributes() {
        separatorInset = TableView.separateInset
        allowsSelection = false
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
