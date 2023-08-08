//
//  UserFavorites.swift
//  Crypto
//
//  Created by CJ on 7/13/23.
//
//

import Foundation
import SwiftData

/// Represents a user basic profile information and favorite coins.
@Model final class UserProfile {
    @Attribute(.unique) var email: String
    @Attribute(originalName: "date_of_creation") var dateofCreation: Date
    
    @Relationship(.cascade, originalName: "favorite_coins")
    var favoriteCoins: [FavoriteCoin]?
    
    init(email: String, dateofCreation: Date = Date.now, favortieCoins: [FavoriteCoin]? = nil) {
        self.email = email
        self.dateofCreation = dateofCreation
        self.favoriteCoins = favoriteCoins
    }
}
