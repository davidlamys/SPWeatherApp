//
//  DataProviderTests.swift
//  PDContactListTests
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import XCTest
@testable import PDContactList

class DataProviderTests: XCTestCase {
    var subject: DataProvider!
    var networkClientStub: NetworkClientStub!
    var localStorageProviderMock: LocalStorageProviderMock!
    
    override func setUp() {
        super.setUp()
        networkClientStub = NetworkClientStub()
        localStorageProviderMock = LocalStorageProviderMock()
        subject = DataProvider(clientType: networkClientStub,
                               localStorageProvider: localStorageProviderMock)
        
    }
    
    override func tearDown() {
        super.tearDown()
        networkClientStub.reset()
        localStorageProviderMock.reset()
    }
    
    func testWhenFetchingContactListUnderGoodNetwork() {
        networkClientStub.setupForGetContactListUnderGoodNetwork()
        let expectation = XCTestExpectation(description: "Calling stub network client")

        subject.fetchContactLists { (person, dataSource) in
            assert(person == stubPayload)
            assert(dataSource == .network)
            assert(self.localStorageProviderMock.saveContactListCalledWithData == stubPayload)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        
    }
    
    func testWhenFetchingContactListWithNetworkError() {
        networkClientStub.setupForNetworkError()
        localStorageProviderMock.setupStorageWithStubList()
        let expectation = XCTestExpectation(description: "Calling stub network client")
        
        subject.fetchContactLists { (person, dataSource) in
            assert(person == stubPayload)
            assert(dataSource == .local)
            assert(self.localStorageProviderMock.saveContactListCalledWithData == nil)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)

    }

}
