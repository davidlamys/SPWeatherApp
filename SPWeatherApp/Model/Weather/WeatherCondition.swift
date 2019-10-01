//
//  Weather.swift
//  SPWeatherApp
//
//  Created by David_Lam on 1/10/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

struct WeatherCondition: Codable {
    let humidity: String
    let tempC: String
    let tempF: String
    private let weatherDesc: KeyValueArray
    private let weatherIconURL: KeyValueArray
    
    init(humidity: String,
         tempC: String,
         tempF: String,
         weatherDesc: String,
         weatherIconURL: String) {
        self.humidity = humidity
        self.tempC = tempC
        self.tempF = tempF
        self.weatherDesc = [["value": weatherDesc]]
        self.weatherIconURL = [["value": weatherIconURL]]
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        humidity = try container.decode(String.self, forKey: .humidity)
        tempC = try container.decode(String.self, forKey: .tempC)
        tempF = try container.decode(String.self, forKey: .tempF)
        weatherDesc = try container.decode(KeyValueArray.self, forKey: .weatherDesc)
        weatherIconURL = try container.decode(KeyValueArray.self, forKey: .weatherIconURL)
    }
    
    enum CodingKeys: String, CodingKey {
        case humidity = "humidity"
        case tempC = "temp_C"
        case tempF = "temp_F"
        case weatherDesc = "weatherDesc"
        case weatherIconURL = "weatherIconUrl"
    }
}

extension WeatherCondition: Equatable {}

extension WeatherCondition {
    var weatherDescription: String? {
        return weatherDesc.firstValue
    }
    var iconURL: URL? {
        guard let urlString = weatherIconURL.firstValue else {
            return nil
        }
        return URL(string: urlString)
    }
}
