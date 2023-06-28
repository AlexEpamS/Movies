//
//  MoviesViewModel.swift
//  Movies
//
//  Created by Oleksandr Strelkov on 2023-06-19.
//

import Foundation
import Fetch

class MoviesViewModel {

    weak var view: MoviesViewInterface?
    var movies = [MovieShortDetails]()
    
    var sortOption = SortOption(attribute: .name, order: .ascending) {
        didSet {
            updateMovies()
        }
    }
    
    var filter: Filter? = nil {
        didSet {
            updateMovies()
        }
    }

    private let session = Session()
    private var allMovies = [MovieShortDetails]() {
        didSet {
            updateMovies()
        }
    }

    func viewDidLoad() {
        loadData()
    }
    
    func filteredAndSortedMovies(_ movies: [MovieShortDetails]) -> [MovieShortDetails] {
        let result: [MovieShortDetails]
        var filteredMovies: [MovieShortDetails]
        
        if let filter {
            filteredMovies = MovieShortDetails.filterMovies(movies, withFilter: filter)
        } else {
            filteredMovies = movies
        }

        switch sortOption.attribute {
        case .name:
            result = filteredMovies.sorted(by: { item1, item2 in
                getComparisonOperation(order: sortOption.order)(item1.name, item2.name)
            })
        case .price:
            result = filteredMovies.sorted(by: { item1, item2 in
                getComparisonOperation(order: sortOption.order)(item1.price, item2.price)
            })
        }
        return result
    }
    
    func sortingDone(_ sortOption: SortOption) {
        self.sortOption = sortOption
    }
    
    func filterDone(_ filter: Filter?) {
        self.filter = filter
    }
    
    func calculateFilterResults(_ filter: Filter?) -> Int {
        let filteredMovies = moviesWithFilter(filter)
        return filteredMovies.count
    }
    
    // MARK: -

    private func moviesWithFilter(_ filter: Filter?) -> [MovieShortDetails] {
        let result: [MovieShortDetails]

        if let filter {
            result = MovieShortDetails.filterMovies(allMovies, withFilter: filter)
        } else {
            result = allMovies
        }
        return result
    }
    
    private func loadData() {
        let request = MoviesRequest()
        
        session.perform(request) { (result: FetchResult<MoviesResponse>) in
            switch result {
            case .success(let response):
                self.allMovies = response.movies
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    private func getComparisonOperation<T: Comparable>(order: SortOrder) -> ((T, T) -> Bool) {
        if order == .ascending {
            return { $0 < $1 }
        } else {
            return { $0 > $1 }
        }
    }
    
    private func updateMovies() {
        movies = filteredAndSortedMovies(allMovies)
        view?.reloadMoviesList()
    }
}
