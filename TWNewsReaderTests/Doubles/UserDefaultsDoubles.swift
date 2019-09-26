//
//  UserDefaultsDoubles.swift
//  TWNewsReaderTests
//
//  Created by David_Lam on 20/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

// source: https://medium.com/@davidlin_98861/testing-userdefaults-cd86849fd896
class UserDefaultsMock : UserDefaults {

    convenience init() {
        UserDefaults().removePersistentDomain(forName: "Mock User Defaults")
        self.init(suiteName: "Mock User Defaults")!
    }

    override init?(suiteName suitename: String?) {
        UserDefaults().removePersistentDomain(forName: suitename!)
        super.init(suiteName: suitename)
    }

}
