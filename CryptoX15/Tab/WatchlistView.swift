//
//  WatchlistView.swift
//  Crypto
//
//  Created by CJ on 7/13/23.
//

import SwiftUI
import SwiftData

/// A view that displays a searchable market view with a menu bar and a list of coins.
struct WatchlistView: View {
    @Environment(CoinManager.self) var manager
    @State private var sortOption: SortOption = .marketCapRank
    @State private var isDescending = true
    @State private var searchText = ""
    @Bindable var user: UserProfile
    
    var watchlistCoins: [Coin] {
        let coins = (user.favoriteCoins?.filter({ $0.isFavorite }) ?? []).compactMap { manager.coinDic[$0.name] }
        return CoinListOperation.update(coins, option: sortOption, isDescending: isDescending, text: searchText)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                CoinScroll(coins: manager.top10MovingCoins, user: user)
                    .padding(.bottom, 12)
                SortSelection(selectedOption: $sortOption, isDescending: $isDescending)
                CoinList(coins: watchlistCoins, user: user)
            }
            .navigationTitle("Watchlist")
        }
        .searchable(text: $searchText, prompt: Text("Search by Name/Symbol"))
    }
}
