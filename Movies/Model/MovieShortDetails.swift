//
//  MovieShortDetails.swift
//  Movies
//
//  Created by Oleksandr Strelkov on 2023-06-15.
//

import Foundation

typealias PriceType = Int

struct MovieShortDetails: Codable {
    let movieId: String
    let name: String
    let price: PriceType
    
    enum CodingKeys: String, CodingKey {
        case movieId = "id"
        case name
        case price
    }
}

extension MovieShortDetails {
    static func filterMovies(_ movies: [MovieShortDetails], withFilter filter: Filter) -> [MovieShortDetails] {
        let minPrice = filter.minPrice ?? PriceType.min
        let maxPrice = filter.maxPrice ?? PriceType.max
        
        guard minPrice <= maxPrice else {
            return []
        }
        
        let result = movies.filter { movie in
            movie.price >= minPrice && movie.price <= maxPrice
        }
        return result
    }
}
