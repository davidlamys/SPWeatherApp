//
//  DetailViewController.swift
//  SPWeatherApp
//
//  Created by David_Lam on 17/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import UIKit

protocol DetailViewControllerType: class {
    func setupView(item: Item)
}

final class DetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!

    var viewPresenter: DetailViewPresenterType!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewPresenter.viewDidLoad()
        titleLabel.accessibilityLabel = "Item Title"
        bodyTextView.accessibilityLabel = "Item Body"
    }
}

extension DetailViewController: DetailViewControllerType {

    func setupView(item: Item) {
        if Thread.isMainThread {
            setupViewOnMainThread(item: item)
        } else {
            DispatchQueue.main.async {
                self.setupViewOnMainThread(item: item)
            }
        }
    }

    private func setupViewOnMainThread(item: Item) {
        precondition(Thread.isMainThread)
        titleLabel.text = item.title
        bodyTextView.text = item.body
    }

}
