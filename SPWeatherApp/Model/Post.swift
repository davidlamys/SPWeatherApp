//
//  Post.swift
//  SPWeatherApp
//
//  Created by David_Lam on 26/9/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

struct Post {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

extension Post: Codable {}
extension Post: Equatable {}
