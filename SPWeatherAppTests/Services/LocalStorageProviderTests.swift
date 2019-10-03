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
    // source: https://medium.com/flawless-app-stories/cracking-the-tests-for-core-data-15ef893a3fee
    var mockInMemoryPersistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SPWeatherApp")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env

        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )

            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()

    // source: https://stackoverflow.com/questions/45134431/is-nsinmemorystoretype-incompatible-with-nsbatchdeleterequest
    var devContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SPWeatherApp")
        container.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores { (_, error) in
            XCTAssertNil(error)
        }
        return container
    }()

    var subject: LocalStorageProvider!

    override func setUp() {
        super.setUp()
        subject = LocalStorageProvider(container: mockInMemoryPersistantContainer)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testInsertShouldStoreItems() {
        subject.insertListItems(data: stubPayload)
        XCTAssert(numberOfItemsInPersistentStore() == 2)
    }

    func testGetListItemShouldReturnCorrectItems() {
        subject.insertListItems(data: stubPayload)

        let expectation = XCTestExpectation(description: "Fetching from local storage")
        subject.getListItemsFromLocal { result in
            XCTAssert(result == stubPayload)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testDeleteItemsShouldDeleteItems() {
        // MARK: this creates a coupling between test and implementation. :( apparently batch delete only works on SQLLite stores 
        subject = LocalStorageProvider(container: devContainer)
        subject.insertListItems(data: stubPayload)
        subject.deleteListItems()

        XCTAssert(numberOfItemsInPersistentStore() == 0)
    }

    //Convenient method for getting the number of data in store now
    func numberOfItemsInPersistentStore() -> Int {
        let request: NSFetchRequest<NSFetchRequestResult> = PostObject.fetchRequest
        let results = try! mockInMemoryPersistantContainer.viewContext.fetch(request)
        return results.count
    }
}
