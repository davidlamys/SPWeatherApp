//
//  DetailViewModel.swift
//  PDContactList
//
//  Created by David_Lam on 17/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

protocol DetailViewModelType {
    func viewDidLoad()
    var view: DetailViewControllerType! { get }
}
