//
//  WeatherDataSource.swift
//  MooForecast
//
//  Created by 김가람 on 2021/06/23.
//

import Foundation
import CoreLocation

class WeatherDataSource {
    static let shared = WeatherDataSource()
    private init() {
        NotificationCenter.default.addObserver(forName: LocationManager.currentLocationDidUpdate, object: nil, queue: .main) { (noti) in
            if let location = noti.userInfo?["location"] as? CLLocation {
                self.fetch(location: location) {
                    NotificationCenter.default.post(name: WeatherDataSource.weatherInfoDidUpdate, object: nil)
                }
            }
        }
    }
    
    static let weatherInfoDidUpdate = Notification.Name.init(rawValue: "weatherInfoDidUpdate")
    
    var summary: CurrentWeather?
    var forecastList = [ForecastData]()
    
    let apiQueue = DispatchQueue(label: "ApiQueue", attributes: .concurrent)
    
    let group = DispatchGroup()
    func fetch(location: CLLocation, completion: @escaping () -> ()) {
        group.enter()
        apiQueue.async {
            self.fetchCurrentWeather(location: location) { (result) in
                switch result {
                case .success(let data):
                    self.summary = data
                default:
                    self.summary = nil
                }
                
                self.group.leave()
            }
        }
        
        group.enter()
        apiQueue.async {
            self.fetchForecast(location: location) { (result) in
                switch result {
                case .success(let data):
                    self.forecastList = data.list.map {
                        let dt = Date(timeIntervalSince1970: TimeInterval($0.dt))
                        let icon = $0.weather.first?.icon ?? ""
                        let weather = $0.weather.first?.description ?? "정보 없음"
                        let temperature = $0.main.temp
                        
                        return ForecastData(date: dt, icon: icon, weather: weather, temperature: temperature)
                    }
                    
                default:
                    self.forecastList = []
                }
                
                self.group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
}

extension WeatherDataSource {
    private func fetch<ParsingType: Codable>(urlStr: String, completion: @escaping (Result<ParsingType, Error>) -> ()) {
        print(urlStr)
        
        guard let url = URL(string: urlStr) else {
            completion(.failure(ApiError.invalidUrl(urlStr)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) -> () in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(ApiError.invalidResponse))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(.failure(ApiError.failed(httpResponse.statusCode)))
                return
                
            }
            
            guard let data = data else {
                completion(.failure(ApiError.emptyData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(ParsingType.self, from: data)
                
                completion(.success(data))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

extension WeatherDataSource {
    private func fetchCurrentWeather(cityName: String, completion: @escaping (Result<CurrentWeather, Error>) -> ()) {
        // https://openweathermap.org
        let urlStr = "\(APIManager().weatherUrl)&q=\(cityName)"
        
        fetch(urlStr: urlStr, completion: completion)
    }
    
    private func fetchCurrentWeather(cityId: Int, completion: @escaping (Result<CurrentWeather, Error>) -> ()) {
        let urlStr = "\(APIManager().weatherUrl)&id=\(cityId)"
        
        fetch(urlStr: urlStr, completion: completion)
    }
    
    private func fetchCurrentWeather(location: CLLocation, completion: @escaping (Result<CurrentWeather, Error>) -> ()) {
        let urlStr = "\(APIManager().weatherUrl)&lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)"
        
        fetch(urlStr: urlStr, completion: completion)
    }
    
}

extension WeatherDataSource {
    private func fetchForecast(cityName: String, completion: @escaping (Result<Forecast, Error>) -> ()) {
        // https://openweathermap.org
        let urlStr = "\(APIManager().forecastUrl)&q=\(cityName)"
        
        fetch(urlStr: urlStr, completion: completion)
    }
    
    private func fetchForecast(cityId: Int, completion: @escaping (Result<Forecast, Error>) -> ()) {
        let urlStr = "\(APIManager().forecastUrl)&id=\(cityId)"
        
        fetch(urlStr: urlStr, completion: completion)
    }
    
    private func fetchForecast(location: CLLocation, completion: @escaping (Result<Forecast, Error>) -> ()) {
        let urlStr = "\(APIManager().forecastUrl)&lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)"
        
        fetch(urlStr: urlStr, completion: completion)
    }
}
