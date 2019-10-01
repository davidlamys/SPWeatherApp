//
//  LocationResponse.swift
//  SPWeatherApp
//
//  Created by David_Lam on 30/9/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

struct LocationNetworkResponse: Codable {
    let searchApi: Result
    struct Result: Codable {
        let result: [Location]
    }
}
