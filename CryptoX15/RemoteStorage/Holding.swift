//
//  Holding.swift
//  CryptoX15
//
//  Created by CJ on 7/20/23.
//

import Foundation

/// Represents a holding within a user's portfolio.
struct Holding: Codable, Identifiable {
    var id: String { name }
    var name: String
    var dateOfCreation: Date = .now
    var symbol: String
    var quantity: Double
    var buyPrice: Double
    
    enum CodingKeys: String, CodingKey {
        case name
        case dateOfCreation = "date_of_creation"
        case symbol
        case quantity
        case buyPrice = "buy_price"
    }
    
    /// Represents additional information related to a specific coin holding in a user's investment portfolio.
    struct AdditionalInfo {
        var coin: Coin
        var holding: Holding

        var currentPrice: Double {
            coin.currentPriceDouble
        }
        
        var priceChange24H: Double {
            coin.currentPriceDouble
        }
        
        var marketValue: Double {
            currentPrice * holding.quantity
        }
        
        var openPLValue: Double {
            (currentPrice - holding.buyPrice) * holding.quantity
        }
        
        var openPLPercent: Double {
            (currentPrice - holding.buyPrice) * 100 / holding.buyPrice
        }
        
        var dayPLValue: Double {
            priceChange24H * holding.quantity
        }
        
        var dayPLPercent: Double {
            coin.priceChangePercentage24HDouble
        }
    }
}
