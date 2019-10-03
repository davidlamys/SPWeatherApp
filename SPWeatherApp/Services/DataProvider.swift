//
//  DataProvider.swift
//  SPWeatherApp
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

enum DataSource {
    case local
    case network
}

// TODO: generalise result type if possible
enum FetchListItemsResultType {
    case successFromNetwork(items: Items)
    case failed
}
extension FetchListItemsResultType: Equatable {}

enum FetchWeatherResultType {
    case successFromNetwork(weatherCondition: WeatherCondition)
    case failed
}
extension FetchWeatherResultType: Equatable {}

enum FetchWeatherIconResultType {
    case successFromNetwork(data: Data)
    case failed
}
extension FetchWeatherIconResultType: Equatable {}

protocol DataProviderType {
    func fetchListItems(query: String, completion: @escaping((FetchListItemsResultType) -> Void))
    func fetchWeather(for location: Location, completion: @escaping((FetchWeatherResultType) -> Void))
    func fetchIcon(urlString: String, completion: @escaping((FetchWeatherIconResultType) -> Void))
}

struct DataProvider: DataProviderType {

    typealias FetchListItemsHandler = ((FetchListItemsResultType) -> Void)

    let clientType: NetworkClientType
    let localStorageProvider: LocalStorageProviderType

    init(clientType: NetworkClientType = NetworkClient(),
         localStorageProvider: LocalStorageProviderType = LocalStorageProvider()) {
        self.clientType = clientType
        self.localStorageProvider = localStorageProvider
    }

    func fetchListItems(query: String,
                        completion: @escaping FetchListItemsHandler) {
        clientType.request(request: .fetchListItems(query: query),
                           translator: Translator.translateFromNetworkResponse) { result in
            precondition(Thread.isMainThread == false)
            switch result {
            case .failure(let error):
                logError(error)
                completion(.failed)
            case .success(let response):
                completion(.successFromNetwork(items: response))
            }
        }
    }
    
    func fetchWeather(for location: Location, completion: @escaping (FetchWeatherResultType) -> Void) {
        guard let lat = location.lat, let lon = location.lon else {
            fatalError("throw defined error instead")
        }
        let request = RequestType.fetchCityWeather(lat: lat, lon: lon)
        clientType.request(request: request,
                           translator: WeatherTranslator.translateFromNetworkResponse) { result in
            precondition(Thread.isMainThread == false)
            switch result {
            case .failure(let error):
                logError(error)
                completion(.failed)
            case .success(let response):
                completion(.successFromNetwork(weatherCondition: response))
            }
        }
    }
    
    func fetchIcon(urlString: String, completion: @escaping ((FetchWeatherIconResultType) -> Void)) {
        let request = RequestType.fetch(urlString: urlString)
        clientType.request(request: request, translator: { data in
            return Result.success(data)
        }) { result in
            precondition(Thread.isMainThread == false)
            switch result {
            case .failure(let error):
                logError(error)
                completion(.failed)
            case .success(let data):
                completion(.successFromNetwork(data: data))
            }
        }
     }

}
