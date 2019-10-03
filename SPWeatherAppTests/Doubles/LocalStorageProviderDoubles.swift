//
//  LocalStorageProviderDoubles.swift
//  SPWeatherAppTests
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//
import Foundation
@testable import SPWeatherApp

class LocalStorageProviderMock: LocalStorageProviderType {


    var insertListItemCalledWithItem: Item!
    var getListItemsCalled = false
    var deleteListItemsCalled = false
    private var payload = Items()

    func reset() {
        insertListItemCalledWithItem = nil
        payload = []
    }

    func setupForEmptyStorage() {
        payload = []
    }

    func setupStorageWithStubList() {
        payload = stubPayload
    }

    func deleteListItems() {
        deleteListItemsCalled = true
    }

    func getListItemsFromLocal(completion: @escaping ((Items) -> Void)) {
        getListItemsCalled = true
        completion(payload)
    }
    
    func insertItem(item: Item) {
        insertListItemCalledWithItem = item
    }
    

    func getImage(hash: String, completion: @escaping ((Data?) -> Void)) {

    }

}
