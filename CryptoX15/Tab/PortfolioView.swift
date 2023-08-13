//
//  PortfolioView.swift
//  Crypto
//
//  Created by CJ on 7/13/23.
//

import SwiftUI


struct PortfolioView: View {
    @Environment(PortfolioManager.self) var portfolioManager
    @Environment(FirebaseAuthService.self) var authService
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @State private var confirmDeletion = false
    @State private var deletitonTask: Task<(), Error>?
    @Bindable var user: UserProfile
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    UserCard()
                    MyHolding(user: user)
                }
                .padding()
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    SecondaryButton(text: "Sign out") {
                        try? authService.signOut()
                    }
                    Spacer()
                    SecondaryButton(text: "Delete", textColor: .red.opacity(0.9), shadowColor: .red) {
                        confirmDeletion.toggle()
                    }
                }
                .padding(24)
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Portfolio")
        }
        .alert("Confirm Deletion", isPresented: $confirmDeletion) {
            HStack {
                Button("cancel", role: .cancel) {
                    dismiss()
                }
                Button("delete", role: .destructive, action: executeDeletionTask)
            }
        } message: {
            Text("The account can not be retrieved once it is deleted.")
        }
        .onSubmit(executeDeletionTask)
        .onDisappear {
            deletitonTask?.cancel()
        }
    }
    
    private func executeDeletionTask() {
        deletitonTask?.cancel()
        deletitonTask = Task {
            do {
                print("Start deleting portfolio data from Firestore")
                await portfolioManager.deletePortfolio()
                print("Deleted portfolio data from Firestore")
                print("Start deleting auth data from Authentication")
                try await authService.delete()
                print("Deleted auth data from Authentication")
                print("Start deleting portfolio data from local device")
                context.delete(user)
                print("Deleted portfolio data from local device")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
