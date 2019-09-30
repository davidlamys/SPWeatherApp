//
//  PostTranslator.swift
//  SPWeatherApp
//
//  Created by David_Lam on 26/9/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

struct PostTranslator {
    static func translateFromNetworkResponse(data: Data) -> Result<[Post], Error> {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try decoder.decode([Post].self, from: data)
            return Result.success(response)

        } catch {
            return Result.failure(error)
        }
    }

    static func translateFromCoreDataObject(objects: [PostObject]) -> [Post] {
        return objects.map({
            Post(userId: $0.userId.intValue,
                 id: $0.id.intValue,
                 title: $0.title,
                 body: $0.body)
        })
    }
}
