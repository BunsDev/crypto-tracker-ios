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
    @Environment(\.modelContext) var context
    let coin: Coin
    @Bindable var user: UserProfile
    @State private var favoriteCoin: FavoriteCoin? = nil
    
    init(coin: Coin, user: UserProfile) {
        self.coin = coin
        self.user = user
        let matchedCoin = user.favoriteCoins?.first(where: { $0.name == coin.nameString })
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
                favoriteCoin = FavoriteCoin(name: coin.nameString, isFavorite: true, userID: user.email)
                user.favoriteCoins?.insert(favoriteCoin!, at: 0)
            }
        } label: {
            Image(systemName: "heart.circle")
                .foregroundStyle((favoriteCoin != nil) ? (favoriteCoin!.isFavorite ? .accent : .secondary) : .secondary)
        }
    }
}
