//
//  DetailViewModel.swift
//  TWNewsReader
//
//  Created by David_Lam on 17/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

protocol DetailViewModelType {
    func viewDidLoad()
    var view: DetailViewControllerType! { get }
}

class DetailViewModel: DetailViewModelType {
    weak var view: DetailViewControllerType!
    let dataProvider: DataProviderType!
    let person: Person

    init(view: DetailViewControllerType,
         dataProvider: DataProviderType = DataProvider(),
         person: Person) {
        self.view = view
        self.dataProvider = dataProvider
        self.person = person
    }

    func viewDidLoad() {
        view.setupView(person: person)
    }

}
