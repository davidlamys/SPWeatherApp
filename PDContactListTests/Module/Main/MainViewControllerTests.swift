//
//  MainViewControllerTests.swift
//  PDContactListTests
//
//  Created by David_Lam on 14/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import XCTest
@testable import PDContactList

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
        assert(subject.stateFeedbackLabel.text == Text.placeholderText.rawValue)
    }
    
    func testSetupForLoadingScreen() {
        // WHEN
        subject.setupView(state: .loading)
        
        //THEN
        assert(subject.tableView.isHidden == true)
        assert(subject.stateFeedbackLabel.text == Text.loadingText.rawValue)
    }

    func testLoadScreenWithPersons() {
        // WHEN
        subject.setupView(state: .emptyState)
        subject.setupView(state: .loading)
        subject.setupView(state: .loaded(persons: stubPayload))
        
        // THEN
        assert(subject.tableView.isHidden == false)
        let numberOfCells = subject.tableView.numberOfRows(inSection: 0)
        assert(numberOfCells == 2)
        let firstCell = subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        assert(firstCell.textLabel?.text == "David")
        let secondCell = subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 1, section: 0))
        assert(secondCell.textLabel?.text == "Mirjam")
    }

}
