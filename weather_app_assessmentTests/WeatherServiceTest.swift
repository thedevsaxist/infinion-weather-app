//
//  WeatherServiceTest.swift
//  weather_app_assessmentTests
//
//  Created by Chidiebube Praise Iroezindu on 24/11/2025.
//

import XCTest
@testable import weather_app_assessment // replace with your module name

protocol URLSessionProtocol {
    func dataTask(
        with url: URL,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

// Conform real URLSessionDataTask
extension URLSessionDataTask: URLSessionDataTaskProtocol {}

extension URLSession: URLSessionProtocol {
    func dataTask(
        with url: URL,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskProtocol {
        return (dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
}

class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    func resume() { /* do nothing */ }
}


// Mock
class URLSessionMock: URLSessionProtocol {
    var data: Data?
    var error: Error?
    
    func dataTask(
        with url: URL,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskProtocol {
        completionHandler(data, nil, error)
        return URLSessionDataTaskMock()
    }
}

// MARK: - Modified WeatherService for DI
class WeatherServiceMockable: WeatherServiceProtocol {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=FAKE_KEY&units=metric"
        guard let url = URL(string: urlString) else { return }
        
        session.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

// MARK: - Test Case
final class WeatherServiceTests: XCTestCase {
    
    var service: WeatherServiceMockable!
    var sessionMock: URLSessionMock!
    
    override func setUp() {
        super.setUp()
        sessionMock = URLSessionMock()
        service = WeatherServiceMockable(session: sessionMock)
    }
    
    override func tearDown() {
        service = nil
        sessionMock = nil
        super.tearDown()
    }
    
    func testFetchWeatherSuccess() {
        let jsonString = """
        {
            "name": "London",
            "main": {"temp": 25.0},
            "weather": [{"description": "Sunny"}]
        }
        """
        sessionMock.data = jsonString.data(using: .utf8)
        
        let expectation = XCTestExpectation(description: "Fetch weather success")
        
        service.fetchWeather(for: "London") { result in
            switch result {
                case .success(let response):
                    XCTAssertEqual(response.main.temp, 25.0)
                    XCTAssertEqual(response.weather.first?.description, "Sunny")
                case .failure(let error):
                    XCTFail("Expected success, got error: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchWeatherFailure() {
        sessionMock.error = NSError(domain: "NetworkError", code: -1)
        
        let expectation = XCTestExpectation(description: "Fetch weather failure")
        
        service.fetchWeather(for: "London") { result in
            switch result {
                case .success:
                    XCTFail("Expected failure, got success")
                case .failure(let error as NSError):
                    XCTAssertEqual(error.domain, "NetworkError")
                default:
                    XCTFail("Unexpected error")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
