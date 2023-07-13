//
//  RoundedCardStyle.swift
//  Crypto
//
//  Created by CJ on 7/7/23.
//

import SwiftUI

/// A custom view modifier that applies a styled card appearance to a view.
struct RoundedCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .padding(.top)
            .background()
            .cornerRadius(20)
            .padding()
            .shadow(radius: 15)
    }
}

extension View {
    
    /// A modifier that applies the `RoundedCardStyle` style to a view.
    /// - Returns: A modified version of the view with the styled card appearance applied.
    func roundedCard() -> some View {
        modifier(RoundedCardStyle())
    }
}
