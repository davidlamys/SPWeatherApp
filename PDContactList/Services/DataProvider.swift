//
//  DataProvider.swift
//  PDContactList
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

enum DataSource {
    case local
    case network
}

protocol DataProviderType {
    func fetchContactLists(completion: @escaping(([Person], DataSource) -> Void))
}

struct DataProvider: DataProviderType {
    let clientType: NetworkClientType
    let localStorageProvider: LocalStorageProviderType
    
    init(clientType: NetworkClientType = NetworkClient.sharedInstance,
         localStorageProvider: LocalStorageProviderType = LocalStorageProvider.sharedInstance) {
        self.clientType = clientType
        self.localStorageProvider = localStorageProvider
    }
    
    func fetchContactLists(completion: @escaping (([Person], DataSource) -> Void)) {
        clientType.request(request: .fetchContactList,
                       translator: PersonTranslator.translateFrom) { result in
            precondition(Thread.isMainThread == false)
            switch result {
            case .failure(let error):
                logError(error)
                self.getContactListFromLocal(completion: completion)
            case .success(let persons):
                self.localStorageProvider.saveContactList(data: persons)
                completion(persons, .network)
            }
        }
    }
    
    private func getContactListFromLocal(completion: @escaping (([Person], DataSource) -> Void)) {
        localStorageProvider.getContactListFromLocal { (personsFromLocal) in
            completion(personsFromLocal, .local)
        }
    }
}
