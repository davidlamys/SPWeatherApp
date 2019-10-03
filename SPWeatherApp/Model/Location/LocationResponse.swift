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

struct LocationNetworkErrorResponse: Codable {
    private let data: Error
    struct Error: Codable {
        let error: KeyValueArray
    }
    
    init(errorMessage: String) {
        self.data = Error(error: [["msg": errorMessage]])
    }
}

extension LocationNetworkErrorResponse {
    var errorMessage: String? {
        return data.error.firstValue
    }
}
