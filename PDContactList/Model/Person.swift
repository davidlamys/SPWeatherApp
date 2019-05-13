//
//  Person.swift
//  PDContactList
//
//  Created by David_Lam on 12/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

struct Person {
    let id: Int
    let name: String
    let email: [Email]
    
    struct Email {
        let value: String
        let primary: Bool
    }
}

extension Person {
    var primaryEmail: String? {
        return email
            .filter { $0.primary }
            .map { $0.value }
            .first
    }
}

extension Person: Codable {}
extension Person: Equatable {}
extension Person.Email: Codable {}
extension Person.Email: Equatable {}
