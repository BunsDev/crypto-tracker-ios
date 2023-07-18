//
//  UserPortfolio.swift
//  Crypto
//
//  Created by CJ on 7/13/23.
//
//

import Foundation
import SwiftData

@Model final class UserPortfolio {
    @Attribute(.unique, originalName: "user_id") var userID: String
    @Attribute(originalName: "date_of_creation") var dateofCreation: Date
    @Attribute(originalName: "cash_balance") var cashBalance: Double
    @Attribute(originalName: "initial_value") var initialValue: Double
    
    @Relationship(.cascade, originalName: "favorite_coins")
    var favoriteCoins: [UserFavoriteCoin]?
    @Relationship(.cascade, originalName: "coin_holdings")
    var coinHoldings: [UserCoinHolding]?
    
    init(userID: String, dateofCreation: Date = Date.now, cashBalance: Double = 1_000_000, initialValue: Double = 1_000_000, favortieCoins: [UserFavoriteCoin]? = nil, coinHoldings: [UserCoinHolding]? = nil) {
        self.userID = userID
        self.dateofCreation = dateofCreation
        self.cashBalance = cashBalance
        self.initialValue = initialValue
        self.favoriteCoins = favoriteCoins
        self.coinHoldings = coinHoldings
    }
}
