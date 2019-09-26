//
//  LocalStorageProviderTests.swift
//  TWNewsReaderTests
//
//  Created by David_Lam on 20/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//


import XCTest
@testable import TWNewsReader

class LocalStorageProviderTests: XCTestCase {
    var subject: LocalStorageProvider!
    var testUserDefaults: UserDefaults!

    override func setUp() {
        super.setUp()

        testUserDefaults = UserDefaultsMock()
        subject = LocalStorageProvider(userDefaults: testUserDefaults)
    }

    override func tearDown() {
        super.tearDown()
       UserDefaults().removePersistentDomain(forName: "testUserDefaults")
    }

    func testUpsertDoesNotOverride() {
        subject.insertContactList(data: [stubPayload[0]])
        subject.insertContactList(data: [stubPayload[1]])

        let expectation = XCTestExpectation(description: "Fetching from local storage")
        subject.getContactListFromLocal { result in
            assert(result == stubPayload)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
