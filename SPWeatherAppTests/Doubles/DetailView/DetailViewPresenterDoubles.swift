//
//  DetailViewPresenterDoubles.swift
//  SPWeatherAppTests
//
//  Created by David_Lam on 18/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation
@testable import SPWeatherApp

class DetailViewPresenterMock: DetailViewPresenterType {
    weak var view: DetailViewControllerType!
    var viewDidLoadCalled = false

    func viewDidLoad() {
        viewDidLoadCalled = true
    }
}
