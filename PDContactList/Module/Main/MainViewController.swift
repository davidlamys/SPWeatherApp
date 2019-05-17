//
//  MainViewController.swift
//  PDContactList
//
//  Created by David_Lam on 13/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import UIKit

protocol MainViewControllerType: class {
    func setupView(state: MainViewState)
}

enum Text: String {
    case welcomMessage = "Hello dear new user, please add/import new contacts on website :)"
    case placeholderText = "Looks like this is the first time you use the app and there is no internet"
    case loadingText = "Loading...please wait for the good stuff"
}

class MainViewController: UIViewController {

    @IBOutlet weak var stateFeedbackLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var persons: [Person] = []
    var viewModel: MainViewModelType!
    
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
        switch state {
        case .displayWelcomeMessage:
            tableView.isHidden = true
            stateFeedbackLabel.text = Text.welcomMessage.rawValue
        case .emptyState:
            tableView.isHidden = true
            stateFeedbackLabel.text = Text.placeholderText.rawValue
        case .loading:
            tableView.isHidden = true
            stateFeedbackLabel.text = Text.loadingText.rawValue
        case .loaded(let payload):
            tableView.isHidden = false
            persons = payload
            tableView.reloadData()
            title = "\(persons.count) people in list"
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            fatalError("cell is not configured")
        }
        let person = persons[indexPath.row]
        cell.textLabel?.text = person.name
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: introduce coordinator if time permits
        let person = persons[indexPath.row]
        let viewController = UIViewController.make(viewController: DetailViewController.self)
        let detailViewModel = DetailViewModel(view: viewController,
                                              person: person)
        viewController.viewModel = detailViewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
}
