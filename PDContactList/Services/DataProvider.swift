//
//  DataProvider.swift
//  PDContactList
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

enum DataSource {
    case local
    case network
}

protocol DataProviderType {
    func fetchContactLists(completion: @escaping(([Person], DataSource) -> Void))
}

struct DataProvider: DataProviderType {
    func fetchContactLists(completion: @escaping (([Person], DataSource) -> Void)) {
        
    }
}
