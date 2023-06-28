//
//  SortOptions.swift
//  Movies
//
//  Created by Oleksandr Strelkov on 2023-06-20.
//

import Foundation

enum SortAttribute: Int, CaseIterable {
    case name
    case price
    
    var title: String {
        switch self {
        case .name:
            return "Name"
        case .price:
            return "Price"
        }
    }
}

enum SortOrder: Int, CaseIterable {
    case ascending
    case descending
    
    var title: String {
        switch self {
        case .ascending:
            return "Ascending"
        case .descending:
            return "Descending"
        }
    }
}

struct SortOption {
    let attribute: SortAttribute
    let order: SortOrder
}
