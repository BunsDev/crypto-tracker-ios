//
//  CoinRow.swift
//  Crypto
//
//  Created by CJ on 7/13/23.
//

import SwiftUI

/// A view that displays a single row in the `CoinList` view.
struct CoinRow: View {
    let coin: Coin
    
    var body: some View {
        HStack {
            Text("")
            AsyncImage(url: URL(string: coin.imageURLString)) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 38, height: 38)
            
            VStack(alignment: .leading, spacing: 5){
                Text(coin.nameString)
                    .font(.headline)
                    .lineLimit(1)
                Text(coin.symbolString)
                    .font(.caption)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 5) {
                Text(coin.currentPriceString)
                    .font(.headline)
                
                HStack {
                    Text(coin.priceChange24HString)
                    Text(coin.priceChangePercentage24HString)
                }
                .font(.caption)
                .foregroundStyle(coin.priceChange24HDouble.gainLossColor)
            }
        }
        .padding(.vertical, 10)
    }
}
