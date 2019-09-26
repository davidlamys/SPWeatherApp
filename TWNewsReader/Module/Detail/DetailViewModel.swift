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

        guard let email = person.primaryEmail?.value else {
            return
        }
        let hash = email.calculateMD5Hex()
        view.setupView(state: .fetching)
        dataProvider.fetchImage(imageHash: hash,
                                localFetchCompletion: localImageFetchCompletion,
                                networkFetchCompletion: networkImageFetchCompletion)
    }

    func localImageFetchCompletion(data: Data?) {
        guard let data = data else {
            return
        }
        view.setupView(state: .localData(data: data))
    }

    func networkImageFetchCompletion(data: Data?) {
        if let data = data  {
            view.setupView(state: .succeeded(data: data))
        } else {
            view.setupView(state: .failed)
        }
    }
}
