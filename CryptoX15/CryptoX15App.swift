//
//  CryptoX15App.swift
//  CryptoX15
//
//  Created by CJ on 7/7/23.
//

import SwiftUI
import FirebaseCore
import SwiftData

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct CryptoX15App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var authService = FirebaseAuthService()
    @State private var coinManager = CoinManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authService)
                .environment(coinManager)
                .modelContainer(for: [UserPortfolio.self, UserFavoriteCoin.self, UserCoinHolding.self])
        }
    }
}
