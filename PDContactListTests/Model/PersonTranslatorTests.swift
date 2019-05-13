//
//  PersonTranslatorTests.swift
//  PDContactListTests
//
//  Created by David_Lam on 12/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import XCTest
@testable import PDContactList

class PersonTranslatorTests: XCTestCase {
    var response: Any!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        response = ResponseLoader.loadLocalResponse(file: "StubPDResponse")
    }

    func testPersonTranslatorReturnsArrayOfPerson() {
        let translationResult = PersonTranslator.translateFrom(networkResponse: response as! Data)
        guard case .success(let persons) = translationResult else {
            XCTFail("failed to parse from stub response")
            return
        }
        let expectedPerson = Person(id: 1, name: "David Lam", email: [Person.Email(value: "", primary: true)])
        assert(persons.first! == expectedPerson)
        assert(persons.count == 4)
    }
}
