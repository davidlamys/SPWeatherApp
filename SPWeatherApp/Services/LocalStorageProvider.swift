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
    func insertItem(item: Item)
}

class LocalStorageProvider {
    private let defaults: UserDefaults
    private let limit: Int
    private let userDefaultsKey = "ItemList"
    var cachedList = Items()
    
    init(userDefaults: UserDefaults = UserDefaults.standard,
         limit: Int = 10) {
        self.defaults = userDefaults
        self.limit = limit
        
        getListItemsFromLocal(completion: { [weak self] in
            self?.cachedList = $0
        })
    }
}

extension LocalStorageProvider: LocalStorageProviderType {

    func getListItemsFromLocal(completion: @escaping ((Items) -> Void)) {
        guard let data = defaults.data(forKey: userDefaultsKey) else {
            completion([])
            return
        }
        let result = LocationTranslator.translateFromUserDefaults(data: data)
        switch result {
        case .success(let items):
            completion(items)
        case .failure(let error):
            logError(error)
            completion([])
        }
    }

    func insertItem(item: Item) {
        if let index = cachedList.firstIndex(of: item) {
            cachedList.remove(at: index)
        }
        
        cachedList.insert(item, at: 0)
        
        if cachedList.count > limit {
            cachedList.removeLast()
        }
        save()
    }
    
    private func save() {
        let result = LocationTranslator.translateToData(from: cachedList)
        switch result {
        case .success(let data):
            defaults.setValue(data, forKey: userDefaultsKey)
        case .failure(let error):
            logError(error)
            assertionFailure("fail to save")
        }
    }
}
