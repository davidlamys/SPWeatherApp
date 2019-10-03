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
            XCTAssert(self.networkClientStub.calledWith == RequestType.fetchListItems(query: "Singapore"))
            XCTAssert(result == FetchListItemsResultType.successFromNetwork(items: stubPayload))
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)

    }

    func testWhenFetchingListItemsWithNetworkError() {
        networkClientStub.setupForNetworkError()
        let expectation = XCTestExpectation(description: "Calling stub network client")

        subject.fetchListItems(query: "Singapore") { result in
            XCTAssert(result == FetchListItemsResultType.failed)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)

    }
    
    func testWhenFetchingWeatherUnderGoodNetwork() {
        // GIVEN
        let location = stubPayload[1]
        networkClientStub.setupForGetWeatherUnderGoodNetwork()
        
        let expectation = XCTestExpectation(description: "Calling stub network client")
        
        subject.fetchWeather(for: location) { result in
            XCTAssert(self.networkClientStub.calledWith == RequestType.fetchCityWeather(lat: location.lat!, lon: location.lon!))
            XCTAssert(result == FetchWeatherResultType.successFromNetwork(weatherCondition: stubWeatherPayload))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        
    }

    func testWhenFetchingWeatherWithNetworkError() {
        // GIVEN
        let location = stubPayload[1]
        networkClientStub.setupForNetworkError()
        let expectation = XCTestExpectation(description: "Calling stub network client")
        
        //WHEN
        subject.fetchWeather(for: location) { result in
            XCTAssert(result == FetchWeatherResultType.failed)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        
    }
    
    func testWhenFetchingWeatherIconUnderGoodNetwork() {
        // GIVEN
        networkClientStub.setupForGetWeatherIconUnderGoodNetwork()
        
        let expectation = XCTestExpectation(description: "Calling stub network client")
        
        subject.fetchIcon(urlString: "urlString") { result in
            XCTAssert(self.networkClientStub.calledWith == RequestType.fetch(urlString: "urlString"))
            XCTAssert(result == FetchWeatherIconResultType.successFromNetwork(data: Data()))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        
    }

    func testWhenFetchingWeatherIconWithNetworkError() {
        // GIVEN
        networkClientStub.setupForNetworkError()
        let expectation = XCTestExpectation(description: "Calling stub network client")
        
        //WHEN
        subject.fetchIcon(urlString: "urlString") { result in
            XCTAssert(self.networkClientStub.calledWith == RequestType.fetch(urlString: "urlString"))
            XCTAssert(result == FetchWeatherIconResultType.failed)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        
    }

}
