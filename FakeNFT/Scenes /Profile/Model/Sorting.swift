//
//  Sorting.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 28.01.2026.
//

import Foundation

enum Sorting {
    case price
    case rating
    case name
    
    var title: String {
        switch self {
        case .price: return NSLocalizedString("ProfileSortPrice", comment: "sort")
        case .rating: return NSLocalizedString("ProfileSortRating", comment: "sort")
        case .name: return NSLocalizedString("ProfileSortName", comment: "sort")
        }
    }
}
