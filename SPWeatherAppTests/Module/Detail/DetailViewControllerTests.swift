//
//  DetailViewControllerTests.swift
//  SPWeatherAppTests
//
//  Created by David_Lam on 17/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import XCTest
@testable import SPWeatherApp

class DetailViewControllerTests: XCTestCase {

    var subject: DetailViewController!
    var viewPresenterMock = DetailViewPresenterMock()
    
    fileprivate typealias Text = DetailViewController.Text

    override func setUp() {
        subject = UIViewController.make(viewController: DetailViewController.self)
        subject.viewPresenter = viewPresenterMock
        viewPresenterMock.view = subject
        _  = subject.view
    }

    func testViewPresenterAwareThatViewHasLoaded() {
        subject.viewDidLoad()
        XCTAssert(viewPresenterMock.viewDidLoadCalled)
    }

    func testAccessibilityLabelsAreSetWhenViewDidLoadIsCalled() {
        subject.viewDidLoad()
        
        subject.loadingStackView.accessibilityIdentifier = "loadingStackView"
        subject.weatherIconImageView.accessibilityIdentifier = "weatherIconImageView"
        subject.weatherDescriptionLabel.accessibilityIdentifier = "weatherDescriptionLabel"
        subject.temperatureLabel.accessibilityIdentifier = "temperatureLabel"
        subject.humidityLabel.accessibilityIdentifier = "humidityLabel"
    }

    func testWhenSetupViewIsCalled() {
        let firstPost = stubPayload.first!
        subject.setupView(item: firstPost)
        
        XCTAssert(subject.title == firstPost.cityName)
    }
    
    func testWhenSetupViewWithLoading() {
        subject.setupView(state: .loadingWeather)
        
        XCTAssert(subject.loadingStackView.isHidden == false)
        XCTAssert(subject.loadingLabel.text == Text.loadingText.rawValue)
        
        XCTAssert(subject.weatherIconImageView.isHidden == true)
        XCTAssert(subject.weatherDescriptionLabel.isHidden == true)
        XCTAssert(subject.temperatureLabel.isHidden == true)
        XCTAssert(subject.humidityLabel.isHidden == true)
    }
    
    func testWhenSetupViewWithWeatherCondition() {
        let fetchedWeather = stubWeatherPayload
        subject.setupView(state: .loaded(weather: fetchedWeather))
             
        XCTAssert(subject.loadingStackView.isHidden == false)
        XCTAssert(subject.weatherIconImageView.isHidden == true)
        
        XCTAssert(subject.weatherDescriptionLabel.isHidden == false)
        XCTAssert(subject.weatherDescriptionLabel.text == fetchedWeather.weatherDescription)
        
        XCTAssert(subject.temperatureLabel.isHidden == false)
        let expectedTemperatureLabelText = String(format: Text.temperatureText.rawValue, fetchedWeather.tempC)
        XCTAssert(subject.temperatureLabel.text == expectedTemperatureLabelText)
        
        XCTAssert(subject.humidityLabel.isHidden == false)
        let expectedHumidityLabelText = String(format: Text.humidityText.rawValue, fetchedWeather.humidity)
        XCTAssert(subject.humidityLabel.text == expectedHumidityLabelText)
    }
    
    func testWhenSetupViewWithWeatherIcon() {
        let imageData = Data()
        subject.setupView(state: .loadedIcon(imageData: imageData))
        
        XCTAssert(subject.loadingStackView.isHidden == true)
        XCTAssert(subject.weatherIconImageView.isHidden == false)
    }

}
