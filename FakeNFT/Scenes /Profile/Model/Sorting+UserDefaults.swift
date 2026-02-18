//
//  Sorting.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 28.01.2026.
//

import Foundation

enum Sorting: String, CaseIterable {
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

extension Sorting {
    private static let storageKey = "myNFTsSorting"
    static let defaultSorting: Sorting = .name
    
    static func load() -> Sorting {
        guard let rawValue = UserDefaults.standard.string(forKey: Self.storageKey),
              let sorting = Sorting(rawValue: rawValue)else {
            return defaultSorting
        }
        return sorting
    }
    
    static func save(_ sorting: Sorting) {
        UserDefaults.standard.set(sorting.rawValue, forKey: storageKey)
    }

    static func reset() {
        UserDefaults.standard.removeObject(forKey: storageKey)
    }
}
