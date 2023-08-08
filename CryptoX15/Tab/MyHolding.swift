//
//  MyHolding.swift
//  CryptoX15
//
//  Created by CJ on 7/20/23.
//

import SwiftUI

struct MyHolding: View {
    @Environment(PortfolioManager.self) var portfolioManager
    @Environment(CoinManager.self) var coinManager
    @Bindable var user: UserProfile
    
    private var portfolio: UserPortfolio {
        portfolioManager.userPortfolio
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("My Holdings: (\(portfolio.holdings?.count ?? 0))")
                .sectionHeader()
            Divider()
            scrollableSection
                .foregroundColor(.secondary)
                .font(.caption)
        }
    }

    private let columns = [
        GridItem(.fixed(88)),
        GridItem(.fixed(88)),
        GridItem(.fixed(88)),
        GridItem(.fixed(64)),
    ]
    private let rows: [GridItem] = Array(repeating: .init(.fixed(32)), count: 4)
    
    private var scrollableSection: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem()], pinnedViews: .sectionHeaders) {
                Section {
                    VStack {
                        LazyVGrid(columns: columns, alignment: .trailing) {
                            Text("Mkt Value/Qty")
                            Text("Open P&L")
                            Text("Last/Avg Price")
                            Text("Day P&L")
                        }
                        ForEach(portfolio.holdings ?? []) { holding in
                            if let coin = coinManager.coinDic[holding.name] {
                                let holdingInfo = Holding.AdditionalInfo(coin: coin, holding: holding)
                                NavigationLink {
                                    CoinDetailView(coin: coin, user: user)
                                } label: {
                                    LazyVGrid(columns: columns, alignment: .trailing) {
                                        Text(holdingInfo.marketValue.asCurrencyWithDecimals())
                                        Text(holdingInfo.openPLValue.asCurrencyWithPrefix())
                                            .foregroundColor(holdingInfo.openPLValue.gainLossColor)
                                        Text(coin.currentPriceString)
                                        Text(coin.priceChange24HString)
                                            .foregroundColor(coin.priceChange24HDouble.gainLossColor)
                                        Text(String(format: "%.2f", holding.quantity))
                                        Text(holdingInfo.openPLPercent.asPercentWithPrefix())
                                            .foregroundColor(holdingInfo.openPLValue.gainLossColor)
                                        Text(holding.buyPrice.asCurrencyWithDecimals())
                                        Text(coin.priceChangePercentage24HString)
                                            .foregroundColor(coin.priceChange24HDouble.gainLossColor)
                                    }
                                    .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                } header: {
                    LazyHGrid(rows: [GridItem()]) {
                        LazyVGrid(columns: [GridItem(.fixed(72))], alignment: .leading) {
                            Text("Symbol")
                            ForEach(portfolio.holdings ?? []) { holding in
                                LazyVGrid(columns: [GridItem(.fixed(72))], alignment: .leading) {
                                    Text(holding.name.uppercased())
                                    Text(holding.symbol)
                                }
                            }
                        }
                    }
                    .padding(.trailing, 10)
                    .background()
                }
            }
        }
        .scrollIndicators(.hidden, axes: .horizontal)
    }
}
