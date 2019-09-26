//
//  UtilitiesTests.swift
//  TWNewsReaderTests
//
//  Created by David_Lam on 12/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import XCTest
@testable import TWNewsReader

class UtilitiesTests: XCTestCase {

    func testPerformanceExample() {
        self.measure {
            let _ = getMD5Hex(string: "davidlys@gmail.com")
        }
    }

    func testMD5FunctionShouldReturnCorrectValue() {
        let subject = getMD5Hex
        assert(subject("davidlys@gmail.com") == "b5f6c2a999a22d0204532a6ede7ba92d")
    }
}
