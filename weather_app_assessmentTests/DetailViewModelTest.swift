//
//  DetailViewModelTest.swift
//  weather_app_assessmentTests
//
//  Created by Chidiebube Praise Iroezindu on 24/11/2025.
//

import XCTest
@testable import weather_app_assessment // replace with your module name

final class DetailViewModelTests: XCTestCase {
    
    func testInitStoresWeather() {
        // Prepare sample weather
        let sampleWeather = WeatherResponse(
            weather: [WeatherResponse.Weather(description: "Cloudy")], main: WeatherResponse.Main(temp: 22.0)
        )
        
        // Initialize the ViewModel
        let viewModel = DetailViewModel(weather: sampleWeather)
        
        // Verify it stores the correct weather
        XCTAssertEqual(viewModel.weather.main.temp, 22.0)
        XCTAssertEqual(viewModel.weather.weather.first?.description, "Cloudy")
    }
}

