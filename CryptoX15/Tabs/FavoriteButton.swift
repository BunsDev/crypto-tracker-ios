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
    @State private var favoriteCoin: UserFavoriteCoin = UserFavoriteCoin()
//    let coin: UserFavoriteCoin
    
    var body: some View {
        Button {
            withAnimation {
                favoriteCoin.timestamp = .now
                favoriteCoin.isFavorite.toggle()
            }
        } label: {
            Image(systemName: "heart.circle")
                .foregroundStyle(favoriteCoin.isFavorite ? .accent : .secondary)
        }
    }
}
