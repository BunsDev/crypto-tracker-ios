//
//  PrimaryButton.swift
//  Crypto
//
//  Created by CJ on 7/7/23.
//

import SwiftUI

/// A  view that represents a primary button with a rounded rectangle background and centered text for initial screens.
struct PrimaryButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.accentColor.opacity(0.9))
                    .frame(height: 48)
                Text(text)
                    .font(.title2.bold())
                    .foregroundColor(.white)
            }
        }
    }
}
