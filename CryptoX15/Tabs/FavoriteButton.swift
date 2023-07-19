//
//  FavoriteButton.swift
//  Crypto
//
//  Created by CJ on 7/13/23.
//

import SwiftUI
import SwiftData

/// A reusable component that represents a favorite button.
struct FavoriteButton: View {
    let coin: Coin
    @Bindable var portfolio: UserPortfolio
    @Environment(\.modelContext) var context
    
//    var favoriteCoin: UserFavoriteCoin? {
//        portfolio.favoriteCoins?.first(where: { $0.name == coin.nameString })
//    }
    @State private var favoriteCoin: UserFavoriteCoin? = nil
    
    init(coin: Coin, portfolio: UserPortfolio) {
        self.coin = coin
        self.portfolio = portfolio
        let matchedCoin = portfolio.favoriteCoins?.first(where: { $0.name == coin.nameString })
        _favoriteCoin = State(wrappedValue: matchedCoin)
    }
    
    var body: some View {
        Button {
            if favoriteCoin != nil {
                withAnimation {
                    favoriteCoin!.timestamp = .now
                    favoriteCoin!.isFavorite.toggle()
                }
            } else {
                favoriteCoin = UserFavoriteCoin(name: coin.nameString, isFavorite: true, userID: portfolio.userID)
                portfolio.favoriteCoins?.insert(favoriteCoin!, at: 0)
            }
        } label: {
            Image(systemName: "heart.circle")
                .foregroundStyle((favoriteCoin != nil) ? (favoriteCoin!.isFavorite ? .accent : .secondary) : .secondary)
        }
    }
}
