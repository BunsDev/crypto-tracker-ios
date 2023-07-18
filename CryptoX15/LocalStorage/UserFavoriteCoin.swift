//
//  UserFavoriteCoin.swift
//  Crypto
//
//  Created by CJ on 7/13/23.
//
//

import Foundation
import SwiftData

@Model final class UserFavoriteCoin {
    @Attribute(.unique) var name: String
    var timestamp: Date
    @Attribute(originalName: "is_favorite") var isFavorite: Bool
    
    @Relationship(originalName: "user_id", inverse: \UserPortfolio.favoriteCoins)
    var userID: String
    
    init(name: String = "", timestamp: Date = .now, isFavorite: Bool = false, userID: String = "") {
        self.name = name
        self.timestamp = timestamp
        self.isFavorite = isFavorite
        self.userID = userID
    }
}
