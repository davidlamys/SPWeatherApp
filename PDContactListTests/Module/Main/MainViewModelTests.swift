//
//  MainViewModelTests.swift
//  PDContactListTests
//
//  Created by David_Lam on 14/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import XCTest
@testable import PDContactList

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
       
        //WHEN
        subject.viewDidLoad()
        
        XCTFail("pending refactoring to accommodate more states")
        // THEN
        let firstState = MainViewState.loading
        let finalState = MainViewState.loadedFromNetwork(persons: stubPayload, hasMoreItems: true)
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

}
