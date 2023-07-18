//
//  PortfolioView.swift
//  Crypto
//
//  Created by CJ on 7/13/23.
//

import SwiftUI
import SwiftData

struct PortfolioView: View {
    @State private var portfolio: UserPortfolio
    @Environment(FirebaseAuthService.self) var authService
    
    init(portfolio: UserPortfolio) {
        _portfolio = State(wrappedValue: portfolio)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("current auth.id \(authService.user?.email ?? "no user email")")
                }
                HStack {
                    Text("current portfolio.id \(portfolio.userID)")
                    Text(portfolio.dateofCreation, style: .time)
                }
                HStack {
                    Text("\(portfolio.initialValue)")
                    Text("\(portfolio.cashBalance)")
                }
                Button("Sign out") {
                    try? authService.signOut()
                    print("after sign out: auth.id \(authService.user?.email ?? "no useremail")")
                    print("after sign out: portfolio.id \(portfolio.id)")
                }

                List {
                    Section {
                        let allCoins = portfolio.favoriteCoins ?? []
                        ForEach(allCoins) { coin in
                            HStack {
                                Text(coin.name)
                                Text(coin.timestamp, style: .time)
                            }
                        }
                    } header: {
                        Text("All Coins")
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Portfolio")
        }
    }
}
