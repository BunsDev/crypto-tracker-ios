//
//  SignUpView.swift
//  Crypto
//
//  Created by CJ on 7/7/23.
//

import SwiftUI

/// A view representing the sign up screen.
struct SignUpView: View {
    @Environment(FirebaseAuthService.self) var authService
    @Environment(PortfolioManager.self) var portfolioManager
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var signUpTask: Task<(), Never>?
    @State private var showAlert = false
    @State private var alertOption: AlertOption = .success
    @FocusState private var focusedField: Field?
    @Environment(\.modelContext) private var context
        
    private var alertTitle: String {
        switch alertOption {
        case .success: return "Account Created"
        case .failure: return "Failed to sign up"
        }
    }
    
    private var alertMessage: String {
        switch alertOption {
        case .success: return "Thanks, your account has been successfully created!"
        case .failure(let message): return message
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            titleSection
            mainSection
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.accent.gradient)
        .alert(alertTitle, isPresented: $showAlert) {
            switch alertOption {
            case .success:
                Button("OK") {
                    dismiss()
                }
            case .failure(_):
                Button("OK") {}
            }
        } message: {
            Text(alertMessage)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) { dismissButton }
//            ToolbarItemGroup(placement: .keyboard) {
//                Spacer()
//                Button("Done") {
//                    focusedField = nil
//                }
//            }
        }
        .onSubmit(executeSignUpTask)
        .onDisappear {
            signUpTask?.cancel()
        }
    }
    
    private var dismissButton: some View {
        Button("Cancel") {
            dismiss()
        }
        .foregroundStyle(.white)
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading) {
            Text("Create Account")
                .font(.largeTitle.bold())
            HStack {
                Image(systemName: "pencil.and.outline")
                Text("Let's start your crypto journey...")
            }
        }
        .foregroundStyle(.white)
        .shadow(radius: 5)
        .padding(.leading)
    }
    
    private var mainSection: some View {
        VStack(spacing: 40) {
            inputFields
            signUpButton
        }
        .roundedCard()
    }
    
    private var inputFields: some View {
        VStack(alignment: .leading, spacing: 20) {
            TextField("Email", text: $email)
                .focused($focusedField, equals: .username)
            SecureField("Password", text: $password)
                .focused($focusedField, equals: .password)
            SecureField("Confirm password", text: $confirmPassword)
                .focused($focusedField, equals: .confirmPassword)
        }
        .textFieldStyle(.underline)
        .keyboardType(.emailAddress)
    }
    
    private var signUpButton: some View {
        PrimaryButton(text: "Sign Up", action: executeSignUpTask)
    }
    
    private func executeSignUpTask() {
        signUpTask?.cancel()
        signUpTask = Task {
            do {
                try validation()
                if try await authService.signUp(with: email, and: password, and: confirmPassword) {
                    alertOption = .success
                    focusedField = nil
                    if let email = await authService.user?.email, let id = await authService.user?.uid {
                        context.insert(UserProfile(email: email))
                        await portfolioManager.createPortfolio(documentID: id, email: email)
                    }
                }
                try await authService.signOut()
            } catch {
                alertOption = .failure(error.localizedDescription)
            }
            showAlert.toggle()
        }
    }
    
    private func validation() throws {
        if email.isEmpty || !email.isValidRegex(.email) {
            focusedField = .username
            throw AuthError.invalidEmail
        } else if password.isEmpty || !password.isValidRegex(.password) {
            focusedField = .password
            throw AuthError.invalidPasswordFormat
        } else if password != confirmPassword {
            focusedField = .confirmPassword
            throw AuthError.unmatchedPassword
        } else {
            focusedField = .username
        }
    }
}
