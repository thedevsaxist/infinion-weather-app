//
//  CityStorage.swift
//  weather_app_assessment
//
//  Created by Chidiebube Praise Iroezindu on 20/11/2025.
//

import Foundation

class CityStorage {
     private let key = "favorite-city"
    
    func save(city: String){
        UserDefaults.standard.set(city, forKey: key)
    }
    
    func get() -> String {
        UserDefaults.standard.string(forKey: key) ?? ""
    }
}
