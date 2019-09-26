//
//  MainViewModel.swift
//  TWNewsReader
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

protocol MainViewModelType {
    func viewDidLoad()
    func fetchMore()
    func retryFetch()
    var view: MainViewControllerType! { get }
}

class MainViewModel: MainViewModelType {
    weak var view: MainViewControllerType!
    var dataProvider: DataProviderType!
    var nextIndex: Int = 0

    init(view: MainViewControllerType,
         dataProvider: DataProviderType = DataProvider()) {
        self.view = view
        self.dataProvider = dataProvider
    }

    func viewDidLoad() {
        fetchContactList()
    }

    func fetchMore() {
        fetchContactList()
    }

    func retryFetch() {
        nextIndex = 0
        fetchContactList()
    }

    private func fetchContactList() {
        view.setupView(state: .loading)
        dataProvider.fetchContactLists(startIndex: nextIndex) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .fallbackFromLocalStorage(let payload):
                if payload.isEmpty {
                    self.view.setupView(state: .emptyState)
                } else {
                    self.view.setupView(state: .loadedFromLocalStorage(persons: payload))
                }
            case .successFromNetwork(let payload, let hasMoreItems):
                self.nextIndex += limit
                if payload.isEmpty {
                    self.view.setupView(state: .displayWelcomeMessage)
                } else {
                    self.view.setupView(state: .loadedFromNetwork(persons: payload, hasMoreItems: hasMoreItems))
                    if hasMoreItems {
                        self.fetchContactList()
                    }
                }
            }
        }
    }

}
