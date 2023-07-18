//
//  RoundedOutlineContainer.swift
//  Crypto
//
//  Created by CJ on 7/7/23.
//

import SwiftUI

/// A container view that adds a rounded outline with a specified corner radius and border color to its content.
struct RoundedOutlineContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(.accent, lineWidth: 2)
            )
    }
}
