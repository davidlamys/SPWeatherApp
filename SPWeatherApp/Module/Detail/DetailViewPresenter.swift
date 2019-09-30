//
//  DetailViewPresenter.swift
//  SPWeatherApp
//
//  Created by David_Lam on 17/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

protocol DetailViewPresenterType {
    func viewDidLoad()
    var view: DetailViewControllerType! { get }
}

class DetailViewPresenter: DetailViewPresenterType {
    weak var view: DetailViewControllerType!
    let item: Item

    init(view: DetailViewControllerType,
         item: Item) {
        self.view = view
        self.item = item
    }

    func viewDidLoad() {
        view.setupView(item: item)
    }

}
