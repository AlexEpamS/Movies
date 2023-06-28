//
//  MovieDetails.swift
//  Movies
//
//  Created by Oleksandr Strelkov on 2023-06-19.
//

import Foundation

struct MovieDetails: Codable {
    let imageUrlString: String
    let name: String
    let meta: String
    let price: PriceType
    let rating: String
    let synopsis: String
    
    enum CodingKeys: String, CodingKey {
        case imageUrlString = "image"
        case name
        case meta
        case price
        case rating
        case synopsis
    }
}
