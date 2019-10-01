//
//  WeatherTranslatorTests.swift
//  SPWeatherAppTests
//
//  Created by David_Lam on 26/9/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import XCTest
@testable import SPWeatherApp

class WeatherTranslatorTests: XCTestCase {
    var response: Any!
    override func setUp() {
        response = ResponseLoader.loadLocalResponse(file: "StubWeatherResponse")
    }

    func testWeatherTranslatorReturnsArrayOfWeatherConditions() {
        let translationResult = WeatherTranslator.translateFromNetworkResponse(data: response as! Data)
        guard case .success(let weatherCondition) = translationResult else {
            XCTFail("failed to parse from stub response")
            return
        }
        
        assert(weatherCondition.humidity == "83")
        assert(weatherCondition.tempC == "17")
        assert(weatherCondition.tempF == "63")
        assert(weatherCondition.weatherDescription == "Partly cloudy")
        let expectedURL = URL(string: "http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0002_sunny_intervals.png")
        assert(weatherCondition.iconURL == expectedURL)
        
    }
}
