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
    var viewModelMock = DetailViewModelMock()

    override func setUp() {
        subject = UIViewController.make(viewController: DetailViewController.self)
        subject.viewModel = viewModelMock
        viewModelMock.view = subject
        _  = subject.view
    }

    func testViewModelAwareThatViewHasLoaded() {
        subject.viewDidLoad()
        assert(viewModelMock.viewDidLoadCalled)
    }

}
