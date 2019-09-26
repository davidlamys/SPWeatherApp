//
//  NetworkResponse.swift
//  TWNewsReader
//
//  Created by David_Lam on 12/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

struct NetworkResponse: Codable {
    let success: Bool
    let data: [Person]?
    let additionalData: AdditionalData?
    let error: String?
    let errorCode: Int?
    let redirectUrl: String?

    struct AdditionalData: Codable {
        let pagination: Pagination?
        struct Pagination: Codable {
            let start: Int
            let limit: Int
            let moreItemsInCollection: Bool
            let nextStart: Int?
        }
    }
}

extension NetworkResponse {
    var hasMoreItems: Bool {
        return additionalData?.pagination?.moreItemsInCollection ?? false
    }
    var hasReachedRateLimit: Bool {
        guard let errorCode = errorCode else {
            return false
        }
        return errorCode == 429
    }
}
