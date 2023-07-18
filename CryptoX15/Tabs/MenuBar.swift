//
//  MenuBar.swift
//  Crypto
//
//  Created by CJ on 7/13/23.
//

import SwiftUI

/// A view that displays a scrollable horizontal menu with options for selecting different types of coins.
struct MenuBar: View {
    @Binding var selectedItem: CoinMenuItem
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top) {
                ForEach(CoinMenuItem.allCases) {item in
                    Text(item.name)
                        .font(.headline)
                        .foregroundStyle(selectedItem == item ? .accent : .secondary)
                        .onTapGesture {
                            selectedItem = item
                        }
                        .padding(.trailing, 15)
                }
            }
            .padding(.horizontal)
        }
    }
}
