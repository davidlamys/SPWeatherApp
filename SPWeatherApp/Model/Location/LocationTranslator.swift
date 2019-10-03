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
    
    static func translateFromUserDefaults(data: Data) -> Result<[Location], Error> {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let persons = try decoder.decode([Location].self, from: data)
            return Result.success(persons)
            
        } catch let err {
            return Result.failure(err)
        }
    }
    
    static func translateToData(from array: [Location]) -> Result<Data, Error> {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        do {
            let encoded = try encoder.encode(array)
            return Result.success(encoded)
        } catch {
            return Result.failure(error)
        }
    }
}
