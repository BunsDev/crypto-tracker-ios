//
//  LoginView.swift
//  Crypto
//
//  Created by CJ on 7/7/23.
//

import SwiftUI

/// A view representing the login screen.
struct LoginView: View {
    @Environment(FirebaseAuthService.self) var authService
    @State private var email = ""
    @State private var password = ""
    @State private var showSignUp = false
    @State private var showReset = false
    @State private var signInTask: Task<(), Never>?
    @State private var showAlert = false
    @State private var errorMessage = ""
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationStack {
            VStack {
                logoSection
                mainSection
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.accent.gradient)
        }
        .alert("Login falied", isPresented: $showAlert) {
        } message: {
            Text(errorMessage)
        }
//        .toolbar {
//            ToolbarItemGroup(placement: .keyboard) {
//                Spacer()
//                Button("Done") {
//                    focusedField = nil
//                }
//            }
//        }
        .onSubmit(executeSignInTask)
        .onDisappear {
            signInTask?.cancel()
        }
    }
    
    private var logoSection: some View {
        Text("Cryptocoin")
            .font(.largeTitle.bold())
            .foregroundStyle(.white)
            .shadow(radius: 5)
    }
    
    private var mainSection: some View {
        VStack(spacing: 40) {
            inputFields
            VStack(spacing: 20) {
                signInButton
                resetButton
                signUpButton
            }
        }
        .roundedCard()
    }
    
    private var inputFields: some View {
        VStack(alignment: .leading, spacing: 20) {
            TextField("Email", text: $email)
                .focused($focusedField, equals: .username)
                .keyboardType(.emailAddress)
            SecureField("Password", text: $password)
                .focused($focusedField, equals: .password)
        }
        .textFieldStyle(.underline)
    }
    
    private var signInButton: some View {
        PrimaryButton(text: "Sign in", action: executeSignInTask)
    }
    
    private func executeSignInTask() {
        signInTask?.cancel()
        signInTask = Task {
            do {
                try validation()
                try await authService.signIn(with: email, and: password)
            } catch {
                errorMessage = error.localizedDescription
                showAlert.toggle()
            }
        }
    }
    
    private func validation() throws {
        if email.isEmpty || !email.isValidRegex(.email) {
            focusedField = .username
            throw AuthError.invalidEmail
        } else {
            focusedField = .password
            if password.isEmpty {
                throw AuthError.emptyPassword
            }
        }
    }
    
    private var resetButton: some View {
        Button {
            showReset.toggle()
            reset()
        } label: {
            Text("Forgot username or password?")
                .bold()
                .foregroundStyle(.accent)
        }
        .navigationDestination(isPresented: $showReset) {
            ResetView()
        }
    }
    
    private var signUpButton: some View {
        HStack {
            Text("New user?")
            Button {
                showSignUp.toggle()
                reset()
            } label: {
                Text("Sign Up")
                    .foregroundStyle(.accent)
            }
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView()
            }
        }
    }
    
    private func reset() {
        focusedField = nil
        email = ""
        password = ""
    }
}
