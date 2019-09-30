//
//  Location.swift
//  SPWeatherApp
//
//  Created by David_Lam on 30/9/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

struct Location {
    let areaName: KeyValueArray
    let country: KeyValueArray
    private let latitude: String
    private let longitude: String
    
    init(areaName: String, country: String, lat: Double, lon: Double) {
        self.areaName = [["Value": areaName]]
        self.country = [["Value": country]]
        self.latitude = "\(lat)"
        self.longitude = "\(lon)"
    }
}

extension Location: Codable {}
extension Location: Equatable {}
extension Location {
    var cityName: String? {
        return areaName.firstValue
    }
    var cityCountry: String? {
        return country.firstValue
    }
    var lat: Double? {
        return Double(latitude)
    }
    var lon: Double? {
        return Double(longitude)
    }
}
