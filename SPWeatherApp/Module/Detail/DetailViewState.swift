//
//  DetailViewState.swift
//  SPWeatherApp
//
//  Created by David_Lam on 2/10/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

enum DetailViewState {
    case loadingWeather
    case loaded(weather: WeatherCondition)
    case loadedIcon(imageData: Data)
    case error
}

extension DetailViewState: Equatable {}
