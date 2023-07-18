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
    @State private var coins: [UserFavoriteCoin] = []
    
    init(portfolio: UserPortfolio) {
        if let value = portfolio.favoriteCoins {
            _coins = State(wrappedValue: value)
        }
    }
    
    var watchlistCoins: [Coin] {
        let coins = coins.compactMap { manager.coinDic[$0.name] }
        return CoinListOperation.update(coins, by: sortOption, in: isDescending, by: searchText)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                CoinScroll(coins: manager.top10MovingCoins)
                    .padding(.bottom, 12)
                SortSelection(selectedOption: $sortOption, isDescending: $isDescending)
                CoinList(coins: watchlistCoins)
            }
            .navigationTitle("Watchlist")
        }
        .searchable(text: $searchText, prompt: Text("Search by Name/Symbol"))
    }
}
