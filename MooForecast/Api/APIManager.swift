//
//  APIManager.swift
//  QuickstartApp
//
//  Created by grkim on 2022/05/13.
//

import Foundation

struct APIManager {
    private let host = "https://api.openweathermap.org"
    
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
        "\(self.host)/data/2.5/forecast?appid=\(self.apiKey)&lang=kr&units=metric"
    }
    
    var weatherUrl: String {
        "\(self.host)/data/2.5/weather?appid=\(self.apiKey)&lang=kr&units=metric"
    }
}
