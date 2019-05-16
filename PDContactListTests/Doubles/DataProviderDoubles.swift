//
//  DataProviderDoubles.swift
//  PDContactListTests
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

@testable import PDContactList

let stubOrg = Person.Organization(name: "Drivepipe",
                                  peopleCount: 1,
                                  address: "Dr. Atl 123, Santa María La Ribera, Mexico City, CDMX, Mexico")
let stubPayload = [
    Person(id: 1, name: "David", orgId: stubOrg, phone:[], email: []),
    Person(id: 2, name: "Mirjam", orgId: stubOrg, phone:[], email: [])
]

class DataProviderStub: DataProviderType {

    private var dataSource: DataSource!
    private var payload = [Person]()
    
    func reset() {
        dataSource = nil
        payload = []
    }
    
    func setupForGoodNetwork() {
        payload = stubPayload
        dataSource = .network
    }
    
    func setupForGoodNetworkWithNoData() {
        payload = [Person]()
        dataSource = .network
    }
    
    func setupForBadNeworkWithNoLocalData() {
        payload = [Person]()
        dataSource = .local
    }
    
    func fetchContactLists(completion: @escaping(([Person], DataSource) -> Void)) {
        completion(payload, dataSource)
    }
    
}
