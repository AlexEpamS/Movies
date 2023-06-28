//
//  MovieDetailsViewModel.swift
//  Movies
//
//  Created by Oleksandr Strelkov on 2023-06-19.
//

import Foundation
import Fetch
import UIKit

class MovieDetailsViewModel {
    weak var view: MovieDetailsViewInterface?

    var movieName: String {
        movieDetails?.name ?? movieShortDetails.name
    }
    
    var image: UIImage?
    
    var movieSynopsis: String {
        movieDetails?.synopsis ?? ""
    }
    
    var movieMeta: String {
        movieDetails?.meta ?? ""
    }
    
    var movieRating: String {
        movieDetails?.rating ?? ""
    }
    
    var moviePrice: String {
        if let price = movieDetails?.price {
            return String(price)
        } else {
            return ""
        }
    }
    
    private let movieShortDetails: MovieShortDetails
    private var movieDetails: MovieDetails?
    private let session = Session()

    init(movieShortDetails: MovieShortDetails) {
        self.movieShortDetails = movieShortDetails
    }
    
    func viewDidLoad() {
        view?.reloadPage()
        loadData()
    }

    // MARK: -

    private func loadData() {
        let request = MovieDetailsRequest(movieId: movieShortDetails.movieId)
        
        session.perform(request) { (result: FetchResult<MovieDetails>) in
            switch result {
            case .success(let response):
                self.movieDetails = response
                self.view?.reloadPage()
                
                if let url = URL(string: response.imageUrlString) {
                    let task = URLSession.shared.dataTask(with: url) { data, response, error in
                        guard let data = data, error == nil else {
                            return
                        }
                        DispatchQueue.main.async {
                            self.image = UIImage(data: data)
                            self.view?.reloadPage()
                        }
                    }
                    task.resume()
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}


