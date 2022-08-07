//
//  ViewController.swift
//  MooForecast
//
//  Created by 김가람 on 2021/06/14.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let weatherDataSource: WeatherDataSource = WeatherDataSource.shared
    var currentWeather: CurrentWeather?
    var forecastList: [ForecastData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.titleLabel.text = ""
        
        NotificationCenter.default.addObserver(forName: WeatherDataSource.weatherInfoDidUpdate, object: nil, queue: .main) { _ in
            self.titleLabel.text = LocationManager.shared.currentLocationTitle
            self.forecastList = self.weatherDataSource.forecastList
            self.currentWeather = self.weatherDataSource.summary
            self.tableView.reloadData()
        }
        
        LocationManager.shared.updateLocation()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.currentWeather?.weather.count ?? 0
        case 1:
            return self.forecastList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SummaryTableViewCell.identifier, for: indexPath) as! SummaryTableViewCell
            
            if let weather = self.currentWeather {
                cell.setData(current: weather)
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath) as! ForecastTableViewCell
        
        let forecast = self.forecastList[indexPath.row]
        cell.setData(forecast: forecast)
        
        return cell
    }
}

