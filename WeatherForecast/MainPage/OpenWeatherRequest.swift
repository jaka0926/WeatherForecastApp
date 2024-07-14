//
//  OpenWeatherRequest.swift
//  WeatherForecast
//
//  Created by Jaka on 2024-07-13.
//

import Alamofire
import Foundation


enum OpenWeatherRequest {
    case weatherCurrent(lat: Double, lon: Double)
    case weatherForecast(lat: Double, lon: Double)
    
    var baseURL: String {
        return "https://api.openweathermap.org/data/2.5/"
    }
    
    var endpoint: URL {
        switch self {
        case .weatherCurrent:
            return URL(string: baseURL + "weather")!
        case .weatherForecast:
            return URL(string: baseURL + "forecast")!
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters {
        switch self {
        case .weatherCurrent(let lat, let lon), .weatherForecast(let lat, let lon):
            return [
                "lat": "\(lat)",
                "lon": "\(lon)",
                "appid": APIKey.weather,
                "units": "metric",
                "lang": "kr"
            ]
        }
    }
}
