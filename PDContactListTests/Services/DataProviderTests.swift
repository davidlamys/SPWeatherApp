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
    
    func testWhenFetchingFirstPageContactListUnderGoodNetwork() {
        networkClientStub.setupForGetContactListUnderGoodNetwork()
        let expectation = XCTestExpectation(description: "Calling stub network client")

        subject.fetchContactLists(startIndex: 0) { resultType in
            assert(self.localStorageProviderMock.insertContactListCalledWithData == stubPayload)
            assert(self.localStorageProviderMock.deleteContactListCalled)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        
    }
    
    func testWhenFetchingSecondPageContactListUnderGoodNetwork() {
        networkClientStub.setupForGetContactListUnderGoodNetwork()
        let expectation = XCTestExpectation(description: "Calling stub network client")
        
        subject.fetchContactLists(startIndex: limit) { resultType in
            assert(self.localStorageProviderMock.insertContactListCalledWithData == stubPayload)
            assert(self.localStorageProviderMock.deleteContactListCalled == false)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        
    }
    func testWhenFetchingContactListWithNetworkError() {
        networkClientStub.setupForNetworkError()
        localStorageProviderMock.setupStorageWithStubList()
        let expectation = XCTestExpectation(description: "Calling stub network client")
        
        subject.fetchContactLists(startIndex: 0) { resultType in
            assert(self.localStorageProviderMock.getContactListCalled == true)
            assert(self.localStorageProviderMock.insertContactListCalledWithData == nil)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)

    }
    
    func testWhenFetchingImageUnderGoodNetwor() {
        networkClientStub.setupForGetImageUnderGoodNetwork()
        let expectation = XCTestExpectation(description: "Calling stub network client")
        
        subject.fetchImage(imageHash: "somehash", localFetchCompletion: { _ in
        }, networkFetchCompletion: { (data) in
            assert(self.localStorageProviderMock.saveImageCalledWith == (hash: "somehash", data: stubImageData))
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5.0)
    }

}
