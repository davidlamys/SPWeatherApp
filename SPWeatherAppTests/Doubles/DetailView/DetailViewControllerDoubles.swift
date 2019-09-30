//
//  DetailViewControllerDoubles.swift
//  SPWeatherAppTests
//
//  Created by David_Lam on 18/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation
@testable import SPWeatherApp

class DetailViewControllerMock: DetailViewControllerType {
    var setupViewCalledWithItem: Item!

    func setupView(item: Item) {
        setupViewCalledWithItem = item
    }

}
