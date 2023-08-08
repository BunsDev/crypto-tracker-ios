//
//  HomeTabView.swift
//  Crypto
//
//  Created by CJ on 7/13/23.
//

import SwiftUI
import SwiftData

/// A view representing a tab view with three tabs: "Home," "Market," and "Portfolio."
struct HomeTabView: View {
    @Environment(CoinManager.self) var coinManager
    @Environment(PortfolioManager.self) var portfolioManager
    @Environment(FirebaseAuthService.self) var authService
    @State private var selection: Tab = .market
    @Query private var users: [UserProfile]
    @Query private var testUsers: [UserProfile]
    @Environment(\.modelContext) var context
    
    var user: UserProfile {
        users.first ?? UserProfile(email: "")
    }
    
    init(service: FirebaseAuthService) {
        if let email = service.user?.email {
            _users = Query(filter: #Predicate { $0.email == email })
        }
    }
    
    /// An enumeration representing the available tabs in the tab view.
    enum Tab: String {
        case watchlist
        case market
        case portfolio
        
        var title: String {
            rawValue.capitalized
        }
    }
    
    var body: some View {
        TabView(selection: $selection) {
            WatchlistView(user: user)
                .tabItem {
                    Label("Watchlist", systemImage: "heart")
                }
                .tag(Tab.watchlist)
            MarketView(user: user)
                .tabItem {
                    Label("Market", systemImage: "network")
                }
                .tag(Tab.market)
            PortfolioView(user: user)
                .tabItem {
                    Label("Portfolio", systemImage: "person")
                }
                .tag(Tab.portfolio)
        }
        .task {
            await coinManager.fetchCoinData()
            await portfolioManager.fetchPortfolio(documentID: authService.user?.uid ?? "")
        }
        .onAppear {
            print("all users:")
            for user in testUsers {
                print(user.email)
            }
        }
    }
}
