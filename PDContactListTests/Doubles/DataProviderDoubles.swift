//
//  DataProviderDoubles.swift
//  PDContactListTests
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation
@testable import PDContactList

class DataProviderStub: DataProviderType {

    private var dataSource: DataSource!
    private var payload = [Person]()
    
    private var resultType: FetchContactListResultType!
    
    var imageLocalFetchCompletion: ((Data?) -> Void)?
    var imageNetworkFetchCompletion: ((Data?) -> Void)?
    
    func reset() {
        dataSource = nil
        payload = []
    }
    
    func setupForGoodNetwork() {
        resultType = .successFromNetwork(persons: stubPayload, hasMoreItems: false)
    }
    
    func setupForGoodNetworkWithNoData() {
        resultType = .successFromNetwork(persons: [], hasMoreItems: false)
    }
    
    func setupForBadNeworkWithNoLocalData() {
        resultType = .fallbackFromLocalStorage(persons: [])
    }
    
    func fetchContactLists(startIndex: Int, completion: @escaping ((FetchContactListResultType) -> Void)) {
        completion(resultType)
    }
    
    func fetchImage(imageHash: String,
                  localFetchCompletion: @escaping (Data?) -> Void,
                  networkFetchCompletion: @escaping (Data?) -> Void) {
        self.imageLocalFetchCompletion = localFetchCompletion
        self.imageNetworkFetchCompletion = networkFetchCompletion
    }
    
}
