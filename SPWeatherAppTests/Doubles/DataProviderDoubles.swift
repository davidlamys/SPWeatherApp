//
//  DataProviderDoubles.swift
//  SPWeatherAppTests
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation
@testable import SPWeatherApp

class DataProviderStub: DataProviderType {

    private var dataSource: DataSource!
    private var payload = Items()

    private var stubResults = [FetchListItemsResultType]()
    private var stubWeatherResult: FetchWeatherResultType!
    private var stubWeatherIconResult: FetchWeatherIconResultType!

    var fetchListItemsCalledWithQuery: String?
    var fetchWeatherCalledWithLocation: Location?
    var fetchWeatherIconCalledWithURL: String?
    var storeItemCalledWithItem: Item?

    func reset() {
        dataSource = nil
        payload = []
    }

    func setupForGoodNetwork() {
        stubResults = [.successFromNetwork(items: stubPayload)]
    }

    func setupForGoodNetworkWithNoData() {
        stubResults = [.successFromNetwork(items: [])]
    }
    
    func setupForSuccessfulWeatherFetch() {
        stubWeatherResult = .successFromNetwork(weatherCondition: stubWeatherPayload)
    }
    
    func setupForSuccessfulWeatherIconFetch() {
        stubWeatherIconResult = .successFromNetwork(data: Data())
    }
    
    func setupForBadNework() {
        stubResults = [.failed]
    }

    func fetchListItems(query: String, completion: @escaping ((FetchListItemsResultType) -> Void)) {
        fetchListItemsCalledWithQuery = query
        if stubResults.isEmpty {
            print("end of stub results")
            return
        }

        let result = stubResults.removeFirst()
        completion(result)

    }
    
    func fetchWeather(for location: Location, completion: @escaping ((FetchWeatherResultType) -> Void)) {
        fetchWeatherCalledWithLocation = location
        if let stubWeatherResult = stubWeatherResult {
            completion(stubWeatherResult)
        }
    }
    
    func fetchIcon(urlString: String, completion: @escaping ((FetchWeatherIconResultType) -> Void)) {
        fetchWeatherIconCalledWithURL = urlString
        if let stubWeatherIconResult = stubWeatherIconResult {
            completion(stubWeatherIconResult)
        }
     }
     
    func store(item: Item) {
        storeItemCalledWithItem = item
    }

}
