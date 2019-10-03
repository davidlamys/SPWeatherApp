//
//  MainViewController.swift
//  SPWeatherApp
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
    case noResult = "No results found for: %@"
    case loadingText = "Loading...please wait for the good stuff"
    case navigationTitle_DataFromNetwork = "Found %d cities from internetz"
    case navigationTitle_recentlyViewed = "Recently viewed %d cities"
    case completedMessage = "Congratulations, we have found some cities ;)"
    case welcomeBanner = "Welcome new user, search for city to begin"
    case searchHelperPrompt = "Type 3 or more characters to begin search"
    case searchFailed = "Oops something went wrong"
}

class MainViewController: UIViewController {

    @IBOutlet weak var stateFeedbackLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingStatusUpdateBanner: UIView!
    @IBOutlet weak var loadingStatusLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var items: Items = []
    var viewPresenter: MainViewPresenterType!
    
    var throttler: ThrottlerType = Throttler(minimumDelay: 0.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        if viewPresenter == nil {
            viewPresenter = MainViewPresenter(view: self)
        }
        setupTableView()
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search city"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        viewPresenter.loadRecentlyViewedCity()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.accessibilityLabel = "MainTable"
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
        loadingStatusUpdateBanner.isHidden = true
        activityIndicatorView.stopAnimating()
        
        switch state {
        case .noResultFound(let query):
            tableView.isHidden = true
            let feedbackText = String(format: Text.noResult.rawValue, query)
            stateFeedbackLabel.text = feedbackText

        case .loading:
            tableView.isHidden = true
            stateFeedbackLabel.text = Text.loadingText.rawValue
            activityIndicatorView.startAnimating()

        case .loadedFromNetwork(let payload):
            tableView.isHidden = false
            items = payload
            tableView.reloadData()

            title = String(format: Text.navigationTitle_DataFromNetwork.rawValue,
                           items.count)

            loadingStatusUpdateBanner.isHidden = false
            loadingStatusLabel.text = Text.completedMessage.rawValue
            animateHideLoadingStatusBanner()
                        

        case .loadRecentlyViewedCity(let payload):
            tableView.isHidden = false
            items = payload
            tableView.reloadData()

            if payload.isEmpty {
                title = nil
            } else {
                title = String(format: Text.navigationTitle_recentlyViewed.rawValue,
                items.count)
            }
            loadingStatusUpdateBanner.isHidden = !payload.isEmpty
            loadingStatusLabel.text = Text.welcomeBanner.rawValue
            
        case .willBeginSearch:
            tableView.isHidden = true
            stateFeedbackLabel.text = Text.searchHelperPrompt.rawValue
            break
            
        case .searchFailed:
            tableView.isHidden = true
            stateFeedbackLabel.text = Text.searchFailed.rawValue
            break
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
        let location = items[indexPath.row]
        cell.textLabel?.text = location.cityName
        cell.detailTextLabel?.text = location.cityCountry
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: introduce coordinator if time permits
        let location = items[indexPath.row]
        viewPresenter.userWillViewItem(location)
        
        let viewController = UIViewController.make(viewController: DetailViewController.self)
        let detailViewPresenter = DetailViewPresenter(item: location,
                                                      view: viewController)
        viewController.viewPresenter = detailViewPresenter
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension MainViewController: UISearchResultsUpdating {
  // MARK: - UISearchResultsUpdating Delegate
  func updateSearchResults(for searchController: UISearchController) {
    guard
        let searchText = searchController.searchBar.text,
        searchText.count > 0
    else {
        return
    }
    if searchText.count >= 3 {
        throttler.throttle { [weak self] in
            self?.viewPresenter.fetchItems(query: searchText)
        }
    } else {
        viewPresenter.searchWillBegin()
    }
  }
}

extension MainViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        viewPresenter.searchWillBegin()
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        viewPresenter.loadRecentlyViewedCity()
    }
}
