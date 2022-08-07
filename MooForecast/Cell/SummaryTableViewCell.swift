//
//  SummaryTableViewCell.swift
//  MooForecast
//
//  Created by 김가람 on 2021/06/15.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {
    
    static let identifier = "SummaryTableViewCell"
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var minMaxLabel: UILabel!
    
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(current: CurrentWeather) {
        if let weather = current.weather.first {
            self.weatherImageView.image = UIImage(named: weather.icon)
            self.statusLabel.text = weather.description
        } else {
            self.weatherImageView.image = nil
            self.statusLabel.text = ""
        }
        
        let main = current.main
        self.minMaxLabel.text = "최고 \(main.temp_max.temperatureString)  최저 \(main.temp_min.temperatureString)"
        self.currentTemperatureLabel.text = "\(main.temp.temperatureString)"
    }
}
