//
//  WeatherResponse.swift
//  weather_app_assessment
//
//  Created by Chidiebube Praise Iroezindu on 20/11/2025.
//

import Foundation

struct WeatherResponse: Codable {
    struct Weather: Codable {
        let description: String
    }
    struct Main: Codable {
        let temp: Double
    }
    
    let weather: [Weather]
    let main: Main
}
