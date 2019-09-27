//
//  LocalStorageProvider.swift
//  TWNewsReader
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import CoreData
import UIKit

protocol LocalStorageProviderType {
    func getListItemsFromLocal(completion: @escaping ((Items) -> Void))
    func insertListItems(data: Items)
    func deleteListItems()
}

class LocalStorageProvider {

    let persistentContainer: NSPersistentContainer!
       
    //MARK: Init with dependency
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    convenience init() {
        //Use the default container for production environment
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get shared app delegate")
        }
        self.init(container: appDelegate.persistentContainer)
    }
}

extension LocalStorageProvider: LocalStorageProviderType {

    // MARK: Person
    func getListItemsFromLocal(completion: @escaping ((Items) -> Void)) {
        
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
    }

    private func saveListItems(data list: Items) {
        let result = Result<Items, NSError>.failure(NSError())
        switch result {
        case .success(let data): break

        case .failure(let error):
            logError(error)
        }
    }

    func deleteListItems() {
        
    }
}
