//
//  LocationTranslator.swift
//  SPWeatherApp
//
//  Created by David_Lam on 26/9/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

struct LocationTranslator {
    static func translateFromNetworkResponse(data: Data) -> Result<[Location], Error> {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try decoder.decode(LocationNetworkResponse.self, from: data)
            return Result.success(response.searchApi.result)

        } catch {
            return Result.failure(error)
        }
    }
}
