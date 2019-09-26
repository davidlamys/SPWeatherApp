//
//  DetailViewController.swift
//  TWNewsReader
//
//  Created by David_Lam on 17/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import UIKit

protocol DetailViewControllerType: class {
    func setupView(state: ImageViewState)
    func setupView(person: Person)
}

final class DetailViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView! // in a bigger project, the image view and the loading spinner will be in a component =/
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var organizationLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    @IBOutlet weak var organizationStackView: UIStackView!
    @IBOutlet weak var phoneStackView: UIStackView!
    @IBOutlet weak var emailStackView: UIStackView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    var viewModel: DetailViewModelType!

    fileprivate var hasSetImageFromNetwork: Bool = false
    fileprivate var hasImageFetchHasFailed: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        activityIndicatorView.hidesWhenStopped = true
    }
}

extension DetailViewController: DetailViewControllerType {
    func setupView(state: ImageViewState) {
        if Thread.isMainThread {
            setupViewOnMainThread(state: state)
        } else {
            DispatchQueue.main.async {
                self.setupViewOnMainThread(state: state)
            }
        }

    }

    func setupView(person: Person) {
        if Thread.isMainThread {
            setupViewOnMainThread(person: person)
        } else {
            DispatchQueue.main.async {
                self.setupViewOnMainThread(person: person)
            }
        }
    }

    private func setupViewOnMainThread(state: ImageViewState) {
        precondition(Thread.isMainThread)
        switch state {
        case .localData(let data):
            if hasSetImageFromNetwork == false,
                let image = UIImage(data: data) {
                profileImageView.image = image
            }

            if hasImageFetchHasFailed == false {
                activityIndicatorView.startAnimating()
                activityIndicatorView.isHidden = false
            }
        case .fetching:
            activityIndicatorView.startAnimating()
            activityIndicatorView.isHidden = false
        case .succeeded(let data):
            if let image = UIImage(data: data) {
                profileImageView.image = image
                hasSetImageFromNetwork = true
            }
            activityIndicatorView.stopAnimating()
        case .failed:
            hasImageFetchHasFailed = true
            activityIndicatorView.stopAnimating()
        }
    }

    private func setupViewOnMainThread(person: Person) {
        precondition(Thread.isMainThread)
        nameLabel.text = person.name
        organizationLabel.text = person.orgId?.name
        phoneLabel.text = person.primaryPhone?.value
        emailLabel.text = person.primaryEmail?.value

        organizationStackView.isHidden = (person.orgId == nil)
        phoneStackView.isHidden = (person.primaryPhone?.value == nil)
        emailStackView.isHidden = (person.primaryEmail?.value == nil)
    }

}
