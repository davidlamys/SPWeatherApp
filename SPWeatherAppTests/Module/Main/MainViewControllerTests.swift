//
//  MainViewControllerTests.swift
//  SPWeatherAppTests
//
//  Created by David_Lam on 14/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import XCTest
@testable import SPWeatherApp

class MainViewControllerTests: XCTestCase {

    var subject: MainViewController!
    var viewPresenterFake: MainViewPresenterFake!

    override func setUp() {
        subject = UIViewController.make(viewController: MainViewController.self)
        viewPresenterFake = MainViewPresenterFake()
        subject.viewPresenter = viewPresenterFake
        _  = subject.view
    }
    
    func testInvokePresenterFunctionWhenSearchBarIsUpdated() {
        // GIVEN
        let searchController = UISearchController()
        searchController.searchBar.text = "MySearch"
        
        // WHEN
        subject.updateSearchResults(for: searchController)
        
        // THEN
        XCTAssert(viewPresenterFake.fetchItemsCalledWithQuery == "MySearch")
    }

    func testSetupForEmptyState() {
        // WHEN
        subject.setupView(state: .emptyState)

        //THEN
        XCTAssert(subject.tableView.isHidden == true)
        XCTAssert(subject.loadingStatusUpdateBanner.isHidden == true)
        XCTAssert(subject.stateFeedbackLabel.text == Text.noInternetTextForNewUser.rawValue)
    }

    func testSetupForLoadingScreen() {
        // WHEN
        subject.setupView(state: .loading)

        //THEN
        XCTAssert(subject.tableView.isHidden == true)
        XCTAssert(subject.loadingStatusUpdateBanner.isHidden == true)
        XCTAssert(subject.stateFeedbackLabel.text == Text.loadingText.rawValue)
        XCTAssert(subject.activityIndicatorView.isAnimating == true)
    }

    func testLoadScreenWithSearchHistory() {
        // WHEN
        subject.setupView(state: .loadRecentlyViewedCity(items: stubPayload))

        // THEN
        XCTAssert(subject.tableView.isHidden == false)
        let numberOfCells = subject.tableView.numberOfRows(inSection: 0)
        XCTAssert(numberOfCells == 2)
        let firstCell = subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssert(firstCell.textLabel?.text == "Area 51")
        XCTAssert(firstCell.detailTextLabel?.text == "USA")
        let secondCell = subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 1, section: 0))
        XCTAssert(secondCell.textLabel?.text == "Singapore")
        XCTAssert(secondCell.detailTextLabel?.text == "Singapore")

        let expectedTitle = String(format: Text.navigationTitle_DataFromLocal.rawValue, 2)
        XCTAssert(subject.title == expectedTitle)

        XCTAssert(subject.loadingStatusUpdateBanner.isHidden == false)
        XCTAssert(subject.activityIndicatorView.isAnimating == false)
        XCTAssert(subject.loadingStatusLabel.text == Text.apiFailedAndFetchedFromLocal.rawValue)
    }

    func testLoadScreenWithPostsFromNetwork() {
        // WHEN
        subject.setupView(state: .emptyState)
        subject.setupView(state: .loading)
        subject.setupView(state: .loadedFromNetwork(items: stubPayload))

        // THEN
        XCTAssert(subject.tableView.isHidden == false)
        let numberOfCells = subject.tableView.numberOfRows(inSection: 0)
        XCTAssert(numberOfCells == 2)
        let firstCell = subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssert(firstCell.textLabel?.text == "Area 51")
        XCTAssert(firstCell.detailTextLabel?.text == "USA")
        let secondCell = subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 1, section: 0))
        XCTAssert(secondCell.textLabel?.text == "Singapore")
        XCTAssert(secondCell.detailTextLabel?.text == "Singapore")

        let expectedTitle = String(format: Text.navigationTitle_DataFromNetwork.rawValue, 2)
        XCTAssert(subject.title == expectedTitle)

        XCTAssert(subject.loadingStatusUpdateBanner.isHidden == false)
        XCTAssert(subject.activityIndicatorView.isAnimating == false)
        XCTAssert(subject.loadingStatusLabel.text == Text.completedMessage.rawValue)
    }

    func testLoadScreenWithEmptyListItems() {
        // WHEN
        subject.setupView(state: .emptyState)
        subject.setupView(state: .loading)
        subject.setupView(state: .displayWelcomeMessage)

        //THEN
        XCTAssert(subject.stateFeedbackLabel.text == Text.welcomMessage.rawValue)
        XCTAssert(subject.tableView.isHidden == true)
        XCTAssert(subject.loadingStatusUpdateBanner.isHidden == true)
        XCTAssert(subject.activityIndicatorView.isAnimating == false)
        XCTAssert(subject.title == nil)

    }

    func testLoadScreenWithEmptyListItemsAndNoInternet() {
        // WHEN
        subject.setupView(state: .emptyState)
        subject.setupView(state: .loading)
        subject.setupView(state: .emptyState)
        //THEN
        XCTAssert(subject.stateFeedbackLabel.text == Text.noInternetTextForNewUser.rawValue)
        XCTAssert(subject.tableView.isHidden == true)
        XCTAssert(subject.loadingStatusUpdateBanner.isHidden == true)
        XCTAssert(subject.activityIndicatorView.isAnimating == false)
        XCTAssert(subject.title == nil)
    }
    
    func testWhenUserSelectItem_shouldNotifyPresenter() {
        subject.setupView(state: .loadedFromNetwork(items: stubPayload))
        subject.tableView(subject.tableView, didSelectRowAt: IndexPath(item: 0, section: 0))
        
        XCTAssert(viewPresenterFake.userWillViewItemCalledWith == stubPayload.first)
    }

}
