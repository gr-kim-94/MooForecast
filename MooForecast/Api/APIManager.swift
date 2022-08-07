//
//  APIManager.swift
//  QuickstartApp
//
//  Created by grkim on 2022/05/13.
//

import Foundation

struct APIManager {
    private let host = "http://openweathermap.org"
    private let apiHost = "https://api.openweathermap.org"

    private var apiKey: String {
        if let bundle = Bundle.main.infoDictionary {
            if let value = bundle["API_KEY"] {
                if let key = value as? String {
                    return key
                }
            }
        }
        
        return ""
    }
    
    var forecastUrl: String {
        "\(self.apiHost)/data/2.5/forecast?appid=\(self.apiKey)&lang=kr&units=metric"
    }
    
    // 01n.png 01n@2x.png
    var forecastIconUrl: String {
        "\(self.host)/img/wn/"
    }
    
    var weatherUrl: String {
        "\(self.apiHost)/data/2.5/weather?appid=\(self.apiKey)&lang=kr&units=metric"
    }
}
