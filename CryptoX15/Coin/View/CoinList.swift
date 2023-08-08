//
//  CoinList.swift
//  Crypto
//
//  Created by CJ on 7/13/23.
//

import SwiftUI
import SwiftData

struct CoinList: View {
    let coins: [Coin]
    @Bindable var user: UserProfile
    
    var body: some View {
        List {
            Section {
                ForEach(coins) { coin in
                    NavigationLink {
                        CoinDetailView(coin: coin, user: user)
                    } label: {
                        CoinRow(coin: coin)
                    }
                }
            } header: {
                HStack {
                    Text("Name/Symbol")
                    Spacer()
                    Text("Price/Percentage")
                }
            }
        }
        .listStyle(.plain)
    }
}
