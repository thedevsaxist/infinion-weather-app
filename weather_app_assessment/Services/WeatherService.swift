//
//  WeatherService.swift
//  weather_app_assessment
//
//  Created by Chidiebube Praise Iroezindu on 20/11/2025.
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void)
}

class WeatherService
: WeatherServiceProtocol
{
    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
        
        print("Api key being used: \(apiKey ?? "88986e3b1dd74ae25d8cf033a423c23a")")
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey ?? "88986e3b1dd74ae25d8cf033a423c23a")&units=metric"
        
        print("url sent: \(urlString)")
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error { completion(.failure(error)); print(error); return}
            
            guard let data = data else {return}
                        
            do {
                let decoded = try JSONDecoder().decode(WeatherResponse
                    .self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
}
