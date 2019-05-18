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
    func saveContactList(data: [Person])
    func getImage(hash: String, completion: @escaping((Data?) -> Void))
    func saveImage(hash: String, data: Data)
}

class LocalStorageProvider: LocalStorageProviderType {
    
    static let sharedInstance = LocalStorageProvider()
    let defaults = UserDefaults.standard
    private init(){}
    
    // MARK: Person
    func getContactListFromLocal(completion: @escaping (([Person]) -> Void)) {
        guard let savedData = defaults.object(forKey: "SavedList") as? Data else {
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
    
    func saveContactList(data list: [Person]) {
        let result = PersonTranslator.translateToData(from: list)
        switch result {
        case .success(let data):
            let defaults = UserDefaults.standard
            defaults.set(data, forKey: "SavedList")
        case .failure(let error):
            logError(error)
        }
    }
    
    // MARK: Image
    func getImage(hash: String, completion: @escaping ((Data?) -> Void)) {
        let savedData = defaults.object(forKey: "Image-\(hash)") as? Data
        completion(savedData)
    }
    
    func saveImage(hash: String, data: Data) {
        defaults.set(data, forKey: "Image-\(hash)")
    }
}
