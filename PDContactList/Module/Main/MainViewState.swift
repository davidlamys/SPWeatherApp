//
//  MainViewState.swift
//  PDContactList
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

enum MainViewState {
    case loading
    case loaded(persons: [Person])
    case emptyState
}

extension MainViewState: Equatable {}
