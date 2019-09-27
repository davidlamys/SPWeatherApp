//
//  LocalStorageProviderTests.swift
//  TWNewsReaderTests
//
//  Created by David_Lam on 20/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//


import XCTest
import CoreData

@testable import TWNewsReader

class LocalStorageProviderTests: XCTestCase {
    // source: https://medium.com/flawless-app-stories/cracking-the-tests-for-core-data-15ef893a3fee
    var mockPersistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TWNewsReader")
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
    
    var subject: LocalStorageProvider!
    var testUserDefaults: UserDefaults!

    override func setUp() {
        super.setUp()

        testUserDefaults = UserDefaultsMock()
        subject = LocalStorageProvider(container: mockPersistantContainer)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testInsertShouldStoreItems() {
        subject.insertListItems(data: stubPayload)
        assert(numberOfItemsInPersistentStore() == 2)
    }
    
//    func testGetListItemShouldReturnCorrectItems() {
//        subject.insertListItems(data: stubPayload)
//        
//        let expectation = XCTestExpectation(description: "Fetching from local storage")
//        subject.getListItemsFromLocal { result in
//            assert(result == stubPayload)
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 5.0)
//    }
//    
    //Convenient method for getting the number of data in store now
    func numberOfItemsInPersistentStore() -> Int {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PostObject")
        let results = try! mockPersistantContainer.viewContext.fetch(request)
        return results.count
    }
}
