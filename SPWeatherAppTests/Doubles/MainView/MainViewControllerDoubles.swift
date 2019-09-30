//
//  MainViewControllerMock.swift
//  SPWeatherAppTests
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation
@testable import SPWeatherApp

class MainViewControllerMock: MainViewControllerType {
    var setupViewCalledWithStates: [MainViewState] = []
    func setupView(state: MainViewState) {
        setupViewCalledWithStates.append(state)
    }
}
