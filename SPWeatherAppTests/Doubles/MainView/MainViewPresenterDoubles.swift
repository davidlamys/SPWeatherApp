//
//  MainViewPresenterDoubles.swift
//  SPWeatherAppTests
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation
@testable import SPWeatherApp

class MainViewPresenterFake: MainViewPresenter {
    var fetchItemsCalledWithQuery: String?
    var userWillViewItemCalledWith: Item?
    init() {
        // this is a questionable decision. need more future research
        super.init(view: MainViewControllerMock(),
                   dataProvider: DataProviderStub())
    }
    
    override func fetchItems(query: String) {
        fetchItemsCalledWithQuery = query
    }
    
    override func userWillViewItem(_ item: Item) {
        userWillViewItemCalledWith = item
    }
}
