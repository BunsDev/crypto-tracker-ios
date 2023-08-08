//
//  FavoriteCoin.swift
//  Crypto
//
//  Created by CJ on 7/13/23.
//
//

import Foundation
import SwiftData

/// Represents a favorite coin associated with a user.
@Model final class FavoriteCoin {
    @Attribute(.unique) var name: String
    var timestamp: Date
    @Attribute(originalName: "is_favorite") var isFavorite: Bool
    
    @Relationship(originalName: "user_id", inverse: \UserProfile.favoriteCoins)
    var userID: String
    
    init(name: String = "", timestamp: Date = .now, isFavorite: Bool = false, userID: String = "") {
        self.name = name
        self.timestamp = timestamp
        self.isFavorite = isFavorite
        self.userID = userID
    }
}
