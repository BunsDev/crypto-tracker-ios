//
//  UnderlineTextFieldStyle.swift
//  Crypto
//
//  Created by CJ on 7/7/23.
//

import SwiftUI

/// A custom `TextFieldStyle` that applies an underline and specific text input settings to a `TextField`.
struct UnderlineTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .overlay(
                Rectangle().frame(height: 1).foregroundStyle(.secondary).padding(.top, 24)
            )
    }
}

extension TextFieldStyle where Self == UnderlineTextFieldStyle {
    
    /// A modifier that applies the `UnderlineTextFieldStyle` to a `TextField`.
    static var underline: UnderlineTextFieldStyle {
        UnderlineTextFieldStyle()
    }
}
