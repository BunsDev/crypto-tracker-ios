//
//  SecondaryButton.swift
//  CryptoX15
//
//  Created by CJ on 7/20/23.
//

import SwiftUI

struct SecondaryButton: View {
    let text: String
    let textColor: Color
    let shadowColor: Color
    let action: () -> Void
    
    init(text: String, textColor: Color = .accentColor, shadowColor: Color = .accentColor, action: @escaping () -> Void) {
        self.text = text
        self.textColor = textColor
        self.shadowColor = shadowColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.whiteAndBlack)
                    .shadow(color: shadowColor, radius: 5)
                    .frame(width: 96, height: 42)
                Text(text)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(textColor)
            }
        }
    }
}
