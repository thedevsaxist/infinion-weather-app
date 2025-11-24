//
//  DetailViewController.swift
//  weather_app_assessment
//
//  Created by Chidiebube Praise Iroezindu on 20/11/2025.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    var viewModel: DetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(viewModel.weather.weather.first?.description ?? "")
        
        print("\(viewModel.weather.main.temp)°C")
        
        descriptionLabel.text = "Description \(viewModel.weather.weather.first!.description)"
        tempLabel.text = "Temperature at \(viewModel.weather.main.temp)°C"
    }
}
