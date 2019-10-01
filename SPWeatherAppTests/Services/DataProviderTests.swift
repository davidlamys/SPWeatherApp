//
//  DataProviderTests.swift
//  SPWeatherAppTests
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import XCTest
@testable import SPWeatherApp

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

    func testWhenFetchingListItemsUnderGoodNetwork() {
        networkClientStub.setupForGetListItemsUnderGoodNetwork()
        let expectation = XCTestExpectation(description: "Calling stub network client")

        subject.fetchListItems(query: "Singapore") { result in
            assert(self.networkClientStub.calledWith == RequestType.fetchListItems(query: "Singapore"))
            assert(result == FetchListItemsResultType.successFromNetwork(items: stubPayload))
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)

    }

    func testWhenFetchingListItemsWithNetworkError() {
        networkClientStub.setupForNetworkError()
        localStorageProviderMock.setupStorageWithStubList()
        let expectation = XCTestExpectation(description: "Calling stub network client")

        subject.fetchListItems(query: "Singapore") { result in
            assert(result == FetchListItemsResultType.failed)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)

    }

}
