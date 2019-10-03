//
//  NetworkClientTests.swift
//  SPWeatherAppTests
//
//  Created by David_Lam on 27/9/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import XCTest
@testable import SPWeatherApp

class NetworkClientTests: XCTestCase {
    var subject: NetworkClient!
    var sessionStub: SessionStub!
    let translator = Translator.translateFromNetworkResponse
    let someRequest = RequestType.fetchListItems(query: "some query")
    override func setUp() {
        super.setUp()
        sessionStub = SessionStub()
        subject = NetworkClient(session: sessionStub)
    }

    func testWhenURLRequestIsSuccessful() {
        sessionStub.setupForGetListItemsUnderGoodNetwork()
        let expectation = XCTestExpectation(description: "Calling stub session")
        let resultHandler: (Result<Items, Error>) -> Void = { resultType in
            switch resultType {
            case .success(let locations):
                XCTAssert(locations.count == 10)
                expectation.fulfill()
            default:
                XCTFail("expected success")
            }
        }
        subject.request(request: someRequest, translator: translator, completion: resultHandler)
        wait(for: [expectation], timeout: 5.0)
    }

    func testWhenURLRequestHasError() {
        sessionStub.setupForNetworkError()
        let expectation = XCTestExpectation(description: "Calling stub session")
        let resultHandler: (Result<Items, Error>) -> Void = { resultType in
            switch resultType {
            case .failure(let error):
                let expectedError = NSError(domain: "some error", code: 1, userInfo: [:])
                XCTAssert(error as! NSError == expectedError)
                expectation.fulfill()
            default:
                XCTFail("expected success")
            }
        }
        subject.request(request: someRequest, translator: translator, completion: resultHandler)
        wait(for: [expectation], timeout: 5.0)
    }

    func testWhenURLRequestHasNoErrorAndNoData() {
        let expectation = XCTestExpectation(description: "Calling stub session")
        let resultHandler: (Result<Items, Error>) -> Void = { resultType in
            switch resultType {
            case .failure(let error):
                let expectedError = NSError.init(domain: "com.david.SPWeatherApp", code: -1, userInfo: ["info": "unknown network error"])
                XCTAssert(error as! NSError == expectedError)
                expectation.fulfill()
            default:
                XCTFail("expected success")
            }
        }

        subject.request(request: someRequest, translator: translator, completion: resultHandler)
        wait(for: [expectation], timeout: 5.0)
    }
}
