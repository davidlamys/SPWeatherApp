//
//  NetworkClientTests.swift
//  TWNewsReaderTests
//
//  Created by David_Lam on 27/9/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import XCTest
@testable import TWNewsReader

class NetworkClientTests: XCTestCase {
    var subject: NetworkClient!
    var sessionStub: SessionStub!
    let translator = Translator.translateFromNetworkResponse
    override func setUp() {
        super.setUp()
        sessionStub = SessionStub()
        subject = NetworkClient(session: sessionStub)
    }
    
    func testWhenURLRequestIsSuccessful() {
        sessionStub.setupForGetListItemsUnderGoodNetwork()
        let expectation = XCTestExpectation(description: "Calling stub session")
        let resultHandler: (Result<[Post], Error>) -> Void = { resultType in
            switch resultType {
            case .success(let posts):
                assert(posts.count == 100)
                expectation.fulfill()
            default:
                assertionFailure("expected success")
            }
        }
        subject.request(request: .fetchListItems, translator: translator, completion: resultHandler)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testWhenURLRequestHasError() {
        sessionStub.setupForNetworkError()
        let expectation = XCTestExpectation(description: "Calling stub session")
        let resultHandler: (Result<[Post], Error>) -> Void = { resultType in
            switch resultType {
            case .failure(let error):
                let expectedError = NSError(domain: "some error", code: 1, userInfo: [:])
                assert(error as! NSError == expectedError)
                expectation.fulfill()
            default:
                assertionFailure("expected success")
            }
        }
        subject.request(request: .fetchListItems, translator: translator, completion: resultHandler)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testWhenURLRequestHasNoErrorAndNoData() {
        let expectation = XCTestExpectation(description: "Calling stub session")
        let resultHandler: (Result<[Post], Error>) -> Void = { resultType in
            switch resultType {
            case .failure(let error):
                let expectedError = NSError.init(domain: "com.david.TWNewsReader", code: -1, userInfo: ["info": "unknown network error"])
                assert(error as! NSError == expectedError)
                expectation.fulfill()
            default:
                assertionFailure("expected success")
            }
        }
        
        subject.request(request: .fetchListItems, translator: translator, completion: resultHandler)
        wait(for: [expectation], timeout: 5.0)
    }
}
