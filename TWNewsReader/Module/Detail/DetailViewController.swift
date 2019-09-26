//
//  DetailViewController.swift
//  TWNewsReader
//
//  Created by David_Lam on 17/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import UIKit

protocol DetailViewControllerType: class {
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

    func setupView(person: Person) {
        if Thread.isMainThread {
            setupViewOnMainThread(person: person)
        } else {
            DispatchQueue.main.async {
                self.setupViewOnMainThread(person: person)
            }
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
