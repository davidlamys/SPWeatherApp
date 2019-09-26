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

enum FetchContactListResultType {
    case successFromNetwork(items: Items, hasMoreItems: Bool)
    case fallbackFromLocalStorage(items: Items)
}

protocol DataProviderType {
    func fetchContactLists(startIndex: Int,
                           completion: @escaping((FetchContactListResultType) -> Void))
}

struct DataProvider: DataProviderType {

    typealias fetchContactListHandler = ((FetchContactListResultType) -> Void)

    let clientType: NetworkClientType
    let localStorageProvider: LocalStorageProviderType

    init(clientType: NetworkClientType = NetworkClient.sharedInstance,
         localStorageProvider: LocalStorageProviderType = LocalStorageProvider()) {
        self.clientType = clientType
        self.localStorageProvider = localStorageProvider
    }

    fileprivate func handleSuccessResponse(_ response: (NetworkResponse),
                                           startIndex: Int,
                                           completion: @escaping fetchContactListHandler) {
        if let persons = response.data {
            if startIndex == 0 {
                self.localStorageProvider.deleteContactList()
            }
            self.localStorageProvider.insertContactList(data: persons)
            let hasMoreItems = (response.hasMoreItems)
            completion(.successFromNetwork(items: persons, hasMoreItems: hasMoreItems))
        } else if response.hasReachedRateLimit {
            print("has reached rate limit")
        } else {
            print(response)
        }
    }

    func fetchContactLists(startIndex: Int = 0,
                           completion: @escaping fetchContactListHandler) {
        clientType.request(request: .fetchContactList(startIndex: startIndex),
                       translator: TWNetworkResponseTranslator.translateFromNetworkResponse) { result in
            precondition(Thread.isMainThread == false)
            switch result {
            case .failure(let error):
                logError(error)
                self.getContactListFromLocal(completion: completion)
            case .success(let response):
                self.handleSuccessResponse(response,
                                           startIndex: startIndex,
                                           completion: completion)
            }
        }
    }

    private func getContactListFromLocal(completion: @escaping ((FetchContactListResultType) -> Void)) {
        localStorageProvider.getContactListFromLocal { (personsFromLocal) in
            completion(.fallbackFromLocalStorage(items: personsFromLocal))
        }
    }

}
