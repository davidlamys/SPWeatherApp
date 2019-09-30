//
//  NetworkClient.swift
//  SPWeatherApp
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

enum RequestType {
    case fetchListItems

    var baseURL: String {
        switch self {
        case .fetchListItems:
            return "https://jsonplaceholder.typicode.com/posts"
        }
    }

    var parsingQueueLabel: String {
        switch self {
        case .fetchListItems:
            return "fetchListItems"
        }
    }

    func getURLString() -> String {
        switch self {
        case .fetchListItems:
            return baseURL
        }
    }
}

protocol NetworkClientType {
    func request<T>(request: RequestType,
                           translator: @escaping (Data) -> (Result<T, Error>),
                           completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkClient: NetworkClientType {
    fileprivate let session: SessionType

    init(session: SessionType = URLSession.shared) {
        self.session = session
    }

    func request<T>(request: RequestType,
                    translator: @escaping (Data) -> (Result<T, Error>),
                    completion: @escaping (Result<T, Error>) -> Void) {

        guard let url = URL(string: request.getURLString()) else {
            fatalError("failed to create url")
        }

        let task = session.dataTask(with: url) { (data, _, error) in
            if let data = data {
                precondition(Thread.isMainThread == false)
                let translated = translator(data)
                completion((translated))
            } else if let error = error {
                completion(Result.failure(error))
            } else {
                let unknownError = NSError.init(domain: "com.david.SPWeatherApp", code: -1, userInfo: ["info": "unknown network error"])
                completion(Result.failure(unknownError))
            }
        }

        task.resume()

    }
}
