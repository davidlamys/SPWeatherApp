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
    }
}

extension MainViewController: MainViewControllerType {
    func setupView(state: MainViewState) {
        switch state {
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

