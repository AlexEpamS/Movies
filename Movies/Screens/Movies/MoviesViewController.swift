//
//  MoviesViewController.swift
//  Movies
//
//  Created by Oleksandr Strelkov on 2023-06-15.
//

import UIKit
import Fetch

protocol MoviesViewInterface: AnyObject {
    func reloadMoviesList()
}

class MoviesViewController: UITableViewController {
    
    let viewModel = MoviesViewModel()
    var moviesCount: Int {
        viewModel.movies.count
    }

    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
        
        let sortAction = UIAction(title: "Sort", handler: actionHandlerWithHandler(presentSortOptions))
        let filterAction = UIAction(title: "Filter", handler: actionHandlerWithHandler(presentFilterOptions))
        let menu = UIMenu(title: "", children: [ sortAction, filterAction ])
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: menu)
    }
        
    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "CellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        let movie = movieForIndexPath(indexPath)
        cell?.textLabel?.text = movie.name
        cell?.detailTextLabel?.text = "Price: \(movie.price)"
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movieForIndexPath(indexPath)
        let movieDetailsViewController = MovieDetailsViewController(movieShortDetails: movie)
        navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
    
    // MARK: -

    private func movieForIndexPath(_ indexPath: IndexPath) -> MovieShortDetails {
        viewModel.movies[indexPath.row]
    }

    private func presentSortOptions() {
        let viewController = SortOptionsViewController(
            sortOption: viewModel.sortOption,
            doneHandler: viewModel.sortingDone(_:)
        )
        let navigationViewController = UINavigationController(rootViewController: viewController)
        present(navigationViewController, animated: true)
    }
    
    private func presentFilterOptions() {
        let viewController = FilterViewController(
            filter: viewModel.filter,
            calculateFilterResultsClosure: viewModel.calculateFilterResults(_:),
            doneHandler: viewModel.filterDone(_:)
        )
        let navigationViewController = UINavigationController(rootViewController: viewController)
        present(navigationViewController, animated: true)
    }
    
    private func actionHandlerWithHandler(_ handler: @escaping () -> ()) -> UIActionHandler {
        return { _ in handler() }
    }
}

extension MoviesViewController: MoviesViewInterface {
    func reloadMoviesList() {
        tableView.reloadData()
    }
}

