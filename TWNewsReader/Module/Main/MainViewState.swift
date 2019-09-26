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
    case loadedFromNetwork(persons: [Person], hasMoreItems: Bool)
    case loadedFromLocalStorage(persons: [Person])
    case emptyState
    case displayWelcomeMessage
}

extension MainViewState: Equatable {}
