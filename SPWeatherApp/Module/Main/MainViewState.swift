//
//  MainViewState.swift
//  SPWeatherApp
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

enum MainViewState {
    case loading
    case loadedFromNetwork(items: Items)
    case loadRecentlyViewedCity(items: Items)
    case noResultFound(query: String)
    case willBeginSearch
    case searchFailed
}

extension MainViewState: Equatable {}
