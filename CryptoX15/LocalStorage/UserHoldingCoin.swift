//
//  UserHoldingCoin.swift
//  Crypto
//
//  Created by CJ on 7/13/23.
//

import Foundation
import SwiftData

@Model final class UserCoinHolding {
    @Attribute(.unique) var name: String
    var timestamp: Date
    var quantity: Double
    @Attribute(originalName: "buy_price") var buyPrice: Double
    
    @Relationship(originalName: "user_id", inverse: \UserPortfolio.coinHoldings)
    var userID: String
    
    init(name: String = "", timestamp: Date = .now, quantity: Double = 0, buyPrice: Double = 0, userID: String = "") {
        self.name = name
        self.timestamp = timestamp
        self.quantity = quantity
        self.buyPrice = buyPrice
        self.userID = userID
    }
}
