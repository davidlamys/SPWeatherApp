//
//  DetailViewModelTests.swift
//  PDContactListTests
//
//  Created by David_Lam on 18/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import XCTest
@testable import PDContactList

class DetailViewModelTests: XCTestCase {
    
    var subject: DetailViewModel!
    var detailViewControllerMock: DetailViewControllerMock!
    var dataProvider: DataProviderStub!
    let david = stubPayload.first!
    
    override func setUp() {
        super.setUp()
        detailViewControllerMock = DetailViewControllerMock()
        dataProvider = DataProviderStub()
        subject = DetailViewModel(view: detailViewControllerMock,
                                  dataProvider: dataProvider,
                                  person: david)
    }
    
    func testWhenViewDidLoadIsCalled_ShouldCallInvokeSetupWithPersonInViewController() {
        subject.viewDidLoad()
        assert(detailViewControllerMock.setupViewCalledWithPerson == david)
    }
    
    func testWhenPersonHasNoEmail() {
        subject = DetailViewModel(view: detailViewControllerMock,
                                  dataProvider: dataProvider,
                                  person: stubPayload.last!)
        assert(detailViewControllerMock.setupViewCalledWithStates == [])
    }
    
    func testWhenViewDidLoadIsCalled_UnderGoodNetworkWithExistingImageInLocalStorage() {
        subject.viewDidLoad()
        dataProvider.imageLocalFetchCompletion?(stubImageData)
        dataProvider.imageNetworkFetchCompletion?(stubImageData)
        
        let expectedStates: [ImageViewState] = [
            ImageViewState.fetching,
            ImageViewState.localData(data: stubImageData),
            ImageViewState.succeeded(data: stubImageData)
        ]
        
        assert(detailViewControllerMock.setupViewCalledWithStates == expectedStates)
    }
    
    func testWhenViewDidLoadIsCalled_UnderGoodNetworkWithoutExistingImageInLocalStorage() {
        subject.viewDidLoad()
        dataProvider.imageLocalFetchCompletion?(nil)
        dataProvider.imageNetworkFetchCompletion?(stubImageData)
        
        let expectedStates: [ImageViewState] = [
            ImageViewState.fetching,
            ImageViewState.succeeded(data: stubImageData)
        ]
        
        assert(detailViewControllerMock.setupViewCalledWithStates == expectedStates)
    }
    
    func testWhenViewDidLoadIsCalled_UnderBadNetworkWithExistingImageInLocalStorage() {
        subject.viewDidLoad()
        dataProvider.imageLocalFetchCompletion?(stubImageData)
        dataProvider.imageNetworkFetchCompletion?(nil)
        
        let expectedStates: [ImageViewState] = [
            ImageViewState.fetching,
            ImageViewState.localData(data: stubImageData),
            ImageViewState.failed
        ]
        
        assert(detailViewControllerMock.setupViewCalledWithStates == expectedStates)
    }
    
    func testWhenViewDidLoadIsCalled_UnderBadNetworkWithoutExistingImageInLocalStorage() {
        subject.viewDidLoad()
        dataProvider.imageLocalFetchCompletion?(nil)
        dataProvider.imageNetworkFetchCompletion?(nil)
        
        let expectedStates: [ImageViewState] = [
            ImageViewState.fetching,
            ImageViewState.failed
        ]
        
        assert(detailViewControllerMock.setupViewCalledWithStates == expectedStates)
    }

}
