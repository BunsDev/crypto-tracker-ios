//
//  UserPortfolio.swift
//  CryptoX15
//
//  Created by CJ on 7/20/23.
//

import Foundation
import FirebaseFirestoreSwift
import SwiftUI

/// Represents a user portfolio containing holdings and financial information.
struct UserPortfolio: Codable, Identifiable {
    @DocumentID var id: String?
    var dateOfCreation: Date = .now
    var email: String = ""
    var holdings: [Holding]? = []
    var accountInitialValue: Double = 0
    var cashBalance: Double = 0
    
    var riskLevel: RiskLevel {
        switch cashBalance {
        case ..<0: return .risk
        case 0: return .neutral
        default: return .safe
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case dateOfCreation = "date_of_creation"
        case email
        case holdings
        case accountInitialValue = "account_initial_value"
        case cashBalance = "cash_balance"
    }
    
    /// Possible risk levels for the portfolio.
    enum RiskLevel: String, Identifiable {
        case risk
        case safe
        case neutral
        
        var id: String {
            text
        }
        
        var text: String {
            rawValue.capitalized
        }
        
        var color: Color {
            switch self {
            case .risk: return .red
            case .safe: return .green
            case .neutral: return .yellow
            }
        }
    }
    
    /// Represents additional information related to a user's investment portfolio.
    struct AdditionalInfo {
        var userPortfolio: UserPortfolio = UserPortfolio()
        var coinDictionary: [String: Coin] = [:]
        
        var totalHoldingValue: Double {
            userPortfolio.holdings?.reduce(0) { $0 + ((coinDictionary[$1.name]?.currentPriceDouble ?? 0) * $1.quantity) } ?? 0
        }
        
        var accountNetValue: Double {
            totalHoldingValue + userPortfolio.cashBalance
        }
        
        var openPLValue: Double {
            accountNetValue - userPortfolio.accountInitialValue
        }
        
        var openPLPercent: Double {
            openPLValue / userPortfolio.accountInitialValue * 100
        }
        
        var dayPLValue: Double {
            userPortfolio.holdings?.reduce(0) { $0 + (coinDictionary[$1.name]?.priceChange24HDouble ?? 0) * $1.quantity } ?? 0
        }
        
        var dayPLPercent: Double {
            dayPLValue / (accountNetValue - dayPLValue) * 100
        }
    }
}
