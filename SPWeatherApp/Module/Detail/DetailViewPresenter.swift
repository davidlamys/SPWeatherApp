//
//  DetailViewPresenter.swift
//  SPWeatherApp
//
//  Created by David_Lam on 17/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

protocol DetailViewPresenterType {
    func viewDidLoad()
    var view: DetailViewControllerType! { get }
}

class DetailViewPresenter: DetailViewPresenterType {
    let dataProvider: DataProviderType
    let item: Item
    weak var view: DetailViewControllerType!

    init(dataProvider: DataProviderType = DataProvider(),
         item: Item,
         view: DetailViewControllerType) {
        self.dataProvider = dataProvider
        self.item = item
        self.view = view
    }

    func viewDidLoad() {
        view.setupView(item: item)
        view.setupView(state: .loadingWeather)
        dataProvider.fetchWeather(for: item, completion: fetchWeatherHandler)
    }

    private func fetchWeatherHandler(result: FetchWeatherResultType) {
        switch result {
        case .successFromNetwork(weatherCondition: let weather):
            view.setupView(state: .loaded(weather: weather))
            guard let weatherIconURLString = weather.iconURLString else {
                return
            }
            
            dataProvider.fetchIcon(urlString: weatherIconURLString,
                                   completion: fetchWeatherIconHandler)
        case .failed:
            view.setupView(state: .error)
        }
    }
    
    private func fetchWeatherIconHandler(result: FetchWeatherIconResultType) {
        switch result {
        case .successFromNetwork(let data):
            view.setupView(state: .loadedIcon(imageData: data))
        case .failed:
            view.setupView(state: .error)
        }
    }
}
