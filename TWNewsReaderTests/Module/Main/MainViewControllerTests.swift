//
//  MainViewControllerTests.swift
//  TWNewsReaderTests
//
//  Created by David_Lam on 14/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import XCTest
@testable import TWNewsReader

class MainViewControllerTests: XCTestCase {

    var subject: MainViewController!
    var viewModelFake: MainViewModelFake!

    override func setUp() {
        subject = UIViewController.make(viewController: MainViewController.self)
        viewModelFake = MainViewModelFake()
        subject.viewModel = viewModelFake
        _  = subject.view
    }

    func testViewModelAwareThatViewHasLoaded() {
        subject.viewDidLoad()
        assert(viewModelFake.viewDidLoadCalled)
    }

    func testSetupForEmptyState() {
        // WHEN
        subject.setupView(state: .emptyState)

        //THEN
        assert(subject.tableView.isHidden == true)
        assert(subject.loadingStatusUpdateBanner.isHidden == true)
        assert(subject.stateFeedbackLabel.text == Text.noInternetTextForNewUser.rawValue)
    }

    func testSetupForLoadingScreen() {
        // WHEN
        subject.setupView(state: .loading)

        //THEN
        assert(subject.tableView.isHidden == true)
        assert(subject.loadingStatusUpdateBanner.isHidden == true)
        assert(subject.stateFeedbackLabel.text == Text.loadingText.rawValue)
    }

    func testSetupForLoadingAfterInitialLoadScreen() {
        // WHEN
        subject.setupView(state: .loading)
        subject.setupView(state: .loadedFromNetwork(items: stubPayload, hasMoreItems: true))
        subject.setupView(state: .loading)

        //THEN
        assert(subject.tableView.isHidden == false)
        assert(subject.loadingStatusUpdateBanner.isHidden == false)
        assert(subject.loadingStatusLabel.text == Text.stillLoadingText.rawValue)
    }

    func testLoadScreenWithPersonsFromLocalStorage() {
        // WHEN
        subject.setupView(state: .emptyState)
        subject.setupView(state: .loading)
        subject.setupView(state: .loadedFromLocalStorage(items: stubPayload))

        // THEN
        assert(subject.tableView.isHidden == false)
        let numberOfCells = subject.tableView.numberOfRows(inSection: 0)
        assert(numberOfCells == 2)
        let firstCell = subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        assert(firstCell.textLabel?.text == "Title 1")
        let secondCell = subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 1, section: 0))
        assert(secondCell.textLabel?.text == "Title 2")

        assert(subject.paginationButtonContainer.isHidden == true)
        assert(subject.navigationItem.leftBarButtonItem?.isEnabled == true)
        let expectedTitle = String(format: Text.navigationTitle_DataFromLocal.rawValue, 2)
        assert(subject.title == expectedTitle)

        assert(subject.loadingStatusUpdateBanner.isHidden == false)
        assert(subject.loadingStatusLabel.text == Text.apiFailedAndFetchedFromLocal.rawValue)
    }

    func testLoadScreenWithEmptyListItems() {
        // WHEN
        subject.setupView(state: .emptyState)
        subject.setupView(state: .loading)
        subject.setupView(state: .displayWelcomeMessage)

        //THEN
        assert(subject.tableView.isHidden == true)
        assert(subject.stateFeedbackLabel.text == Text.welcomMessage.rawValue)

        assert(subject.loadingStatusUpdateBanner.isHidden == true)
    }

    func testWhenFetchMoreButtonTapped() {
        subject.fetchMoreTapped(sender: self)
        assert(viewModelFake.fetchMoreCalled == true)
    }

    func testWhenRetyButtonTapped() {
        subject.retryButtonTapped(sender: self)
        assert(viewModelFake.retryFetchCalled == true)
    }
}
