//
//  HomeViewModel.swift
//  weather_app_assessment
//
//  Created by Chidiebube Praise Iroezindu on 20/11/2025.
//

import Foundation

class HomeViewModel {
    var service: WeatherServiceProtocol
    var cityStorage: CityStorage
    
    var weatherLoaded: ((WeatherResponse) -> Void)?
    var errorOccured: ((String) -> Void)?
    
    init(service: WeatherServiceProtocol, storage: CityStorage) {
        self.service = service
        self.cityStorage = storage
    }
    
    
    func fetchWeather(city: String, completion: @escaping (WeatherResponse?) -> Void) {
        service.fetchWeather(for: city) { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let weather): self.weatherLoaded?(weather)
                    case .failure(let error): self.errorOccured?(error.localizedDescription)
                }
            }
        }
    }
    
    func getSaveCity() -> String {
        cityStorage.get()
    }
    
    func saveCity(_ city: String) {
        cityStorage.save(city: city)
    }
}
