//
//  LocalStorageProvider.swift
//  TWNewsReader
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

protocol LocalStorageProviderType {
    func getContactListFromLocal(completion: @escaping ((Items) -> Void))
    func insertContactList(data: Items)
    func deleteContactList()
}

class LocalStorageProvider {

    private let defaults: UserDefaults

    fileprivate struct Keys {
        static func getKeyForContactList() -> String {
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
    func getContactListFromLocal(completion: @escaping ((Items) -> Void)) {
        guard let savedData = defaults.object(forKey: Keys.getKeyForContactList()) as? Data else {
            completion([])
            return
        }

        let result = PersonTranslator.translateFromUserDefaults(data: savedData)

        switch result {
        case .success(let list):
            completion(list)
        case .failure(let error):
            logError(error)
            completion([])
        }
    }

    func insertContactList(data newList: Items) {
        getContactListFromLocal { localList in
            self.saveContactList(data: localList + newList)
        }
    }

    private func saveContactList(data list: Items) {
        let result = PersonTranslator.translateToData(from: list)
        switch result {
        case .success(let data):
            defaults.set(data, forKey: Keys.getKeyForContactList())
        case .failure(let error):
            logError(error)
        }
    }

    func deleteContactList() {
        defaults.set(nil, forKey: Keys.getKeyForContactList())
    }
}
