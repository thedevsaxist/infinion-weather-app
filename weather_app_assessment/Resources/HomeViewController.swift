//
//  HomeViewController.swift
//  weather_app_assessment
//
//  Created by Chidiebube Praise Iroezindu on 20/11/2025.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var cityTextField: UITextField!
    
    var viewModel: HomeViewModel!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        viewModel = HomeViewModel(
            service: WeatherService(), 
            storage: CityStorage()
        )
        
        cityTextField.text = viewModel.getSaveCity()
        
        viewModel.weatherLoaded = { [weak self] weather in
            self?.performSegue(withIdentifier: "detailSegue", sender: weather)
        }
        
        viewModel.errorOccured = { error in print(error) }
    }
    
    
    @IBAction func searchPressed(_ sender: Any) {
        print("Search pressed... loading")
        let city = cityTextField.text ?? ""
        viewModel.saveCity(city)
        viewModel.fetchWeather(city: city) { weather in
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "detailSegue", sender: weather)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue",
           let detailVC = segue.destination as? DetailViewController,
           let weather = sender as? WeatherResponse {
            detailVC.viewModel = DetailViewModel(weather: weather)
        }
    }
}
