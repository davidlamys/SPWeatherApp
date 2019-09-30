//
//  LocationTranslatorTests.swift
//  SPWeatherAppTests
//
//  Created by David_Lam on 26/9/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import XCTest
@testable import SPWeatherApp

class LocationTranslatorTests: XCTestCase {
    var response: Any!
    override func setUp() {
        response = ResponseLoader.loadLocalResponse(file: "StubSearchResponse")
    }

    func testLocationTranslatorReturnsArrayOfLocations() {
        let translationResult = LocationTranslator.translateFromNetworkResponse(data: response as! Data)
        guard case .success(let locations) = translationResult else {
            XCTFail("failed to parse from stub response")
            return
        }

        assert(locations.count == 10)
        
        let firstLocation = locations.first!
        assert(firstLocation.areaName.firstValue == "New Bishini")
        assert(firstLocation.country.firstValue == "Nigeria")
        assert(firstLocation.lat == 9.633)
        assert(firstLocation.lon == 7.400)
        
    }
}
