//
//  WeatherTranslator.swift
//  SPWeatherApp
//
//  Created by David_Lam on 26/9/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

struct WeatherTranslator {
    static func translateFromNetworkResponse(data: Data) -> Result<WeatherCondition, Error> {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(WeatherNetworkResponse.self, from: data)
            return Result.success(response.data.currentCondition.first!)

        } catch {
            return Result.failure(error)
        }
    }
}

