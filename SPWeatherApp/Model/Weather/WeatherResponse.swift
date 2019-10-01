//
//  WeatherResponse.swift
//  SPWeatherApp
//
//  Created by David_Lam on 1/10/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

struct WeatherNetworkResponse: Codable {
    let data: Data
    struct Data: Codable {
        let currentCondition: [WeatherCondition]
        
        enum CodingKeys: String, CodingKey {
             case currentCondition = "current_condition"
         }
    }
}
