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
    
    func testUponViewDidLoad_shouldFetchRecentlyViewedCities() {
        XCTAssertEqual(viewPresenterFake.loadRecentlyViewedCityCalledCount, 1)
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
    
    func testInvokePresenterFunctionWhenSearchBarIsUpdatedWithEmptyString() {
        // GIVEN
        let searchController = UISearchController()
        searchController.searchBar.text = ""
        
        // WHEN
        subject.updateSearchResults(for: searchController)
        
        // THEN
        XCTAssertNil(viewPresenterFake.fetchItemsCalledWithQuery)
    }
    
    func testInvokePresenterFunctionWhenSearchBarIsUpdatedWithLessThanThreeChars() {
        // GIVEN
        let searchController = UISearchController()
        searchController.searchBar.text = "SI"
        
        // WHEN
        subject.updateSearchResults(for: searchController)
        
        // THEN
        XCTAssertNil(viewPresenterFake.fetchItemsCalledWithQuery)
        XCTAssertEqual(viewPresenterFake.searchWillBeginCalledCount, 1)
    }

    func testSetupForEmptyState() {
        // WHEN
        subject.setupView(state: .noResultFound(query: "Singapura"))

        //THEN
        XCTAssert(subject.tableView.isHidden == true)
        XCTAssert(subject.loadingStatusUpdateBanner.isHidden == true)
        let expectedText = String(format: Text.noResult.rawValue, "Singapura")
        XCTAssert(subject.stateFeedbackLabel.text == expectedText)
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

        let expectedTitle = String(format: Text.navigationTitle_recentlyViewed.rawValue, 2)
        XCTAssert(subject.title == expectedTitle)

        XCTAssertTrue(subject.loadingStatusUpdateBanner.isHidden)
        XCTAssertFalse(subject.activityIndicatorView.isAnimating)
        XCTAssert(subject.loadingStatusLabel.text == Text.welcomeBanner.rawValue)
    }

    func testLoadScreenWithLocationsFromNetwork() {
        // WHEN
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

    func testLoadScreenWithNoRecentlyViewedCities() {
        // WHEN
        subject.setupView(state: .loadRecentlyViewedCity(items: []))

        //THEN
        XCTAssertFalse(subject.loadingStatusUpdateBanner.isHidden)
        XCTAssertEqual(subject.loadingStatusLabel.text, Text.welcomeBanner.rawValue)
        XCTAssertFalse(subject.activityIndicatorView.isAnimating)
        XCTAssertNil(subject.title)
    }
    
    func testSetupForWillBeginSearch() {
        subject.setupView(state: .willBeginSearch)
        
        XCTAssert(subject.tableView.isHidden)
        XCTAssertEqual(subject.stateFeedbackLabel.text, Text.searchHelperPrompt.rawValue)
    }
    
    func testWhenUserSelectItem_shouldNotifyPresenter() {
        subject.setupView(state: .loadedFromNetwork(items: stubPayload))
        subject.tableView(subject.tableView, didSelectRowAt: IndexPath(item: 0, section: 0))
        
        XCTAssert(viewPresenterFake.userWillViewItemCalledWith == stubPayload.first)
    }
    
    func testWhenSearchWillBegin_shouldNotifySelf() {
        //questionable test
        subject.willPresentSearchController(UISearchController())
        XCTAssertEqual(viewPresenterFake.searchWillBeginCalledCount, 1)
    }
    
    func testWhenSearchWillEnd_shouldLoadRecentlyViewedCities() {
        subject.willDismissSearchController(UISearchController())
        XCTAssertEqual(viewPresenterFake.loadRecentlyViewedCityCalledCount, 2)
    }

}
