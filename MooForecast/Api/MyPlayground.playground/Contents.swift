import UIKit
import CoreLocation

var greeting = "Hello, playground"

print(greeting)
print("test")

enum ApiError: Error {
    case unknown
    case invalidUrl(String)
    case invalidResponse
    case failed(Int)
    case emptyData
}

struct Forecast: Codable {
    let cod: String
    let message: Int
    let cnt : Int
    
    struct ListItem: Codable {
        let dt: Int
        struct Main: Codable {
            let temp: Double
        }
        
        let main: Main
        
        struct Weather: Codable {
            let description: String
            let icon: String
        }
        
        let weather: [Weather]
    }
    
    let list: [ListItem]
}

private func fetch<ParsingType: Codable>(urlStr: String, completion: @escaping (Result<ParsingType, Error>) -> ()) {
    print(urlStr)
    
    guard let url = URL(string: urlStr) else {
        completion(.failure(ApiError.invalidUrl(urlStr)))
        return
    }
    
    let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) -> () in
        print(urlStr)
        
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
    }
    
    dataTask.resume()
}

private func fetchForecast(cityName: String, completion: @escaping (Result<Forecast, Error>) -> ()) {
    let urlStr = "\(forecastUrl)&q=\(cityName)"
    
    fetch(urlStr: urlStr, completion: completion)
}

private func fetchForecast(cityId: Int, completion: @escaping (Result<Forecast, Error>) -> ()) {
    let urlStr = "\(forecastUrl)&id=\(cityId)"
    
    fetch(urlStr: urlStr, completion: completion)
}

private func fetchForecast(location: CLLocation, completion: @escaping (Result<Forecast, Error>) -> ()) {
    let urlStr = "\(forecastUrl)&lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)"
    
    fetch(urlStr: urlStr, completion: completion)
}

let location = CLLocation(latitude: 37.498206, longitude: 127.02761)
fetchForecast(location: location) { (result) in
    print(result)
    print("success")
}

print("end")
