//
//  ContentView.swift
//  CryptoX15
//
//  Created by CJ on 7/12/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(FirebaseAuthService.self) var authService
    
    var body: some View {
        switch authService.authState {
        case .unauthenticated:
            LoginView()
        case .authenticated:
            VStack {
                Text(authService.user?.providerID ?? " ")
                Text("Welcome \(authService.user?.email ?? " ")")
                Button("sign out") {
                    do {
                        try authService.signOut()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
