//
//  DataProvider.swift
//  SPWeatherApp
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
    case successFromNetwork(items: Items)
    case failed
}

extension FetchListItemsResultType: Equatable {}

protocol DataProviderType {
    func fetchListItems(query: String, completion: @escaping((FetchListItemsResultType) -> Void))
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

    func fetchListItems(query: String,
                        completion: @escaping FetchListItemsHandler) {
        clientType.request(request: .fetchListItems(query: query),
                           translator: Translator.translateFromNetworkResponse) { result in
            precondition(Thread.isMainThread == false)
            switch result {
            case .failure(let error):
                logError(error)
                completion(.failed)
            case .success(let response):
                completion(.successFromNetwork(items: response))
            }
        }
    }

}
