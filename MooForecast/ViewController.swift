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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        NotificationCenter.default.addObserver(forName: WeatherDataSource.weatherInfoDidUpdate, object: nil, queue: .main) { _ in
            self.titleLabel.text = LocationManager.shared.currentLocationTitle
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
            return WeatherDataSource.shared.summary?.weather.count ?? 0
        case 1:
            return WeatherDataSource.shared.forecastList.count
        default:
            return 0
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SummaryTableViewCell.identifier, for: indexPath) as! SummaryTableViewCell
            
            if let summary = WeatherDataSource.shared.summary {
                cell.setData(current: summary)
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath) as! ForecastTableViewCell
        
        let forecast = WeatherDataSource.shared.forecastList[indexPath.row]
        cell.setData(forecast: forecast)
        
        return cell
    }
}

