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
        let dataSource = WeatherForecastDataSource(dataLoadedAction: {
            DispatchQueue.main.async {
                self.removeLoadingView()
                self.endRefreshing()
                self.tableView.setSeparatorVisible(true)
                self.tableView.reloadData()
                self.configureRefreshControl()
            }
        }, dataRequestFailedAction: {
            DispatchQueue.main.async {
                if let _ = self.loadingView {
                    self.removeLoadingView()
                    self.createAndConfigureRetryView(with: "날씨 데이터를 로드할 수 없습니다.")
                } else {
                    self.alertError(title: "날씨 데이터를 로드할 수 없습니다.", message: "잠시 후 다시 시도하세요.")
                }
            }
        })
        dataSource.registerCells(with: tableView)
        return dataSource
    }()
    
    private lazy var locationManager: LocationManager = {
        let locationManager = LocationManager(locationUpdatedAction: { location in
            self.dataSource.requestAllData(by: location)
            DispatchQueue.main.async {
                self.loadingView?.set(status: .weatherData)
            }
        }, locationDeniedAction: {
            DispatchQueue.main.async {
                self.alertLocationService()
                self.endRefreshing()
            }
        }, locationFailedAction: {
            DispatchQueue.main.async {
                if let _ = self.loadingView {
                    self.removeLoadingView()
                    self.createAndConfigureRetryView(with: "현재 위치를 찾을 수 없습니다.")
                } else {
                    self.alertError(title: "현재 위치를 찾을 수 없습니다.", message: nil)
                }
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
        
    private var loadingView: LoadingView? = nil
    private var retryView: RetryView? = nil
        
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableViewAndDataSource()
        createAndConfigureLoadingView()
        locationManager.requestAuthorization()
    }
    
    // MARK: - Methods
    private func configureTableViewAndDataSource() {
        tableView.backgroundView = backgroundImageView
        tableView.dataSource = dataSource
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }
    
    private func configureRefreshControl() {
        guard tableView.refreshControl == nil else {
            return
        }
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
        
    private func createAndConfigureLoadingView() {
        loadingView = LoadingView()
        guard let loadingView = loadingView else {
            return
        }
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.addSubview(loadingView)
        loadingView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor).isActive = true
        loadingView.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        loadingView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
    }
    
    private func removeLoadingView() {
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
    
    private func createAndConfigureRetryView(with message: String? = nil) {
        guard retryView == nil else {
            return
        }
        let retryView = RetryView(message: message)
        retryView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.addSubview(retryView)
        retryView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor).isActive = true
        retryView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor).isActive = true
        retryView.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        retryView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        retryView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        retryView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true

        retryView.retryButton.addTarget(self, action: #selector(touchUpRetryButton), for: .touchUpInside)
        self.retryView = retryView
    }
    
    @objc private func touchUpRetryButton() {
        removeRetryView()
        createAndConfigureLoadingView()
        locationManager.requestLocation()
    }
    
    private func removeRetryView() {
        retryView?.removeFromSuperview()
        retryView = nil
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
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.removeLoadingView()
            self.endRefreshing()
        }
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

private extension UITableView {
    func setSeparatorVisible(_ isVisible: Bool) {
        if isVisible {
            separatorStyle = .singleLine
        } else {
            separatorStyle = .none
        }
    }
}
