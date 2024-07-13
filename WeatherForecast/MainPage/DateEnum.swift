//
//  DateEnum.swift
//  WeatherForecast
//
//  Created by Jaka on 2024-07-14.
//

import Foundation

let calendar = Calendar.current
func formatter(_ date: Date) -> String {
    return date.formatted(date: .numeric, time: .omitted)
}

enum getDate {
    
    static let today = formatter(Date())
    static let day2 = formatter(calendar.date(byAdding: .day, value: 1, to: Date())!)
    static let day3 = formatter(calendar.date(byAdding: .day, value: 2, to: Date())!)
    static let day4 = formatter(calendar.date(byAdding: .day, value: 3, to: Date())!)
    static let day5 = formatter(calendar.date(byAdding: .day, value: 4, to: Date())!)
}
