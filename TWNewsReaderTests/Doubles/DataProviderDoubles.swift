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

    private var stubResults = [FetchContactListResultType]()

    var imageLocalFetchCompletion: ((Data?) -> Void)?
    var imageNetworkFetchCompletion: ((Data?) -> Void)?
    var fetchContactListCalledWithIndex: Int? = nil

    func reset() {
        dataSource = nil
        payload = []
    }

    func setupForGoodNetwork() {
        stubResults = [.successFromNetwork(items: stubPayload, hasMoreItems: false)]
    }

    func setupForGoodNetworkWithMultipageData() {
        stubResults = [.successFromNetwork(items: stubPayload, hasMoreItems: true),
                      .successFromNetwork(items: stubPayload, hasMoreItems: false)]
    }

    func setupForGoodNetworkWithNoData() {
        stubResults = [.successFromNetwork(items: [], hasMoreItems: false)]
    }

    func setupForBadNeworkWithNoLocalData() {
        stubResults = [.fallbackFromLocalStorage(items: [])]
    }

    func fetchContactLists(startIndex: Int, completion: @escaping ((FetchContactListResultType) -> Void)) {
        fetchContactListCalledWithIndex = startIndex
        if stubResults.isEmpty {
            print("end of stub results")
            return
        }

        let result = stubResults.removeFirst()
        completion(result)

    }

}
