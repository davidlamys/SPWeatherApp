//
//  DetailViewPresenterTests.swift
//  SPWeatherAppTests
//
//  Created by David_Lam on 18/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import XCTest
@testable import SPWeatherApp

class DetailViewPresenterTests: XCTestCase {

    var subject: DetailViewPresenter!
    var detailViewControllerMock: DetailViewControllerMock!
    var dataProvider: DataProviderStub!
    let location = stubPayload.first!
    
    override func setUp() {
        super.setUp()
        dataProvider = DataProviderStub()
        detailViewControllerMock = DetailViewControllerMock()
        subject = DetailViewPresenter(dataProvider: dataProvider,
                                      item: location,
                                      view: detailViewControllerMock)
    }

    func testWhenViewDidLoadIsCalled_ShouldCallInvokeSetupWithPersonInViewController() {
        subject.viewDidLoad()
        XCTAssert(detailViewControllerMock.setupViewCalledWithItem == location)
    }
    
    func testWhenViewDidLoad_ShouldFetchWeather() {
        subject.viewDidLoad()
        XCTAssert(dataProvider.fetchWeatherCalledWithLocation == location)
        XCTAssert(detailViewControllerMock.setupViewCalledWithStates == [.loadingWeather])
    }
    
    func testWhenFetchWeatherSucceed_ShouldCallSetupViewOnViewController() {
        dataProvider.setupForSuccessfulWeatherFetch()
        subject.viewDidLoad()
        XCTAssert(detailViewControllerMock.setupViewCalledWithStates == [.loadingWeather, .loaded(weather: stubWeatherPayload)])
    }
    
    func testWhenFetchWeatherSucceed_ShouldCallFetchWeatherIcon() {
        dataProvider.setupForSuccessfulWeatherFetch()
        subject.viewDidLoad()
        XCTAssert(dataProvider.fetchWeatherIconCalledWithURL == stubWeatherPayload.iconURLString)
    }
    
    func testWhenFetchWeatherIconSucceedToo_ShouldCallSetupViewOnViewController() {
        dataProvider.setupForSuccessfulWeatherFetch()
        dataProvider.setupForSuccessfulWeatherIconFetch()
        subject.viewDidLoad()
        
        let expectedStates: [DetailViewState] = [.loadingWeather,
                                                 .loaded(weather: stubWeatherPayload),
                                                 .loadedIcon(imageData: Data())]
        XCTAssert(detailViewControllerMock.setupViewCalledWithStates == expectedStates)
    }

}

