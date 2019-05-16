//
//  LocalStorageProviderDoubles.swift
//  PDContactListTests
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

@testable import PDContactList

class LocalStorageProviderMock: LocalStorageProviderType {
    
    var saveContactListCalledWithData: [Person]!
    private var payload = [Person]()
    
    func reset() {
        saveContactListCalledWithData = nil
        payload = []
    }
    
    func setupForEmptyStorage() {
        payload = []
    }
    
    func setupStorageWithStubList() {
        payload = stubPayload
    }
    
    func getContactListFromLocal(completion: @escaping (([Person]) -> Void)) {
        completion(payload)
    }
    
    func saveContactList(data: [Person]) {
        saveContactListCalledWithData = data
    }
    
}

