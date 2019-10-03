//
//  LocalStorageProviderTests.swift
//  SPWeatherAppTests
//
//  Created by David_Lam on 20/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import XCTest
import CoreData

@testable import SPWeatherApp

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
    }

    func testGetListItemShouldReturnCorrectItems() {
        subject.insertItem(item: stubPayload.first!)

        let expectation = XCTestExpectation(description: "Fetching from local storage")
        subject.getListItemsFromLocal { result in
            XCTAssert(result == [stubPayload.first])
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
    
    func testInsertingItemsShouldComeFirst() {
        subject.insertItem(item: stubPayload.last!)
        subject.insertItem(item: stubPayload.first!)
        
        let expectation = XCTestExpectation(description: "Fetching from local storage")
        subject.getListItemsFromLocal { result in
            XCTAssert(result == [stubPayload.first, stubPayload.last])
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testInsertingSameItemsShouldRearrangeList() {
        subject.insertItem(item: stubPayload.last!)
        subject.insertItem(item: stubPayload.first!)
        subject.insertItem(item: stubPayload.last!)
        
        let expectation = XCTestExpectation(description: "Fetching from local storage")
        subject.getListItemsFromLocal { result in
            XCTAssert(result == [stubPayload.last, stubPayload.first])
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testInsertingPastLimitShouldRemoveOldestData() {
        subject = LocalStorageProvider(userDefaults: testUserDefaults, limit: 1)
        subject.insertItem(item: stubPayload.last!)
        subject.insertItem(item: stubPayload.first!)
        
        let expectation = XCTestExpectation(description: "Fetching from local storage")
          subject.getListItemsFromLocal { result in
              XCTAssert(result == [stubPayload.first])
              expectation.fulfill()
          }
          
          wait(for: [expectation], timeout: 5.0)
    }
}
