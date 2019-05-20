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
    
    private var stubResults = [FetchContactListResultType]()
    
    var imageLocalFetchCompletion: ((Data?) -> Void)?
    var imageNetworkFetchCompletion: ((Data?) -> Void)?
    
    func reset() {
        dataSource = nil
        payload = []
    }
    
    func setupForGoodNetwork() {
        stubResults = [.successFromNetwork(persons: stubPayload, hasMoreItems: false)]
    }
    
    func setupForGoodNetworkWithMultipageData() {
        stubResults = [.successFromNetwork(persons: stubPayload, hasMoreItems: true),
                      .successFromNetwork(persons: stubPayload, hasMoreItems: false)]
    }
    
    func setupForGoodNetworkWithNoData() {
        stubResults = [.successFromNetwork(persons: [], hasMoreItems: false)]
    }
    
    func setupForBadNeworkWithNoLocalData() {
        stubResults = [.fallbackFromLocalStorage(persons: [])]
    }
    
    func fetchContactLists(startIndex: Int, completion: @escaping ((FetchContactListResultType) -> Void)) {
        if stubResults.isEmpty {
            print("end of stub results")
            return
        }
        
        let result = stubResults.removeFirst()
        completion(result)
        
    }
    
    func fetchImage(imageHash: String,
                  localFetchCompletion: @escaping (Data?) -> Void,
                  networkFetchCompletion: @escaping (Data?) -> Void) {
        self.imageLocalFetchCompletion = localFetchCompletion
        self.imageNetworkFetchCompletion = networkFetchCompletion
    }
    
}
