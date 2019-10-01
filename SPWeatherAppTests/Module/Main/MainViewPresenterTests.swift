//
//  MainViewPresenterTests.swift
//  SPWeatherAppTests
//
//  Created by David_Lam on 14/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import XCTest
@testable import SPWeatherApp

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
        subject.fetchItems(query: "Singapore")
        // THEN
        assert(dataProvider.fetchListItemsCalledWithQuery == "Singapore")
        let firstState = MainViewState.loading
        let finalState = MainViewState.loadedFromNetwork(items: stubPayload)
        assert(mainViewControllerMock!.setupViewCalledWithStates == [firstState, finalState])
    }

    func testWhenViewDidLoadIsCalledInGoodNetworkButThereIsNoData() {
        // GIVEN
        dataProvider.setupForGoodNetworkWithNoData()

        //WHEN
        subject.fetchItems(query: "Singapore")

        // THEN
        assert(dataProvider.fetchListItemsCalledWithQuery == "Singapore")
        let firstState = MainViewState.loading
        let finalState = MainViewState.displayWelcomeMessage
        assert(mainViewControllerMock!.setupViewCalledWithStates == [firstState, finalState])
    }
    
    func testWhenViewDidLoadIsCalledInBadNetwork() {
        // GIVEN
        dataProvider.setupForBadNework()

        //WHEN
        subject.fetchItems(query: "Singapore")

        // THEN
        assert(dataProvider.fetchListItemsCalledWithQuery == "Singapore")
        let firstState = MainViewState.loading
        let finalState = MainViewState.loadedFromLocalStorage(items: stubPayload)
        XCTFail()
    }

}
