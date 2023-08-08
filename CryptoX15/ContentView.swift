//
//  ContentView.swift
//  CryptoX15
//
//  Created by CJ on 7/7/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(FirebaseAuthService.self) var authService
    
    var body: some View {
        switch authService.authState {
        case .authenticating:
            TransitionView()
        case .unauthenticated:
            LoginView()
        case .authenticated:
            HomeTabView(service: authService)
        }
    }
}

