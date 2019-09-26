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

}
