//
//  PersonTranslator.swift
//  PDContactList
//
//  Created by David_Lam on 12/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

struct PersonTranslator {
    static func translateFrom(networkResponse: Data) -> Result<[Person], Error> {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(PDNetworkResponse.self, from: networkResponse)
            let persons = response.data
            return Result.success(persons)
            
        } catch let err {
            return Result.failure(err)
        }
    }
}
