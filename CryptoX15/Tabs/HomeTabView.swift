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
    @Environment(CoinManager.self) var manager
    @Environment(\.modelContext) var context
    @State private var selection: Tab = .market
    @Query private var users: [UserPortfolio]
    
    init(service: FirebaseAuthService) {
        if let id = service.user?.email {
            print("HomeTabView current id: \(id)")
            _users = Query(filter: #Predicate { $0.userID == id })
        }
    }
    /// An enumeration representing the available tabs in the tab view.
    enum Tab: String {
//        case home
        case watchlist
        case market
        case portfolio
        
        var title: String {
            rawValue.capitalized
        }
    }
    
    var body: some View {
        TabView(selection: $selection) {
//            HomeView()
//                .tabItem {
//                    Label("Home", systemImage: "house")
//                }
//                .tag(Tab.home)
            WatchlistView(portfolio: users.first ?? UserPortfolio(userID: ""))
                .tabItem {
                    Label("Watchlist", systemImage: "heart")
                }
                .tag(Tab.watchlist)
            MarketView()
                .tabItem {
                    Label("Market", systemImage: "network")
                }
                .tag(Tab.market)
            PortfolioView(portfolio: users.first ?? UserPortfolio(userID: ""))
                .tabItem {
                    Label("Portfolio", systemImage: "person")
                }
                .tag(Tab.portfolio)
        }
        .task {
            await manager.fetchCoinData()
        }
        .onAppear {
//            print(context.container.schema)
//            do {
//                try context.delete(model: UserPortfolio.self)
//                try context.delete(model: UserFavoriteCoin.self)
//                try context.delete(model: UserCoinHolding.self)
//            } catch {
//                print(error.localizedDescription)
//            }
            print("HomeTab onAppear")
            for user in users {
                print(user.userID)
            }
        }
    }
}
