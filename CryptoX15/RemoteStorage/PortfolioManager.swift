//
//  PortfolioManager.swift
//  CryptoX15
//
//  Created by CJ on 7/20/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftData

/// A enum provide user feedback for trading=related actions
enum Prompt: String {
    case success
    case insufficientFunds
    case invalidQuantity
    case overSale
    case notHolding

    var message: String {
        switch self {
        case .success:
            return "Transaction is completed."
        case .insufficientFunds:
            return "Insufficient funds for this transaction."
        case .invalidQuantity:
            return "The quantity can not be zero or negative or empty."
        case .overSale:
            return "The sale quantity should be less than or equal to the quantity you currently hold."
        case .notHolding:
            return "You do not own the stock."
        }
    }
}

/// A class is responsible for managing a user portfolio and interating with Firestore database to store portfolio data
@Observable final class PortfolioManager {
    private(set) var userPortfolio = UserPortfolio()
    private(set) var prompt: Prompt = .success
    private let db: Firestore = Firestore.firestore()
    private let colName: String = "users"
    private let encoder = Firestore.Encoder()
    
    /// Creates a new portfolio for a user with specified document ID  in Firestore and associates it with the given email address.
    /// - Parameters:
    ///   - documentID: A unique identifier for the portfolio document in Firestore
    ///   - email: The email address associated with the user's portfolio
    func createPortfolio(documentID: String, email: String) async {
        guard !documentID.isEmpty && !email.isEmpty else {
            print("ID and email can not be empty.")
            return
        }
        let docRef = docReference(documentID: documentID)
        let portfolio = UserPortfolio(email: email, accountInitialValue: 1000000, cashBalance: 1000000)
        do {
            try docRef.setData(from: portfolio)
        } catch {
            print(String(describing: error.localizedDescription))
        }
    }
    
    /// Fetches the portfolio data associated with the specified document ID from the Firestore database.
    /// - Parameter documentID: The unique identifier of the portfolio document to fetch.
    @MainActor func fetchPortfolio(documentID: String) async {
        guard !documentID.isEmpty else {
            print("ID can not be empty.")
            return
        }
        let docRef = docReference(documentID: documentID)
        do {
            let portfolio = try await docRef.getDocument(as: UserPortfolio.self)
            userPortfolio = portfolio
        } catch {
            print(String(describing: error.localizedDescription))
        }
    }
    
    /// Deletes the user's portfolio from the Firestore database
    @MainActor func deletePortfolio() async {
        guard let id = userPortfolio.id else {
            print("ID can not be empty.")
            return
        }
        let docRef = docReference(documentID: id)
        do {
            try await docRef.delete()
        } catch {
            print(String(describing: error.localizedDescription))
        }
    }
    
    /// Buys a specified quantity of a cryptocurrency and update the user's portfolio.
    /// - Parameters:
    ///   - coin: The Coin object representing the coin to be bought.
    ///   - buyPrice: The price at which the user is buying the coin.
    ///   - quantity: The quantity of the coin to be bought.
    @MainActor func buyCoin(coin: Coin, buyPrice: Double, quantity: Double) async {
        guard quantity > 0 else {
            prompt = .invalidQuantity
            return
        }
        let cost = buyPrice * quantity
        guard cost <= userPortfolio.cashBalance else {
            prompt = .insufficientFunds
            return
        }
        guard let id = userPortfolio.id else {
            print("can not find user ID.")
            return
        }
        if let holding = userPortfolio.holdings?.first(where: { $0.name == coin.nameString }) {
            var newHolding = holding
            newHolding.quantity += quantity
            newHolding.buyPrice = (holding.buyPrice * holding.quantity + cost) / (holding.quantity + quantity)
            await updatePortfolio(documentID: id, cashAdjustment: -cost, holding: holding, newHolding: newHolding)
        } else {
            let newHolding = Holding(name: coin.nameString, symbol: coin.symbolString, quantity: quantity, buyPrice: buyPrice)
            await updatePortfolio(documentID: id, cashAdjustment: -cost, newHolding: newHolding)
        }
    }
    
    /// Sells a specified quantity of a cryptocurrency and update the user's portfolio
    /// - Parameters:
    ///   - coin: The Coin object representing the coin to be sold.
    ///   - sellPrice: The price at which the user is selling the coin.
    ///   - quantity: The quantity of the coin to be sold.
    @MainActor func sellCoin(coin: Coin, sellPrice: Double, quantity: Double) async {
        guard quantity > 0 else {
            prompt = .invalidQuantity
            return
        }
        guard let id = userPortfolio.id else {
            print("can not find user ID.")
            return
        }
        if let holding = userPortfolio.holdings?.first(where: { $0.name == coin.nameString }) {
            guard quantity <= holding.quantity else {
                prompt = .overSale
                return
            }
            let proceeds = sellPrice * quantity
            var newHolding = holding
            newHolding.quantity -= quantity
            await updatePortfolio(documentID: id, cashAdjustment: proceeds, holding: holding, newHolding: quantity < holding.quantity ? newHolding : nil)
        } else {
            prompt = .notHolding
        }
    }
    
    /// Updates the user's portfolio in the Firestore database with adjustments related to cash balance and holdings.
    /// - Parameters:
    ///   - documentID: The unique identifier of the portfolio document to update.
    ///   - cashAdjustment: The amount to adjust the cash balance by.
    ///   - holding: The existing Holding object to be removed in the holdings array (can be nil if there's no existing holding).
    ///   - newHolding: The new Holding object to be added to the holdings array (can be nil if no new holding is added).
    @MainActor private func updatePortfolio(documentID: String, cashAdjustment: Double, holding: Holding? = nil, newHolding: Holding? = nil) async {
        let batch = db.batch()
        let docRef = docReference(documentID: documentID)
        if let holding = holding {
            let encodedHolding = try? encoder.encode(holding)
            let holdingUpdate = FieldValue.arrayRemove([encodedHolding ?? [:]])
            batch.updateData([UserPortfolio.CodingKeys.holdings.rawValue: holdingUpdate], forDocument: docRef)
        }
        if let newHolding = newHolding {
            let encodedNewHolding = try? encoder.encode(newHolding)
            let newHoldingUpdate = FieldValue.arrayUnion([encodedNewHolding ?? [:]])
            batch.updateData([UserPortfolio.CodingKeys.holdings.rawValue: newHoldingUpdate], forDocument: docRef)
        }
        let cashBalanceUpdate = FieldValue.increment(cashAdjustment)
        batch.updateData([UserPortfolio.CodingKeys.cashBalance.rawValue: cashBalanceUpdate], forDocument: docRef)
        do {
    //        try await docRef.updateData([UserPortfolio.CodingKeys.holdings.rawValue: holdingUpdate])
            try await batch.commit()
            prompt = .success
            await fetchPortfolio(documentID: documentID)
        } catch {
            print(String(describing: error.localizedDescription))
        }
    }
    
    /// Returns the Firestore DocumentReference for the given documentID within the collection.
    /// - Parameter documentID: The unique identifier of the portfolio document to create a reference for.
    /// - Returns: Returns a Firestore DocumentReference
    private func docReference(documentID: String) -> DocumentReference {
        return db.collection(colName).document(documentID)
    }
}
