//
//  MainViewPresenter.swift
//  SPWeatherApp
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

protocol MainViewPresenterType {
    var view: MainViewControllerType! { get }
    func fetchItems(query: String)
    func userWillViewItem(_ item: Item)
    func loadRecentlyViewedCity()
}

class MainViewPresenter: MainViewPresenterType {
    weak var view: MainViewControllerType!
    var dataProvider: DataProviderType!

    init(view: MainViewControllerType,
         dataProvider: DataProviderType = DataProvider()) {
        self.view = view
        self.dataProvider = dataProvider
    }

    func fetchItems(query: String) {
        view.setupView(state: .loading)
        dataProvider.fetchListItems(query: query) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .failed:
                //TODO: process failure cases
                break
            case .successFromNetwork(let payload):
                if payload.isEmpty {
                    self.view.setupView(state: .displayWelcomeMessage)
                } else {
                    self.view.setupView(state: .loadedFromNetwork(items: payload))
                }
            }
        }
    }
    
    func userWillViewItem(_ item: Item) {
        dataProvider.store(item: item)
    }
    
    func loadRecentlyViewedCity() {
        dataProvider.getRecentlyViewedItems { [weak self] items in
            self?.view.setupView(state: .loadRecentlyViewedCity(items: items))
        }
    }

}
