//
//  PersonTranslatorTests.swift
//  TWNewsReaderTests
//
//  Created by David_Lam on 12/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import XCTest
@testable import TWNewsReader

class PersonTranslatorTests: XCTestCase {
    var response: Any!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        response = ResponseLoader.loadLocalResponse(file: "StubPDResponse")
    }

    func testPersonTranslatorReturnsArrayOfPerson() {
        let translationResult = PersonTranslator.translateFromNetworkResponse(data: response as! Data)
        guard case .success(let persons) = translationResult else {
            XCTFail("failed to parse from stub response")
            return
        }

        let expectedPerson = Person(id: 3,
                                    name: "Linn Linda",
                                    orgId: Person.Organization(name: "Drivepipe",
                                                               peopleCount: 1,
                                                               address: "Dr. Atl 123, Santa María La Ribera, Mexico City, CDMX, Mexico"),
                                    phone: [Person.Phone(label: "Work", value: "1222222222222", primary: true)],
                                    email: [Person.Email(label: "work", value: "d@c.com", primary: true)])
        assert(persons[2] == expectedPerson) // this person is chosen because of completeness of data
        assert(persons.count == 4)
    }
}
