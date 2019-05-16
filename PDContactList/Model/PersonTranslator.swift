//
//  PersonTranslator.swift
//  PDContactList
//
//  Created by David_Lam on 12/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

struct PersonTranslator {
    static func translateFromNetworkResponse(data: Data) -> Result<[Person], Error> {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try decoder.decode(PDNetworkResponse.self, from: data)
            let persons = response.data
            return Result.success(persons)
            
        } catch let err {
            return Result.failure(err)
        }
    }
    
    static func translateFromUserDefaults(data: Data) -> Result<[Person], Error> {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let persons = try decoder.decode([Person].self, from: data)
            return Result.success(persons)
            
        } catch let err {
            return Result.failure(err)
        }
    }
    
    static func translateToData(from array: [Person]) -> Result<Data, Error> {
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
