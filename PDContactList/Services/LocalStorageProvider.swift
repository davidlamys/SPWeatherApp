//
//  LocalStorageProvider.swift
//  PDContactList
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

protocol LocalStorageProviderType {
    func getContactListFromLocal(completion: @escaping (([Person]) -> Void))
    func upsertContactList(data: [Person])
    func deleteContactList()
    func getImage(hash: String, completion: @escaping((Data?) -> Void))
    func saveImage(hash: String, data: Data)
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
    func getContactListFromLocal(completion: @escaping (([Person]) -> Void)) {
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
    
    func upsertContactList(data list: [Person]) {
        let result = PersonTranslator.translateToData(from: list)
        switch result {
        case .success(let data):
            let defaults = UserDefaults.standard
            defaults.set(data, forKey: Keys.getKeyForContactList())
        case .failure(let error):
            logError(error)
        }
    }
    
    func deleteContactList() {
        defaults.set(nil, forKey: "SavedList")
    }
    
    // MARK: Image
    func getImage(hash: String, completion: @escaping ((Data?) -> Void)) {
        let savedData = defaults.object(forKey: Keys.getKeyForContactList()) as? Data
        completion(savedData)
    }
    
    func saveImage(hash: String, data: Data) {
        defaults.set(data, forKey: Keys.getKeyFor(imageHash: hash))
    }
}
