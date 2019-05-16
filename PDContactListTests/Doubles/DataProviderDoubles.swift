//
//  DataProviderDoubles.swift
//  PDContactListTests
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

@testable import PDContactList

let stubPayload = [
    Person(id: 1, name: "David", email: []),
    Person(id: 2, name: "Mirjam", email: [])
]

class DataProviderStub: DataProviderType {

    private var dataSource: DataSource = .network
    private var payload = [Person]()
    
    func setupForGoodNetwork() {
        payload = stubPayload
        dataSource = .network
    }
    
    func setupForGoodNetworkWithNoData() {
        payload = [Person]()
        dataSource = .network
    }
    
    func fetchContactLists(completion: @escaping(([Person], DataSource) -> Void)) {
        completion(payload, dataSource)
    }
    
}
