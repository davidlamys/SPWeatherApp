//
//  SessionDoubles.swift
//  TWNewsReaderTests
//
//  Created by David_Lam on 27/9/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation
@testable import TWNewsReader

class SessionStub: SessionType {

    private var result: Data?
    private var error: Error?

    func reset() {
        result = nil
        error = nil
    }

    func setupForGetListItemsUnderGoodNetwork() {
        result = ResponseLoader.loadLocalResponse(file: "StubPostsResponse")
        error = nil
    }

    func setupForNetworkError() {
        result = nil
        error = NSError(domain: "some error", code: 1, userInfo: [:])
    }

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        DispatchQueue.global(qos: .background).async {
            completionHandler(self.result, nil, self.error)
        }
        return URLSessionDataTask()
    }
}
