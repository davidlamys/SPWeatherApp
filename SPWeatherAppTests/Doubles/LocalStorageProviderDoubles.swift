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

    var insertListItemsCalledWithData: Items!
    var saveImageCalledWith: (hash: String, data: Data)!
    var getListItemsCalled = false
    var deleteListItemsCalled = false
    private var payload = Items()

    func reset() {
        insertListItemsCalledWithData = nil
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

    func insertListItems(data: Items) {
        insertListItemsCalledWithData = data
    }

    func getImage(hash: String, completion: @escaping ((Data?) -> Void)) {

    }

    func saveImage(hash: String, data: Data) {
        saveImageCalledWith = (hash: hash, data: data)
    }

}
