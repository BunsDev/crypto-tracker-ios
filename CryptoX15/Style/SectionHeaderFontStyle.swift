//
//  SectionHeaderFontStyle.swift
//  Crypto
//
//  Created by CJ on 7/7/23.
//

import SwiftUI

/// A view modifier that applies a specific font and weight to the content, suitable for section headers.
struct SectionHeaderFontStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .fontWeight(.semibold)
    }
}

extension View {
    
    /// A modifier that applies the `SectionHeaderFontStyle` style to a view.
    /// - Returns: A modified version of the view with a font and weight appropriate for section headers applied.
    func sectionHeader() -> some View {
        modifier(SectionHeaderFontStyle())
    }
}
