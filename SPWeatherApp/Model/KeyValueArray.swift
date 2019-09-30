//
//  KeyValueArray.swift
//  SPWeatherApp
//
//  Created by David_Lam on 30/9/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

typealias KeyValueArray = [[String: String]]

extension KeyValueArray {
    var firstValue: String? {
        return self.first?.values.first
    }
}
