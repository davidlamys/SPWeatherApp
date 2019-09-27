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
    func fetchListItems(startIndex: Int,
                        completion: @escaping((FetchListItemsResultType) -> Void))
}

struct DataProvider: DataProviderType {

    typealias FetchListItemsHandler = ((FetchListItemsResultType) -> Void)

    let clientType: NetworkClientType
    let localStorageProvider: LocalStorageProviderType

    init(clientType: NetworkClientType = NetworkClient.sharedInstance,
         localStorageProvider: LocalStorageProviderType = LocalStorageProvider()) {
        self.clientType = clientType
        self.localStorageProvider = localStorageProvider
    }

    fileprivate func handleSuccessResponse(_ response: (NetworkResponse),
                                           startIndex: Int,
                                           completion: @escaping FetchListItemsHandler) {
        if let persons = response.data {
            if startIndex == 0 {
                self.localStorageProvider.deleteListItems()
            }
            self.localStorageProvider.insertListItems(data: persons)
            let hasMoreItems = (response.hasMoreItems)
            completion(.successFromNetwork(items: persons, hasMoreItems: hasMoreItems))
        } else if response.hasReachedRateLimit {
            print("has reached rate limit")
        } else {
            print(response)
        }
    }

    func fetchListItems(startIndex: Int = 0,
                        completion: @escaping FetchListItemsHandler) {
        clientType.request(request: .fetchListItems(startIndex: startIndex),
                       translator: TWNetworkResponseTranslator.translateFromNetworkResponse) { result in
            precondition(Thread.isMainThread == false)
            switch result {
            case .failure(let error):
                logError(error)
                self.getListItemsFromLocal(completion: completion)
            case .success(let response):
                self.handleSuccessResponse(response,
                                           startIndex: startIndex,
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
