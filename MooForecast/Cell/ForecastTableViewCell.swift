//
//  ForecastTableViewCell.swift
//  MooForecast
//
//  Created by 김가람 on 2021/06/15.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    static let identifier = "ForecastTableViewCell"
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(forecast: ForecastData) {
        self.dateLabel.text = forecast.date.dateString
        self.timeLabel.text = forecast.date.timeString
        self.weatherImageView.image = UIImage(named: forecast.icon)
        self.statusLabel.text = forecast.weather
        self.temperatureLabel.text = forecast.temperature.temperatureString
    }
}
