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
    func fetchImage(imageHash: String,
                    localFetchCompletion: @escaping(Data?) -> Void,
                    networkFetchCompletion: @escaping(Data?) -> Void)
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
                       translator: PersonTranslator.translateFromNetworkResponse) { result in
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
    
    func fetchImage(imageHash:String,
                    localFetchCompletion: @escaping (Data?) -> Void,
                    networkFetchCompletion: @escaping (Data?) -> Void) {
        
        localStorageProvider.getImage(hash: imageHash, completion: localFetchCompletion)
        clientType.request(request: .fetchGravatar(hash: imageHash),
                           translator: { Result.success($0) },
                           completion:
            { result in
                switch result {
                case .success(let data):
                    self.localStorageProvider.saveImage(hash: imageHash, data: data)
                    networkFetchCompletion(data)
                case .failure(let error):
                    logError(error)
                    networkFetchCompletion(nil)
                }
        })
    
    }
    
}
