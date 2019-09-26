//
//  TWNetworkResponseTranslator.swift
//  TWNewsReader
//
//  Created by David_Lam on 19/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

struct TWNetworkResponseTranslator {
    static func translateFromNetworkResponse(data: Data) -> Result<NetworkResponse, Error> {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try decoder.decode(NetworkResponse.self, from: data)
            return Result.success(response)

        } catch {
            return Result.failure(error)
        }
    }
}
