//
//  OpenWeatherRequest.swift
//  WeatherForecast
//
//  Created by Jaka on 2024-07-13.
//

import Alamofire
import Foundation

enum OpenWeatherRequest {
    case weatherCurrent
    case weatherForecast
    
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
    
    var parameter: Parameters {
        return ["lat":"37.5833", "lon":"127.0", "appid": APIKey.weather, "units": "metric", "lang": "kr"]
    }
}
