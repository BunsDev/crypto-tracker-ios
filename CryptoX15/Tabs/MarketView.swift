//
//  MarketView.swift
//  Crypto
//
//  Created by CJ on 7/13/23.
//

import SwiftUI

struct MarketView: View {
    @Environment(CoinManager.self) var manager
    @State private var menuItem: CoinMenuItem = .cryptos
    @State private var sortOption: SortOption = .marketCapRank
    @State private var isDescending = true
    @State private var searchText = ""
    @State private var refreshableTask: Task<(), Never>?
    @Bindable var portfolio: UserPortfolio
    
    var updatedCoins: [Coin] {
        CoinListOperation.update(manager.coins, in: menuItem, by: sortOption, in: isDescending, by: searchText)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                MenuBar(selectedItem: $menuItem)
                SortSelection(selectedOption: $sortOption, isDescending: $isDescending)
                CoinList(coins: updatedCoins, portfolio: portfolio)
            }
            .navigationTitle("Market")
        }
        .searchable(text: $searchText, prompt: Text("Search by Name/Symbol"))
        .refreshable {
            startRefreshableTask()
        }
        .onDisappear {
            refreshableTask?.cancel()
            refreshableTask = nil
        }
    }
    
    private func startRefreshableTask() {
        refreshableTask = Task {
            await manager.fetchCoinData()
            refreshableTask?.cancel()
            refreshableTask = nil
        }
    }
}
