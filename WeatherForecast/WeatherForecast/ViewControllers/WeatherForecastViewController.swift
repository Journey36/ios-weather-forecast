//
//  WeatherForecast
//  ViewController.swift
//
//  Created by Kyungmin Lee on 2021/01/22.
// 

import UIKit

class WeatherForecastViewController: UITableViewController {
    // MARK: - Properties
    
    private var dataSource: WeatherForecastDataSource?
    
    
    private var currentWeather: CurrentWeatherData!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableViewAndDataSource()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    // MARK: - Methods
    private func configureTableViewAndDataSource() {
        dataSource = WeatherForecastDataSource(currentWeatherUpdatedAction: {
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(0...0), with: .automatic)
            }
        }, fiveDayForecastUpdatedAction: {
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(1...1), with: .automatic)
            }
        })
        dataSource?.registerCells(with: tableView)
        
        tableView.dataSource = dataSource
        tableView.allowsSelection = false
    }
}
