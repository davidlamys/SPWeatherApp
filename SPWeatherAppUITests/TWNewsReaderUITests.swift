//
//  SPWeatherAppUITests.swift
//  SPWeatherAppUITests
//
//  Created by David_Lam on 27/9/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import XCTest

class SPWeatherAppUITests: XCTestCase {
    var app: XCUIApplication!
    let existPredicate = NSPredicate(format: "exists == true")
    let kResultTextString = "Kampong Ayer Gemuruh"

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTappingOnCellShowsDetailScreen() {
        app.launch()
        
        let searchfield = app.searchFields.element(boundBy: 0)
        searchfield.tap()
        searchfield.typeText("Sin")

        let firstSearchResult = app.tables["MainTable"].cells.staticTexts[kResultTextString]
        
        expectation(for: existPredicate, evaluatedWith: firstSearchResult, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(firstSearchResult.exists)
        firstSearchResult.tap()
        
        let weatherDecriptionLabel = app.staticTexts["weatherDescriptionLabel"]
        expectation(for: existPredicate, evaluatedWith: weatherDecriptionLabel, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(app.staticTexts["weatherDescriptionLabel"].exists)
        XCTAssert(app.staticTexts["temperatureLabel"].exists)
        XCTAssert(app.staticTexts["humidityLabel"].exists)
    }

}

