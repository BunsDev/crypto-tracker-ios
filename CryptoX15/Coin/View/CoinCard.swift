//
//  CoinCard.swift
//  Crypto
//
//  Created by CJ on 7/13/23.
//

import SwiftUI

/// A view representing a card displaying information about a coin.
struct CoinCard: View {
    let coin: Coin
    
    var body: some View {
        RoundedOutlineContainer {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    AsyncImage(url: URL(string: coin.imageURLString)) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 28, height: 28)
                    Spacer()
                    Text(coin.symbolString)
                        .font(.subheadline)
                }
                
                Text(coin.currentPriceString)
                    .font(.callout)
                
                Text(coin.priceChangePercentage24HString)
                    .foregroundStyle(coin.priceChange24HDouble.gainLossColor)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
            }
            .foregroundStyle(.primary)
            .frame(width: 88, height: 72)
        }
    }
}
