//
//  FirebaseAuthService.swift
//  Crypto
//
//  Created by CJ on 7/7/23.
//

import Foundation
import FirebaseAuth
import SwiftData

enum AuthenticationState {
    case authenticated
    case unauthenticated
    case authenticating
}

enum Regex: String {
    case email = "^[A-Z0-9a-z._-]+@[A-Za-z0-9-]+\\.+[A-Za-z]{2,}$"
    case password = "^(?=.*[A-Z])(?=.*[!@#$^&*])(?=.*[0-9])(?=.*[a-z])[a-zA-Z0-9!@#$^&*]{8,}$"

    var format: String {
        rawValue
    }
}

enum Field: Hashable {
    case username
    case password
    case confirmPassword
}

enum AuthError: Error {
    case emptyPassword
    case invalidEmail
    case invalidPasswordFormat
    case unmatchedPassword
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyPassword:
            return NSLocalizedString("Please enter a password to continue.", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Please enter a valid email address to continue.", comment: "")
        case .invalidPasswordFormat:
            return NSLocalizedString("""
                Please ensure your password meets the following criteria:
                - Minimum length of 8 characters
                - At least 1 uppercase letter
                - At least 1 lowercase letter
                - At least 1 digit
                - At least 1 special character
                """, comment: "")
        case .unmatchedPassword:
            return NSLocalizedString("The confirm password does not match password.", comment: "")
        }
    }
}

@Observable @MainActor
final class FirebaseAuthService {
    private(set) var authState: AuthenticationState = .authenticating
    private(set) var user: User?
    private let auth = Auth.auth()
    private var authStateHandle: AuthStateDidChangeListenerHandle? = nil
    
    init() {
        registerAuthStateHandle()
    }
    
    private func registerAuthStateHandle() {
        if authStateHandle == nil {
            authStateHandle = auth.addStateDidChangeListener { [weak self] auth, user in
                guard let self = self else { return }
                self.user = user
                self.authState = (user == nil ? .unauthenticated : .authenticated)
            }
        }
    }
    
    @discardableResult
    func signIn(with email: String, and password: String) async throws -> Bool {
        let authResult = try await auth.signIn(withEmail: email, password: password)
        self.user = authResult.user
        authState = .authenticated
        return true
    }
    
    func resetPassword(with email: String) async throws -> Bool {
        try await auth.sendPasswordReset(withEmail: email)
        return true
    }
    
    func signUp(with email: String, and password: String, and confirmPassword: String) async throws -> Bool {
        if let handle = authStateHandle {
            auth.removeStateDidChangeListener(handle)
        }
        let authResult = try await auth.createUser(withEmail: email, password: password)
        self.user = authResult.user
        return true
    }
    
    func signOut() throws {
        try auth.signOut()
        authState = .unauthenticated
    }
    
    func delete() async throws {
        try await user?.delete()
        authState = .unauthenticated
    }
}
