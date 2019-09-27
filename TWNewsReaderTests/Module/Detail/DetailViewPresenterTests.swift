//
//  DetailViewPresenterTests.swift
//  TWNewsReaderTests
//
//  Created by David_Lam on 18/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import XCTest
@testable import TWNewsReader

class DetailViewPresenterTests: XCTestCase {

    var subject: DetailViewPresenter!
    var detailViewControllerMock: DetailViewControllerMock!
    let firstPost = stubPayload.first!

    override func setUp() {
        super.setUp()
        detailViewControllerMock = DetailViewControllerMock()
        subject = DetailViewPresenter(view: detailViewControllerMock,
                                      item: firstPost)
    }

    func testWhenViewDidLoadIsCalled_ShouldCallInvokeSetupWithPersonInViewController() {
        subject.viewDidLoad()
        assert(detailViewControllerMock.setupViewCalledWithItem == firstPost)
    }

}
