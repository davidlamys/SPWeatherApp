//
//  MainViewPresenter.swift
//  SPWeatherApp
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

protocol MainViewPresenterType {
    func viewDidLoad()
    func retryFetch()
    var view: MainViewControllerType! { get }
}

class MainViewPresenter: MainViewPresenterType {
    weak var view: MainViewControllerType!
    var dataProvider: DataProviderType!

    init(view: MainViewControllerType,
         dataProvider: DataProviderType = DataProvider()) {
        self.view = view
        self.dataProvider = dataProvider
    }

    func viewDidLoad() {
        fetchListItems()
    }

    func retryFetch() {
        fetchListItems()
    }

    private func fetchListItems() {
        view.setupView(state: .loading)
        dataProvider.fetchListItems { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .fallbackFromLocalStorage(let payload):
                if payload.isEmpty {
                    self.view.setupView(state: .emptyState)
                } else {
                    self.view.setupView(state: .loadedFromLocalStorage(items: payload))
                }
            case .successFromNetwork(let payload):
                if payload.isEmpty {
                    self.view.setupView(state: .displayWelcomeMessage)
                } else {
                    self.view.setupView(state: .loadedFromNetwork(items: payload))
                }
            }
        }
    }

}
