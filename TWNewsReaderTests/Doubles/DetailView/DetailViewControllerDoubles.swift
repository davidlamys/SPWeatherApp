//
//  DetailViewControllerDoubles.swift
//  TWNewsReaderTests
//
//  Created by David_Lam on 18/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation
@testable import TWNewsReader

class DetailViewControllerMock: DetailViewControllerType {
    var setupViewCalledWithStates: [ImageViewState] = []
    var setupViewCalledWithPerson: Person!

    func setupView(state: ImageViewState) {
        setupViewCalledWithStates.append(state)
    }

    func setupView(person: Person) {
        setupViewCalledWithPerson = person
    }

}
