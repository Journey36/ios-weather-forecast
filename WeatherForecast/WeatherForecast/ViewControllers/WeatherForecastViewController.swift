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
        
        dataSource = WeatherForecastDataSource(fiveDayForecastUpdatedAction: {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        dataSource?.registerCells(with: tableView)
        tableView.dataSource = dataSource
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    // MARK: - Methods
    
    
}
