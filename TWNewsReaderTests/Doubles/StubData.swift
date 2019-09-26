//
//  StubData.swift
//  TWNewsReaderTests
//
//  Created by David_Lam on 17/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//
import UIKit

@testable import TWNewsReader

let stubOrg = Person.Organization(name: "Drivepipe",
                                  peopleCount: 1,
                                  address: "Dr. Atl 123, Santa María La Ribera, Mexico City, CDMX, Mexico")

let stubPhone = Person.Phone(label: "Work", value: "122-333-5577", primary: true)
let stubEmail = Person.Email(label: "Work", value: "david.lam@drivepipe.com", primary: true)

let stubPayload = [
    Person(id: 1, name: "David", orgId: stubOrg, phone:[stubPhone], email: [stubEmail]),
    Person(id: 2, name: "Mirjam", orgId: stubOrg, phone:[], email: [])
]
