//
//  WeatherForecast
//  ViewController.swift
//
//  Created by Kyungmin Lee on 2021/01/22.
// 

import UIKit

class WeatherForecastViewController: UITableViewController {
    // MARK: - Properties
    private lazy var dataSource: WeatherForecastDataSource = {
        let dataSource = WeatherForecastDataSource(currentWeatherUpdatedAction: {
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(0...0), with: .automatic)
                self.endRefreshing()
            }
        }, fiveDayForecastUpdatedAction: {
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(1...1), with: .automatic)
                self.endRefreshing()
            }
        })
        dataSource.registerCells(with: tableView)
        return dataSource
    }()
    
    private lazy var locationManager: LocationManager = {
        let locationManager = LocationManager(locationUpdatedAction: { location in
            self.dataSource.requestAllData(by: location)
        }, locationDeniedAction: {
            DispatchQueue.main.async {
                self.alertLocationService()
                self.endRefreshing()
            }
        }, locationFailedAction: { error in
            DispatchQueue.main.async {
                self.alertError(title: "위치 서비스 에러", message: error)
                self.endRefreshing()
            }
        })
        return locationManager
    }()

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Desert_Tree")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableViewAndDataSource()
        setUpRefreshControl()
        locationManager.requestAuthorization()
    }
    
    // MARK: - Methods
    private func setUpTableViewAndDataSource() {
        tableView.backgroundView = backgroundImageView
        tableView.dataSource = dataSource
        tableView.allowsSelection = false
    }
    
    private func setUpRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    private func endRefreshing() {
        if let isRefreshing = tableView.refreshControl?.isRefreshing,
           isRefreshing {
            tableView.refreshControl?.endRefreshing()
        }
    }
    
    @objc private func handleRefreshControl() {
        locationManager.requestLocation()
    }
        
    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    private func alertLocationService() {
        let moveToSettingAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            self.openSettings()
        }
        let cancelAction = UIAlertAction(title: "위치 사용 안함", style: .default) { _ in
            self.tableView.refreshControl?.endRefreshing()
        }
        
        let alert = UIAlertController(title: "이 앱은 위치 서비스가 켜져 있을 때 사용할 수 있습니다.",
                                      message: "설정으로 이동하여 위치 서비스를 켜주세요.",
                                      preferredStyle: .alert)
        
        alert.addAction(moveToSettingAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func alertError(title: String?, message: String?) {
        let okAction = UIAlertAction(title: "확인", style: .default)
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
