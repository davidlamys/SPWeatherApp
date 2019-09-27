//
//  TWNewsReaderUITests.swift
//  TWNewsReaderUITests
//
//  Created by David_Lam on 27/9/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import XCTest

class TWNewsReaderUITests: XCTestCase {
    var app: XCUIApplication!
    let existPredicate = NSPredicate(format: "exists == true")
    let kPostTitleString = "sunt aut facere repellat provident occaecati excepturi optio reprehenderit"

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
        
        let firstPostTitle = app.tables["MainTable"].cells.staticTexts[kPostTitleString]
        
        expectation(for: existPredicate, evaluatedWith: firstPostTitle, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(firstPostTitle.exists)
        firstPostTitle.tap()
        
        XCTAssert(app.staticTexts["Item Title"].exists)
        XCTAssert(app.textViews["Item Body"].exists)
    }

}

