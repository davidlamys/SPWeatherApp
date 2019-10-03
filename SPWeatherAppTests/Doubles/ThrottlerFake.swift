//
//  ThrottlerFake.swift
//  SPWeatherAppTests
//
//  Created by David_Lam on 3/10/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation
@testable import SPWeatherApp

class FakeThrottler: ThrottlerType {
    func throttle(_ block: @escaping () -> Void) {
        block()
    }
}
