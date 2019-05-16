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
    let stubPayload = [
        Person(id: 1, name: "David", email: []),
        Person(id: 2, name: "Mirjam", email: [])
    ]

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
        
        // THEN
        let firstState = MainViewState.loading
        let finalState = MainViewState.loaded(persons: stubPayload)
        assert(mainViewControllerMock!.setupViewCalledWithStates == [firstState, finalState])
    }
    
    func testWhenViewDidLoadIsCalledInGoodNetworkButThereIsNoData() {
        // GIVEN
        dataProvider.setupForGoodNetworkWithNoData()
        
        //WHEN
        subject.viewDidLoad()
        
        // THEN
        let firstState = MainViewState.loading
        let finalState = MainViewState.emptyState
        assert(mainViewControllerMock!.setupViewCalledWithStates == [firstState, finalState])
    }

}
