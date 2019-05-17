//
//  DetailViewModelDoubles.swift
//  PDContactListTests
//
//  Created by David_Lam on 18/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation
@testable import PDContactList

class DetailViewModelMock: DetailViewModelType {
    weak var view: DetailViewControllerType!
    var viewDidLoadCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
}
