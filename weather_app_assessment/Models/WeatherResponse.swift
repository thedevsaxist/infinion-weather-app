//
//  WeatherResponse.swift
//  weather_app_assessment
//
//  Created by Chidiebube Praise Iroezindu on 20/11/2025.
//

import Foundation

struct WeatherResponse: Codable, Equatable {
    struct Weather: Codable, Equatable {
        let description: String
    }
    struct Main: Codable, Equatable {
        let temp: Double
    }
    
    let weather: [Weather]
    let main: Main
}
