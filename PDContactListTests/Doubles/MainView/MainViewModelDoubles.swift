//
//  MainViewModelDoubles.swift
//  PDContactListTests
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation
@testable import PDContactList

class MainViewModelFake: MainViewModel {
    var viewDidLoadCalled = false
    var fetchMoreCalled = false
    var retryFetchCalled = false
    init() {
        // this is a questionable decision. need more future research
        super.init(view: MainViewControllerMock(),
                   dataProvider: DataProviderStub())
    }
    override func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    override func fetchMore() {
        fetchMoreCalled = true
    }
    
    override func retryFetch() {
        retryFetchCalled = true
    }
}
