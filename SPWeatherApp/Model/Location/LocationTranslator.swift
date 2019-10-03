//
//  LocationTranslator.swift
//  SPWeatherApp
//
//  Created by David_Lam on 26/9/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

// This is fragile but...time is limited
let noResultErrorMessage = "Unable to find any matching weather location to the query submitted!"

struct LocationTranslator {
    static func translateFromNetworkResponse(data: Data) -> Result<[Location], Error> {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try decoder.decode(LocationNetworkResponse.self, from: data)
            return Result.success(response.searchApi.result)
        } catch {
            let result = translateErrorMessageFromNetworkResponse(data: data)
            switch result {
            case .success(let errorMessage):
                if errorMessage == noResultErrorMessage {
                    return Result.success([])
                }
            default:
                break
            }
            return Result.failure(error)
        }
    }
    
    static func translateErrorMessageFromNetworkResponse(data: Data) -> Result<String, Error> {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try decoder.decode(LocationNetworkErrorResponse.self, from: data)
            if let errorMessage = response.errorMessage {
                return Result.success(errorMessage)
            } else {
                let unknownError = NSError.init(domain: "com.david.SPWeatherApp", code: -1, userInfo: ["info": "unknown network error"])
                return Result.failure(unknownError)
            }
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
