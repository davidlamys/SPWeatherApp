//
//  LocalStorageProvider.swift
//  TWNewsReader
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

protocol LocalStorageProviderType {
    func getListItemsFromLocal(completion: @escaping ((Items) -> Void))
    func insertListItems(data: Items)
    func deleteListItems()
}

class LocalStorageProvider {

    private let defaults: UserDefaults

    fileprivate struct Keys {
        static func getKeyForListItems() -> String {
            return "SavedList"
        }

        static func getKeyFor(imageHash: String) -> String {
            return String(format: "Image-%@",
                          imageHash)
        }
    }

    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.defaults = userDefaults
    }
}

extension LocalStorageProvider: LocalStorageProviderType {

    // MARK: Person
    func getListItemsFromLocal(completion: @escaping ((Items) -> Void)) {
        guard let savedData = defaults.object(forKey: Keys.getKeyForListItems()) as? Data else {
            completion([])
            return
        }

        let result = Result<Items, NSError>.failure(NSError())

        switch result {
        case .success(let list):
            completion(list)
        case .failure(let error):
            logError(error)
            completion([])
        }
    }

    func insertListItems(data newList: Items) {
        getListItemsFromLocal { localList in
            self.saveListItems(data: localList + newList)
        }
    }

    private func saveListItems(data list: Items) {
        let result = Result<Items, NSError>.failure(NSError())
        switch result {
        case .success(let data):
            defaults.set(data, forKey: Keys.getKeyForListItems())
        case .failure(let error):
            logError(error)
        }
    }

    func deleteListItems() {
        defaults.set(nil, forKey: Keys.getKeyForListItems())
    }
}
