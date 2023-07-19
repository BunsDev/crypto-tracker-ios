//
//  WatchlistView.swift
//  Crypto
//
//  Created by CJ on 7/13/23.
//

import SwiftUI
import SwiftData

struct WatchlistView: View {
    @Environment(CoinManager.self) var manager
    @State private var sortOption: SortOption = .marketCapRank
    @State private var isDescending = true
    @State private var searchText = ""
    @Bindable var portfolio: UserPortfolio
    
    var watchlistCoins: [Coin] {
        let coins = (portfolio.favoriteCoins?.filter({ $0.isFavorite }) ?? []).compactMap { manager.coinDic[$0.name] }
        return CoinListOperation.update(coins, by: sortOption, in: isDescending, by: searchText)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                CoinScroll(coins: manager.top10MovingCoins, portfolio: portfolio)
                    .padding(.bottom, 12)
                SortSelection(selectedOption: $sortOption, isDescending: $isDescending)
                CoinList(coins: watchlistCoins, portfolio: portfolio)
            }
            .navigationTitle("Watchlist")
        }
        .searchable(text: $searchText, prompt: Text("Search by Name/Symbol"))
    }
}
