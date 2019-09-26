//
//  MainViewState.swift
//  TWNewsReader
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

enum MainViewState {
    case loading
    case loadedFromNetwork(items: Items, hasMoreItems: Bool)
    case loadedFromLocalStorage(items: Items)
    case emptyState
    case displayWelcomeMessage
}

extension MainViewState: Equatable {}
