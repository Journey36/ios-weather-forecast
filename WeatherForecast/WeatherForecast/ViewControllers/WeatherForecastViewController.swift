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
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Desert_Tree")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableViewAndDataSource()
        configureRefreshControl()
    }
    
    // MARK: - Methods
    private func configureTableViewAndDataSource() {
        tableView.backgroundView = backgroundImageView
        tableView.allowsSelection = false
        
        dataSource = WeatherForecastDataSource(currentWeatherUpdatedAction: {
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(0...0), with: .none)
                self.tableView.refreshControl?.endRefreshing()
            }
        }, fiveDayForecastUpdatedAction: {
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(1...1), with: .none)
                self.tableView.refreshControl?.endRefreshing()
            }
        })
        dataSource?.registerCells(with: tableView)
        tableView.dataSource = dataSource
    }
    
    private func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc private func handleRefreshControl() {
        dataSource?.refresh()
    }
}
