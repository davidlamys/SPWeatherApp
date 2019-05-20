//
//  LocalStorageProviderDoubles.swift
//  PDContactListTests
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//
import Foundation
@testable import PDContactList

class LocalStorageProviderMock: LocalStorageProviderType {
    
    var upsertContactListCalledWithData: [Person]!
    var saveImageCalledWith: (hash: String, data: Data)!
    var getContactListCalled = false
    var deleteContactListCalled = false
    private var payload = [Person]()
    
    func reset() {
        upsertContactListCalledWithData = nil
        payload = []
    }
    
    func setupForEmptyStorage() {
        payload = []
    }
    
    func setupStorageWithStubList() {
        payload = stubPayload
    }
    
    func deleteContactList() {
        deleteContactListCalled = true
    }
    
    func getContactListFromLocal(completion: @escaping (([Person]) -> Void)) {
        getContactListCalled = true
        completion(payload)
    }
    
    func upsertContactList(data: [Person]) {
        upsertContactListCalledWithData = data
    }
    
    func getImage(hash: String, completion: @escaping ((Data?) -> Void)) {
        
    }
    
    func saveImage(hash: String, data: Data) {
        saveImageCalledWith = (hash: hash, data: data)
    }
    
}

