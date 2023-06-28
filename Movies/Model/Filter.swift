//
//  Filter.swift
//  Movies
//
//  Created by Oleksandr Strelkov on 2023-06-21.
//

import Foundation

struct Filter {
    let minPrice: PriceType?
    let maxPrice: PriceType?
    
    init(minPrice: PriceType, maxPrice: PriceType) {
        self.minPrice = minPrice
        self.maxPrice = maxPrice
    }
    
    init(minPrice: PriceType) {
        self.minPrice = minPrice
        self.maxPrice = nil
    }
    
    init(maxPrice: PriceType) {
        self.minPrice = nil
        self.maxPrice = maxPrice
    }
}
