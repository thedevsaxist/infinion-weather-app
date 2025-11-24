//
//  HomeViewModelTest.swift
//  weather_app_assessmentTests
//
//  Created by Chidiebube Praise Iroezindu on 24/11/2025.
//

import XCTest
@testable import weather_app_assessment // replace with your module name

// MARK: - Mock Weather Service
class WeatherServiceMock: WeatherServiceProtocol {
    var shouldReturnError = false
    var weatherToReturn: WeatherResponse?
    
    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "TestError", code: -1)))
        } else if let weather = weatherToReturn {
            completion(.success(weather))
        }
    }
}

// MARK: - Mock Storage
class CityStorageMock: CityStorage {
    private var storedCity: String = ""
    
    override func save(city: String) {
        storedCity = city
    }
    
    override func get() -> String {
        storedCity
    }
}

// MARK: - Test Case
final class HomeViewModelTests: XCTestCase {
    
    var viewModel: HomeViewModel!
    var serviceMock: WeatherServiceMock!
    var storageMock: CityStorageMock!
    
    override func setUp() {
        super.setUp()
        serviceMock = WeatherServiceMock()
        storageMock = CityStorageMock()
        viewModel = HomeViewModel(service: serviceMock, storage: storageMock)
    }
    
    override func tearDown() {
        viewModel = nil
        serviceMock = nil
        storageMock = nil
        super.tearDown()
    }
    
    func testFetchWeatherSuccess() {
        let expectation = XCTestExpectation(description: "Weather loaded")
        let sampleWeather = WeatherResponse(
            weather: [WeatherResponse.Weather(description: "Sunny")], main: WeatherResponse.Main(temp: 20.0)
        )
        serviceMock.weatherToReturn = sampleWeather
        
        viewModel.weatherLoaded = { weather in
            XCTAssertEqual(weather.main.temp, 20.0)
            XCTAssertEqual(weather.weather.first?.description, "Sunny")
            expectation.fulfill()
        }
        
        viewModel.fetchWeather(city: "London") { _ in }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchWeatherFailure() {
        let expectation = XCTestExpectation(description: "Error occured")
        serviceMock.shouldReturnError = true
        
        viewModel.errorOccured = { error in
            XCTAssertEqual(error, "The operation couldn’t be completed. (TestError error -1.)")
            expectation.fulfill()
        }
        
        viewModel.fetchWeather(city: "London") { _ in }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSaveAndGetCity() {
        viewModel.saveCity("Paris")
        XCTAssertEqual(viewModel.getSaveCity(), "Paris")
    }
}

