//
//  DataProviderDoubles.swift
//  TWNewsReaderTests
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation
@testable import TWNewsReader

class DataProviderStub: DataProviderType {

    private var dataSource: DataSource!
    private var payload = Items()

    private var stubResults = [FetchListItemsResultType]()

    var fetchListItemsCalledWithIndex: Int?

    func reset() {
        dataSource = nil
        payload = []
    }

    func setupForGoodNetwork() {
        stubResults = [.successFromNetwork(items: stubPayload)]
    }

    func setupForGoodNetworkWithNoData() {
        stubResults = [.successFromNetwork(items: [])]
    }

    func setupForBadNeworkWithNoLocalData() {
        stubResults = [.fallbackFromLocalStorage(items: [])]
    }
    
    func setupForBadNeworkWithSomeLocalData() {
        stubResults = [.fallbackFromLocalStorage(items: stubPayload)]
    }

    func fetchListItems(completion: @escaping ((FetchListItemsResultType) -> Void)) {
        fetchListItemsCalledWithIndex = 0
        if stubResults.isEmpty {
            print("end of stub results")
            return
        }

        let result = stubResults.removeFirst()
        completion(result)

    }

}
