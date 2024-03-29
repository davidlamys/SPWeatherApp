//
//  NetworkClient.swift
//  SPWeatherApp
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

// while api key is usually private and could be injected in jenkins, this is just an api key for the weather api...so...yolo..¯\_(ツ)_/¯
private let key = "f475ee8edfaf447697e31822192509"

enum RequestType {
    case fetchListItems(query: String)
    case fetchCityWeather(lat: Double, lon: Double)
    case fetch(urlString: String)

    var baseURL: String {
        switch self {
        case .fetchListItems:
            return "https://api.worldweatheronline.com/premium/v1/search.ashx?"
        case .fetchCityWeather:
            return "https://api.worldweatheronline.com/premium/v1/weather.ashx?"
        case .fetch:
            return ""
        }
    }

    func getURLString() -> String {
        switch self {
        case .fetchListItems(let query):
            let urlString = baseURL + "key=\(key)" + "&q=\(query)" + "&format=json&popular=no&num_of_results=200"
            return urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        case .fetchCityWeather(let lat, let lon):
            let urlString = baseURL + "key=\(key)" + "&q=\(lat),\(lon)" + "&format=json&num_of_days=0&fx=no&mca=no&fx24=no&show_comments=no"
            return urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        case .fetch(let urlString):
            return urlString
        }
    }
}

extension RequestType: Equatable {}

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
