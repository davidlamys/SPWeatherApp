//
//  DetailViewControllerTests.swift
//  TWNewsReaderTests
//
//  Created by David_Lam on 17/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import XCTest
@testable import TWNewsReader

class DetailViewControllerTests: XCTestCase {

    var subject: DetailViewController!
    var viewModelMock = DetailViewModelMock()

    override func setUp() {
        subject = UIViewController.make(viewController: DetailViewController.self)
        subject.viewModel = viewModelMock
        viewModelMock.view = subject
        _  = subject.view
    }

    func testViewModelAwareThatViewHasLoaded() {
        subject.viewDidLoad()
        assert(viewModelMock.viewDidLoadCalled)
    }

    // MARK: - setup for person

    func testSetupForPersonWithAllDetails() {
        let person = Person(id: 1,
                            name: "some name",
                            orgId: stubOrg,
                            phone: [stubPhone],
                            email: [stubEmail])

        subject.setupView(person: person)

        assert(subject.nameLabel.text == "some name")

        assert(subject.organizationLabel.text == stubOrg.name)
        assert(subject.organizationStackView.isHidden == false)

        assert(subject.phoneLabel.text == stubPhone.value)
        assert(subject.phoneStackView.isHidden == false)

        assert(subject.emailLabel.text == stubEmail.value)
        assert(subject.emailStackView.isHidden == false)
    }

    func testSetupForPersonWithMissingOrganizationShouldHideStackView() {
        let person = Person(id: 1,
                            name: "some name",
                            orgId: nil,
                            phone: [stubPhone],
                            email: [stubEmail])

        subject.setupView(person: person)

        assert(subject.nameLabel.text == "some name")

        assert(subject.organizationLabel.text == nil)
        assert(subject.organizationStackView.isHidden == true)

        assert(subject.phoneLabel.text == stubPhone.value)
        assert(subject.phoneStackView.isHidden == false)

        assert(subject.emailLabel.text == stubEmail.value)
        assert(subject.emailStackView.isHidden == false)
    }

    func testSetupForPersonWithMissingPhoneShouldHideStackView() {
        let person = Person(id: 1,
                            name: "some name",
                            orgId: stubOrg,
                            phone: [],
                            email: [stubEmail])

        subject.setupView(person: person)

        assert(subject.nameLabel.text == "some name")

        assert(subject.organizationLabel.text == stubOrg.name)
        assert(subject.organizationStackView.isHidden == false)

        assert(subject.phoneLabel.text == nil)
        assert(subject.phoneStackView.isHidden == true)

        assert(subject.emailLabel.text == stubEmail.value)
        assert(subject.emailStackView.isHidden == false)
    }

    func testSetupForPersonWithMissingEmailShouldHideStackView() {
        let person = Person(id: 1,
                            name: "some name",
                            orgId: stubOrg,
                            phone: [stubPhone],
                            email: [])

        subject.setupView(person: person)

        assert(subject.nameLabel.text == "some name")

        assert(subject.organizationLabel.text == stubOrg.name)
        assert(subject.organizationStackView.isHidden == false)

        assert(subject.phoneLabel.text == stubPhone.value)
        assert(subject.phoneStackView.isHidden == false)

        assert(subject.emailLabel.text == nil)
        assert(subject.emailStackView.isHidden == true)
    }

    // MARK: - setup for image view
    func testSetupForDetailViewStateWithPrefetchedLocalData() {
        subject.profileImageView.image = nil // although we did set it in the storeboard, we set it to nil for testing purposes
        let prefetchState = ImageViewState.localData(data: stubImageData)
        subject.setupView(state: prefetchState)

        assert(subject.profileImageView.image != nil)
        assert(subject.activityIndicatorView.isHidden == false)
        assert(subject.activityIndicatorView.isAnimating == true)
    }

    func testSetupForDetailViewStateWithFetchingState() {
        subject.profileImageView.image = nil // although we did set it in the storeboard, we set it to nil for testing purposes
        let fetchingState = ImageViewState.fetching
        subject.setupView(state: fetchingState)

        assert(subject.profileImageView.image == nil)
        assert(subject.activityIndicatorView.isHidden == false)
        assert(subject.activityIndicatorView.isAnimating == true)
    }

    func testSetupForDetailViewStateWithSuccessState() {
        subject.profileImageView.image = nil // although we did set it in the storeboard, we set it to nil for testing purposes
        let success = ImageViewState.succeeded(data: stubImageData)
        subject.setupView(state: success)

        assert(subject.profileImageView.image != nil)
        assert(subject.activityIndicatorView.isHidden == true)
        assert(subject.activityIndicatorView.isAnimating == false)
    }

    func testSetupForDetailViewStateWithFailedState() {
        subject.profileImageView.image = nil // although we did set it in the storeboard, we set it to nil for testing purposes
        let failedState = ImageViewState.failed
        subject.setupView(state: failedState)

        assert(subject.profileImageView.image == nil)
        assert(subject.activityIndicatorView.isHidden == true)
        assert(subject.activityIndicatorView.isAnimating == false)
    }

    func testShouldNotOverrideNetworkImageWithLocalImage() {
        subject.profileImageView.image = nil
        let networkFetchSuccess = ImageViewState.succeeded(data: stubImageData)
        let delayedLocalStorageResponse = ImageViewState.localData(data: stubImageDataTwo)
        subject.setupView(state: networkFetchSuccess)
        subject.setupView(state: delayedLocalStorageResponse)

        assert(subject.profileImageView.image!.pngData() == stubImageData)
    }

}
