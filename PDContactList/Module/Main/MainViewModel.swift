//
//  MainViewModel.swift
//  PDContactList
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

protocol MainViewModelType {
    func viewDidLoad()
    var view: MainViewControllerType! { get }
}

class MainViewModel: MainViewModelType {
    weak var view: MainViewControllerType!
    var dataProvider: DataProviderType!
    
    init(view: MainViewControllerType,
         dataProvider: DataProviderType = DataProvider()) {
        self.view = view
        self.dataProvider = dataProvider
    }
    
    func viewDidLoad() {
        view.setupView(state: .loading)
        dataProvider.fetchContactLists { [weak self] (result, dataSource) in
            switch (result.isEmpty, dataSource) {
            case (true, .local):
                self?.view.setupView(state: .emptyState)
            case (true, .network):
                self?.view.setupView(state: .displayWelcomeMessage)
            case (false, _):
                self?.view.setupView(state: .loaded(persons: result))
            }
        }
    }
}
