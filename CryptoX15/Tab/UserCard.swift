//
//  UserCard.swift
//  CryptoX15
//
//  Created by CJ on 7/20/23.
//

import SwiftUI

struct UserCard: View {
    @Environment(PortfolioManager.self) var portfolioManager
    @Environment(CoinManager.self) var coinManager
    
    var body: some View {
        RoundedOutlineContainer {
            let portfolioInfo = UserPortfolio.AdditionalInfo(userPortfolio: portfolioManager.userPortfolio, coinDictionary: coinManager.coinDic)
            VStack(alignment: .leading, spacing: 5) {
                Text("Net Account Value")
                Text(portfolioInfo.accountNetValue.asCurrencyWithDecimals())
                    .sectionHeader()
                    .padding(.bottom)
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Open P&L")
                        Text("\(portfolioInfo.openPLValue.asCurrencyWithPrefix()) \(portfolioInfo.openPLPercent.asPercentWithPrefix())")
                            .foregroundStyle(portfolioInfo.openPLValue.gainLossColor)
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 5) {
                        Text("Day's P&L")
                        Text("\(portfolioInfo.dayPLValue.asCurrencyWithPrefix()) \(portfolioInfo.dayPLPercent.asPercentWithPrefix())")
                            .foregroundStyle(portfolioInfo.dayPLValue.gainLossColor)
                            .font(.caption)
                    }
                }
                .font(.system(size: 15))
                .padding(.bottom, 25)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Market Value")
                        Text("\(portfolioInfo.totalHoldingValue.asCurrencyWithDecimals())")
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Cash Balance")
                        Text("\(portfolioManager.userPortfolio.cashBalance.asCurrencyWithDecimals())")
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Risk Level")
                        Text(portfolioManager.userPortfolio.riskLevel.text)
                            .foregroundStyle(portfolioManager.userPortfolio.riskLevel.color)
                    }
                }
                .font(.system(size: 12))
            }
        }
    }
}
