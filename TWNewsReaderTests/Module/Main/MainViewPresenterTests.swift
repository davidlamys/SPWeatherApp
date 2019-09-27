//
//  MainViewPresenterTests.swift
//  TWNewsReaderTests
//
//  Created by David_Lam on 14/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import XCTest
@testable import TWNewsReader

class MainViewPresenterTests: XCTestCase {

    var subject: MainViewPresenter!
    var mainViewControllerMock: MainViewControllerMock!
    var dataProvider: DataProviderStub!

    override func setUp() {
        mainViewControllerMock = MainViewControllerMock()
        dataProvider = DataProviderStub()
        subject = MainViewPresenter(view: mainViewControllerMock,
                                dataProvider: dataProvider)
    }

    func testWhenViewDidLoadIsCalledInGoodNetwork() {
        // GIVEN
        dataProvider.setupForGoodNetwork()

        //WHEN
        subject.viewDidLoad()
        // THEN
        let firstState = MainViewState.loading
        let finalState = MainViewState.loadedFromNetwork(items: stubPayload)
        assert(mainViewControllerMock!.setupViewCalledWithStates == [firstState, finalState])
    }

    func testWhenViewDidLoadIsCalledInGoodNetworkButThereIsNoData() {
        // GIVEN
        dataProvider.setupForGoodNetworkWithNoData()

        //WHEN
        subject.viewDidLoad()

        // THEN
        let firstState = MainViewState.loading
        let finalState = MainViewState.displayWelcomeMessage
        assert(mainViewControllerMock!.setupViewCalledWithStates == [firstState, finalState])
    }

    func testWhenViewDidLoadIsCalledInBadNetworkAndThereIsNoLocalData() {
        // GIVEN
        dataProvider.setupForBadNeworkWithNoLocalData()

        //WHEN
        subject.viewDidLoad()

        // THEN
        let firstState = MainViewState.loading
        let finalState = MainViewState.emptyState
        assert(mainViewControllerMock!.setupViewCalledWithStates == [firstState, finalState])
    }
    
    func testWhenViewDidLoadIsCalledInBadNetworkAndThereIsSomeLocalData() {
        // GIVEN
        dataProvider.setupForBadNeworkWithSomeLocalData()

        //WHEN
        subject.viewDidLoad()

        // THEN
        let firstState = MainViewState.loading
        let finalState = MainViewState.loadedFromLocalStorage(items: stubPayload)
        assert(mainViewControllerMock!.setupViewCalledWithStates == [firstState, finalState])
    }

    func testWhenRetyFetchIsCalled() {
        // GIVEN
        dataProvider.setupForGoodNetwork()

        // WHEN
        subject.retryFetch()

        // THEN
        assert(dataProvider.fetchListItemsCalledWithIndex == 0)
        // THEN
        let firstState = MainViewState.loading
        let finalState = MainViewState.loadedFromNetwork(items: stubPayload)
        assert(mainViewControllerMock!.setupViewCalledWithStates == [firstState, finalState])

    }

}
