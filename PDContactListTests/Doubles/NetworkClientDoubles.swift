//
//  NetworkClientDoubles.swift
//  PDContactListTests
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation
@testable import PDContactList

class NetworkClientStub: NetworkClientType {
    private var result: Any?
    private var error: Error?
    
    func reset() {
        result = nil
        error = nil
    }
    
    func setupForGetContactListUnderGoodNetwork() {
        result = stubPayload
        error = nil
    }
    
    func setupForNetworkError() {
        result = nil
        error = NSError(domain: "some error", code: 1, userInfo: [:])
    }
    
    func request<T>(request: RequestType,
                    translator: @escaping (Data) -> (Result<T, Error>),
                    completion: @escaping (Result<T, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let result = self.result as? T {
                completion(Result.success(result))
            } else if let error = self.error {
                completion(Result.failure(error))
            }
        }
    }
}
