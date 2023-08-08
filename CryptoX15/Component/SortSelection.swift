//
//  SortSelection.swift
//  Crypto
//
//  Created by CJ on 7/13/23.
//

import SwiftUI

struct SortSelection: View {
    @Binding var selectedOption: SortOption
    @Binding var isDescending: Bool
    
    var body: some View {
        HStack {
            Spacer()
            Text(selectedOption.title)
                .onTapGesture {
                    selectedOption = selectedOption.next()
                }
            Image(systemName: isDescending ? "chevron.down" : "chevron.up")
                .onTapGesture {
                    isDescending.toggle()
                }
        }
        .padding(.trailing)
        .font(.system(size: 12))
    }
}
