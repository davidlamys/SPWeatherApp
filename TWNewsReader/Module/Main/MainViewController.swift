//
//  MainViewController.swift
//  TWNewsReader
//
//  Created by David_Lam on 13/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import UIKit

protocol MainViewControllerType: class {
    func setupView(state: MainViewState)
}

enum Text: String {
    case welcomMessage = "Hello dear new user, looks like there is no news article :)"
    case noInternetTextForNewUser = "Looks like this is the first time you use the app and there is no internet"
    case loadingText = "Loading...please wait for the good stuff"
    case navigationTitle_DataFromNetwork = "Fetched %d posts from internetz"
    case navigationTitle_DataFromLocal = "Fetched %d cached posts"
    case stillLoadingText = "More to come! Hang in tight!!"
    case completedMessage = "Congratulations, we have fetched all ;)"
    case apiFailedAndFetchedFromLocal = "Oops, something went wrong, showing data from local storage. Please retry later."
}

class MainViewController: UIViewController {

    @IBOutlet weak var stateFeedbackLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingStatusUpdateBanner: UIView!
    @IBOutlet weak var loadingStatusLabel: UILabel!

    private var items: Items = []
    var viewModel: MainViewModelType!

    @IBAction func retryButtonTapped(sender: Any) {
        viewModel.retryFetch()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel == nil {
            viewModel = MainViewModel(view: self)
        }
        viewModel.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
}

extension MainViewController: MainViewControllerType {
    func setupView(state: MainViewState) {
        if Thread.isMainThread {
            setupViewOnMainThread(state: state)
        } else {
            DispatchQueue.main.async {
                self.setupViewOnMainThread(state: state)
            }
        }
    }

    private func setupViewOnMainThread(state: MainViewState) {
        precondition(Thread.isMainThread)
        navigationItem.leftBarButtonItem?.isEnabled = false
        loadingStatusUpdateBanner.isHidden = true
        switch state {
        case .displayWelcomeMessage:
            tableView.isHidden = true
            stateFeedbackLabel.text = Text.welcomMessage.rawValue
            navigationItem.leftBarButtonItem?.isEnabled = true

        case .emptyState:
            tableView.isHidden = true
            stateFeedbackLabel.text = Text.noInternetTextForNewUser.rawValue
            navigationItem.leftBarButtonItem?.isEnabled = true

        case .loading:
            tableView.isHidden = true
            stateFeedbackLabel.text = Text.loadingText.rawValue

        case .loadedFromNetwork(let payload, let hasMoreItems):
            tableView.isHidden = false
            items.append(contentsOf: payload)
            tableView.reloadData()

            title = String(format: Text.navigationTitle_DataFromNetwork.rawValue,
                           items.count)

            loadingStatusUpdateBanner.isHidden = false
            if hasMoreItems {
                loadingStatusLabel.text = Text.stillLoadingText.rawValue
            } else {
                loadingStatusLabel.text = Text.completedMessage.rawValue
                animateHideLoadingStatusBanner()
            }

        case .loadedFromLocalStorage(let payload):
            tableView.isHidden = false
            items = payload
            tableView.reloadData()

            title = String(format: Text.navigationTitle_DataFromLocal.rawValue,
                           items.count)
            navigationItem.leftBarButtonItem?.isEnabled = true

            loadingStatusUpdateBanner.isHidden = false
            loadingStatusLabel.text = Text.apiFailedAndFetchedFromLocal.rawValue
        }
    }

    private func animateHideLoadingStatusBanner() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            UIView.animate(withDuration: 1.0) {
                self.loadingStatusUpdateBanner.isHidden = true
            }
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            fatalError("cell is not configured")
        }
        let post = items[indexPath.row]
        cell.textLabel?.text = post.title
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: introduce coordinator if time permits
        let person = items[indexPath.row]
        let viewController = UIViewController.make(viewController: DetailViewController.self)
        let detailViewModel = DetailViewModel(view: viewController,
                                              item: person)
        viewController.viewModel = detailViewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
}
