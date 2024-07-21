//
//  OpenWeatherAPI.swift
//  WeatherForecast
//
//  Created by Jaka on 2024-07-13.
//
import Alamofire

// MARK: - WeatherCurrent
struct WeatherCurrent: Decodable {
    //let coord: Coord
    let weather: [WeatherData]
    let base: String
    let main: MainClass
    //let visibility: Int
    let wind: Wind
    //let rain: Rain
    let clouds: Clouds
    //let dt: Int
    //let sys: Sys
    //let timezone, id: Int
    let name: String
    //let cod: Int
}

// MARK: - Weather
struct WeatherData: Decodable {
    let id: Int
    let main, description, icon: String
}

// MARK: - Weather
struct Weather: Decodable {
    let list: [List]
}

// MARK: - City
struct City: Decodable  {
    let id: Int
    let name: String
//    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

// MARK: - Coord
//struct Coord: Decodable  {
//    let lat: Double
//    let lon: Int
//}

// MARK: - List
struct List: Decodable  {
    let dt: Int
    let main: MainClass
    let weather: [WeatherElement]
    let clouds: Clouds
    let wind: Wind
//    let visibility: Int
    let pop: Double
//    let rain: Rain?
//    let sys: Sys
    let dt_txt: String
}

// MARK: - Clouds
struct Clouds: Decodable  {
    let all: Int
}

// MARK: - MainClass
struct MainClass: Decodable  {
    let temp: Double
    //let feels_like, temp_min, temp_max: Double
    let pressure: Int
    let humidity: Int
        //sea_level, grnd_level: Int
//    let temp_kf: Double?
}

// MARK: - Rain
struct Rain: Decodable  {
    let the3H: Double
}

// MARK: - Sys
struct Sys: Decodable  {
    let pod: String
}

// MARK: - WeatherElement
struct WeatherElement: Decodable  {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// MARK: - Wind
struct Wind: Decodable  {
    let speed: Double
}

class OpenWeatherAPI {
    
    static let shared = OpenWeatherAPI()
    
    func weatherForecastRequest(api: OpenWeatherRequest, completionHandler: @escaping ([List]?, String?) -> Void) {
        
        AF.request(api.endpoint,
                   method: api.method,
                   parameters: api.parameters,
                   encoding: URLEncoding(destination: .queryString))
        .responseDecodable(of: Weather.self) { response in
                
            switch response.result {
            case .success(let value):
                print("SUCCESS+FORECAST")
                completionHandler(value.list, nil)
            case .failure(let error):
                print("FAILURE=FORECAST", error)
                completionHandler(nil, "잠시 후 다시 시도해주세요")
            }
        }
    }
    func weatherCurrentRequest(api: OpenWeatherRequest, completionHandler: @escaping (WeatherCurrent?, String?) -> Void) {
        
        AF.request(api.endpoint,
                   method: api.method,
                   parameters: api.parameters,
                   encoding: URLEncoding(destination: .queryString))
        .responseDecodable(of: WeatherCurrent.self) { response in
                
            switch response.result {
            case .success(let value):
                print("SUCCESS==CURRENT")
                completionHandler(value, nil)
            case .failure(let error):
                print("FAILURE=CURRENT", error)
                completionHandler(nil, "잠시 후 다시 시도해주세요")
            }
        }
    }
}
