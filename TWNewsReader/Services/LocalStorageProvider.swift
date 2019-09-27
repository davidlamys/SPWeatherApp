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

    func getListItemsFromLocal(completion: @escaping ((Items) -> Void)) {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PostObject")
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let backgroundContext = persistentContainer.newBackgroundContext()
        do {
            guard let result = try backgroundContext.fetch(request) as? [PostObject] else {
                fatalError("core data is not configured properly")
            }
            
            completion(PostTranslator.translateFromCoreDataObject(objects: result))
        } catch let error {
            logError(error)
            completion([])
        }
    }

    func insertListItems(data newList: Items) {
        let backgroundContext = persistentContainer.viewContext
        newList.forEach({ PostObject.insert(into: backgroundContext, post: $0) })
        do {
            try backgroundContext.save()
        } catch let error {
            logError(error)
        }
    }

    func deleteListItems() {
        
    }
}
