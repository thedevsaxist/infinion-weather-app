//
//  HomeViewControllerTest.swift
//  weather_app_assessmentUITests
//
//  Created by Chidiebube Praise Iroezindu on 24/11/2025.
//

import XCTest
@testable import weather_app_assessment
import UIKit

// MARK: - Mock ViewModel
class HomeViewModelMock: HomeViewModel {
    var fetchCalled = false
    var savedCity: String?
    
    override func fetchWeather(city: String, completion: @escaping (WeatherResponse?) -> Void) {
        fetchCalled = true
        completion(nil)
    }
    
    override func saveCity(_ city: String) {
        savedCity = city
    }
}

// MARK: - Test Case
final class HomeViewControllerTests: XCTestCase {
    
    var viewController: HomeViewController!
    var viewModelMock: HomeViewModelMock!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        viewController.loadViewIfNeeded()
        
        viewModelMock = HomeViewModelMock(service: WeatherService(), storage: CityStorage())
        viewController.viewModel = viewModelMock
    }
    
    override func tearDown() {
        viewController = nil
        viewModelMock = nil
        super.tearDown()
    }
    
    func testCityTextFieldIsConnected() {
        XCTAssertNotNil(viewController.cityTextField)
    }
    
    func testSearchPressedCallsViewModel() {
        // Set a test city
        viewController.cityTextField.text = "London"
        
        // Simulate button press
        viewController.searchPressed(self)
        
        // Verify that fetchWeather and saveCity were called
        XCTAssertTrue(viewModelMock.fetchCalled)
        XCTAssertEqual(viewModelMock.savedCity, "London")
    }
    
    func testWeatherLoadedClosureTriggersSegue() {
        let expectation = XCTestExpectation(description: "Segue should be called")
        
        // Replace performSegue to intercept call
        class SegueInterceptorVC: HomeViewController {
            var segueCalled = false
            var senderObject: Any?
            override func performSegue(withIdentifier identifier: String, sender: Any?) {
                segueCalled = true
                senderObject = sender
            }
        }
        
        let interceptor = SegueInterceptorVC()
        interceptor.loadViewIfNeeded()
        interceptor.viewModel = viewModelMock
        
        // Simulate weather loaded callback
        let sampleWeather = WeatherResponse(
            weather: [WeatherResponse.Weather(description: "Sunny")], main: WeatherResponse.Main(temp: 25.0)
        )
        interceptor.viewModel.weatherLoaded?(sampleWeather)
        
        DispatchQueue.main.async {
            XCTAssertTrue(interceptor.segueCalled)
            XCTAssertEqual(interceptor.senderObject as? WeatherResponse, sampleWeather)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
