//
//  LocalStorageProvider.swift
//  SPWeatherApp
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import UIKit

protocol LocalStorageProviderType {
    func getListItemsFromLocal(completion: @escaping ((Items) -> Void))
    func insertListItems(data: Items)
    func deleteListItems()
}

class LocalStorageProvider {
    init() {
    }
}

extension LocalStorageProvider: LocalStorageProviderType {

    func getListItemsFromLocal(completion: @escaping ((Items) -> Void)) {
    }

    func insertListItems(data newList: Items) {
    }

    func deleteListItems() {
    }
}
