//
//  MainViewModelTests.swift
//  TWNewsReaderTests
//
//  Created by David_Lam on 14/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import XCTest
@testable import TWNewsReader

class MainViewModelTests: XCTestCase {

    var subject: MainViewModel!
    var mainViewControllerMock: MainViewControllerMock!
    var dataProvider: DataProviderStub!

    override func setUp() {
        mainViewControllerMock = MainViewControllerMock()
        dataProvider = DataProviderStub()
        subject = MainViewModel(view: mainViewControllerMock,
                                dataProvider: dataProvider)
    }

    func testWhenViewDidLoadIsCalledInGoodNetwork() {
        // GIVEN
        dataProvider.setupForGoodNetwork()
        let initialIndex = subject.nextIndex

        //WHEN
        subject.viewDidLoad()
        // THEN
        let firstState = MainViewState.loading
        let finalState = MainViewState.loadedFromNetwork(items: stubPayload, hasMoreItems: false)
        assert(mainViewControllerMock!.setupViewCalledWithStates == [firstState, finalState])
        // a succesful fetch should increase the index
        assert(subject.nextIndex - initialIndex == limit)
    }

    func testWhenViewDidLoadIsCalledInGoodNetworkWithMultiplePages() {
        // GIVEN
        dataProvider.setupForGoodNetworkWithMultipageData()
        let initialIndex = subject.nextIndex

        //WHEN
        subject.viewDidLoad()
        // THEN
        let firstState = MainViewState.loading
        let intimediateState = MainViewState.loadedFromNetwork(items: stubPayload, hasMoreItems: true)
        let intimediateStateTwo = MainViewState.loading
        let finalState = MainViewState.loadedFromNetwork(items: stubPayload, hasMoreItems: false)

        assert(mainViewControllerMock!.setupViewCalledWithStates == [firstState,
                                                                 intimediateState,
                                                                 intimediateStateTwo,
                                                                     finalState])

        // a succesful fetch should increase the index
        assert(subject.nextIndex - initialIndex == (2*limit))
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

    func testWhenRetyFetchIsCalled() {
        // GIVEN
        subject.nextIndex = Int.max
        dataProvider.setupForGoodNetwork()

        // WHEN
        subject.retryFetch()

        // THEN
        assert(dataProvider.fetchListItemsCalledWithIndex == 0)
        // THEN
        let firstState = MainViewState.loading
        let finalState = MainViewState.loadedFromNetwork(items: stubPayload, hasMoreItems: false)
        assert(mainViewControllerMock!.setupViewCalledWithStates == [firstState, finalState])
        // a succesful fetch should increase the index
        assert(subject.nextIndex == limit)

    }

}
