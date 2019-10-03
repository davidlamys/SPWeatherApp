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

        XCTAssert(locations.count == 10)
        
        let firstLocation = locations.first!
        XCTAssert(firstLocation.areaName.firstValue == "New Bishini")
        XCTAssert(firstLocation.country.firstValue == "Nigeria")
        XCTAssert(firstLocation.lat == 9.633)
        XCTAssert(firstLocation.lon == 7.400)
        
    }
    
    func testWhenNoMatchingWeatherFound() {
        response = ResponseLoader.loadLocalResponse(file: "StubNoSearchResultRespone")
        
        let translationResult = LocationTranslator.translateFromNetworkResponse(data: response as! Data)
        guard case .success(let locations) = translationResult else {
            XCTFail("failed to parse from stub response")
            return
        }
        XCTAssert(locations.isEmpty)
    }
    
    func testLocationTranslatorParseToDataAndBack() {
        let locationToDataResult = LocationTranslator.translateToData(from: stubPayload)
        let data = try! locationToDataResult.get()
        let dataToLocationResult = LocationTranslator.translateFromUserDefaults(data: data)
        let locations = try! dataToLocationResult.get()
        
        XCTAssertEqual(locations, stubPayload)
    }
}
