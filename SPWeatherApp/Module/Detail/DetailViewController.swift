//
//  DetailViewController.swift
//  SPWeatherApp
//
//  Created by David_Lam on 17/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import UIKit

protocol DetailViewControllerType: class {
    func setupView(item: Item)
    func setupView(state: DetailViewState)
}

final class DetailViewController: UIViewController {

    enum Text: String {
        case loadingText = "Loading.."
        case temperatureText = "The temperature is %@."
        case humidityText = "The humidity is %@."
    }
    
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var loadingStackView: UIStackView!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    var viewPresenter: DetailViewPresenterType!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewPresenter.viewDidLoad()
        weatherIconImageView.layer.cornerRadius = 10.0
        setupAccessibilityIdentifer()
    }
    
    private func setupAccessibilityIdentifer() {
        loadingStackView.accessibilityIdentifier = "loadingStackView"
        weatherIconImageView.accessibilityIdentifier = "weatherIconImageView"
        weatherDescriptionLabel.accessibilityIdentifier = "weatherDescriptionLabel"
        temperatureLabel.accessibilityIdentifier = "temperatureLabel"
        humidityLabel.accessibilityIdentifier = "humidityLabel"
    }
}

extension DetailViewController: DetailViewControllerType {
    func setupView(item: Item) {
        if Thread.isMainThread {
            setupViewOnMainThread(item: item)
        } else {
            DispatchQueue.main.async {
                self.setupViewOnMainThread(item: item)
            }
        }
    }

    func setupView(state: DetailViewState) {
        if Thread.isMainThread {
            setupViewOnMainThread(state: state)
        } else {
            DispatchQueue.main.async {
                self.setupViewOnMainThread(state: state)
            }
        }
    }
    
    private func setupViewOnMainThread(item: Item) {
        precondition(Thread.isMainThread)
        title = item.cityName
    }
    
    private func setupViewOnMainThread(state: DetailViewState) {
        switch state {
        case .loadingWeather:
            loadingStackView.isHidden = false
            loadingLabel.text = Text.loadingText.rawValue
            weatherIconImageView.isHidden = true
            weatherDescriptionLabel.isHidden = true
            temperatureLabel.isHidden = true
            humidityLabel.isHidden = true
            
        case .loaded(let weather):
            loadingStackView.isHidden = false
            weatherIconImageView.isHidden = true
            
            weatherDescriptionLabel.isHidden = false
            weatherDescriptionLabel.text = weather.weatherDescription
            
            temperatureLabel.isHidden = false
            temperatureLabel.text = String(format: Text.temperatureText.rawValue, weather.tempC)
            
            humidityLabel.isHidden = false
            humidityLabel.text = String(format: Text.humidityText.rawValue, weather.humidity)
        case .loadedIcon(let imageData):
            loadingStackView.isHidden = true
            if let image = UIImage(data: imageData) {
                weatherIconImageView.isHidden = false
                weatherIconImageView.image = image
            }
        default:
            break
        }
    }

}
