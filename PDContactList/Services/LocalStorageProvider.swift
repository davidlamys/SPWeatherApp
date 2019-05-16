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
}

class LocalStorageProvider: LocalStorageProviderType {
    static let sharedInstance = LocalStorageProvider()
    private init(){}
    
    func getContactListFromLocal(completion: @escaping (([Person]) -> Void)) {
        
    }
    
    func saveContactList(data: [Person]) {
        
    }
    
}
