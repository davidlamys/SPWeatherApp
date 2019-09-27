//
//  DataProvider.swift
//  TWNewsReader
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

enum DataSource {
    case local
    case network
}

enum FetchListItemsResultType {
    case successFromNetwork(items: Items, hasMoreItems: Bool)
    case fallbackFromLocalStorage(items: Items)
}

protocol DataProviderType {
    func fetchListItems(completion: @escaping((FetchListItemsResultType) -> Void))
}

struct DataProvider: DataProviderType {

    typealias FetchListItemsHandler = ((FetchListItemsResultType) -> Void)

    let clientType: NetworkClientType
    let localStorageProvider: LocalStorageProviderType

    init(clientType: NetworkClientType = NetworkClient(),
         localStorageProvider: LocalStorageProviderType = LocalStorageProvider()) {
        self.clientType = clientType
        self.localStorageProvider = localStorageProvider
    }

    fileprivate func handleSuccessResponse(_ items: Items,
                                           completion: @escaping FetchListItemsHandler) {
    
        self.localStorageProvider.deleteListItems()
        self.localStorageProvider.insertListItems(data: items)
        completion(.successFromNetwork(items: items, hasMoreItems: false))
        
    }
    
    

    func fetchListItems(completion: @escaping FetchListItemsHandler) {
        clientType.request(request: .fetchListItems,
                           translator: Translator.translateFromNetworkResponse) { result in
            precondition(Thread.isMainThread == false)
            switch result {
            case .failure(let error):
                logError(error)
                self.getListItemsFromLocal(completion: completion)
            case .success(let response):
                self.handleSuccessResponse(response,
                                           completion: completion)
            }
        }
    }

    private func getListItemsFromLocal(completion: @escaping ((FetchListItemsResultType) -> Void)) {
        localStorageProvider.getListItemsFromLocal { (personsFromLocal) in
            completion(.fallbackFromLocalStorage(items: personsFromLocal))
        }
    }

}
