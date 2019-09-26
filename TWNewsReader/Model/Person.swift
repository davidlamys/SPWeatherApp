//
//  Person.swift
//  TWNewsReader
//
//  Created by David_Lam on 12/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

struct Person {
    let id: Int
    let name: String
    let orgId: Organization?
    let phone: [Phone]
    let email: [Email]

    struct Organization {
        let name: String
        let peopleCount: Int?
        let address: String?
    }

    struct Phone {
        let label: String?
        let value: String
        let primary: Bool
    }

    struct Email {
        let label: String?
        let value: String
        let primary: Bool
    }

}

extension Person {
    var primaryEmail: Email? {
        return email
            .filter { $0.primary }
            .first
    }

    var primaryPhone: Phone? {
        return phone
            .filter { $0.primary }
            .first
    }
}

extension Person: Codable {}
extension Person: Equatable {}
extension Person.Organization: Codable {}
extension Person.Organization: Equatable {}
extension Person.Phone: Codable {}
extension Person.Phone: Equatable {}
extension Person.Email: Codable {}
extension Person.Email: Equatable {}
