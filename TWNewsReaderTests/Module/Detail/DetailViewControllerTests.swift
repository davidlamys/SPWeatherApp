//
//  DetailViewControllerTests.swift
//  TWNewsReaderTests
//
//  Created by David_Lam on 17/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import XCTest
@testable import TWNewsReader

class DetailViewControllerTests: XCTestCase {

    var subject: DetailViewController!
    var viewPresenterMock = DetailViewPresenterMock()

    override func setUp() {
        subject = UIViewController.make(viewController: DetailViewController.self)
        subject.viewPresenter = viewPresenterMock
        viewPresenterMock.view = subject
        _  = subject.view
    }

    func testViewPresenterAwareThatViewHasLoaded() {
        subject.viewDidLoad()
        assert(viewPresenterMock.viewDidLoadCalled)
    }

    func testWhenSetupViewIsCalled() {
        let firstPost = stubPayload.first!
        subject.setupView(item: firstPost)

        assert(subject.titleLabel.text == firstPost.title)
        assert(subject.bodyTextView.text == firstPost.body)
    }

}
