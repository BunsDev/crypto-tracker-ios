//
//  CryptoX15App.swift
//  CryptoX15
//
//  Created by CJ on 7/12/23.
//

import SwiftUI
import FirebaseCore

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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authService)
        }
    }
}
