//
//  TradePage.swift
//  CryptoX15
//
//  Created by CJ on 7/20/23.
//

import SwiftUI

struct TradePage: View {
    @Environment(PortfolioManager.self) var portfolioManager
    @Environment(\.dismiss) private var dismiss
    @Bindable var coinDetailManager: CoinDetailManager
    @State private var trade: Trade = .buy
    @State private var quantity: Double? = 0
    @State private var tradeTask: Task<(), Error>?
    @FocusState private var isFocused: Bool
    @State private var showPromptMessage = false
    @Namespace private var namespace
    
    enum Trade: String, CaseIterable, Identifiable {
        case buy
        case sell

        var id: String {
            name
        }
        var name: String {
            rawValue.capitalized
        }
    }
    
    private var coin: Coin {
        coinDetailManager.coin
    }
    
    private var price: Double {
        coin.currentPriceDouble
    }
    private var totalPrice: Double {
        price * (quantity ?? 0)
    }
    
    var body: some View {
        ZStack {
            tapArea
            VStack(spacing: 20) {
                HStack(alignment: .firstTextBaseline) {
                    header
                    Spacer()
                    dismissButton
                }
                .padding(.bottom, 50)
                CoinPriceChart(manager: coinDetailManager)
                transcationPicker
                quantityField
                priceField
                Spacer()
                transactionPrompt
                confirmButton
            }
            .padding()
        }
        .onChange(of: quantity) { _, newValue in
            if newValue == nil {
                quantity = 0
            }
        }
        .onSubmit(executeTradeTask)
        .onDisappear {
            tradeTask?.cancel()
        }
    }
    
    private var tapArea: some View {
        Color.clear.contentShape(Rectangle())
            .onTapGesture {
                if showPromptMessage {
                    quantity = 0
                }
                reset()
            }
    }
    
    private var transactionPrompt: some View {
        Text(showPromptMessage ? portfolioManager.prompt.message : " ")
            .lineLimit(2, reservesSpace: true)
            .foregroundColor(portfolioManager.prompt == .success ? .accentColor : .red)
    }
    
    private var dismissButton: some View {
        Button("Cancel") {
            dismiss()
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading) {
            Text(coin.nameString)
                .sectionHeader()
            HStack {
                Text(coin.priceChange24HString)
                Text(coin.priceChangePercentage24HString)
            }
            .foregroundColor(coin.priceChange24HDouble.gainLossColor)
        }
    }
    
    private var transcationPicker: some View {
        HStack(spacing: 0) {
            ForEach(Trade.allCases) { selection in
                ZStack {
                    if trade == selection {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(trade == selection ? Color.accentColor : .clear)
                            .frame(width: 64)
                            .matchedGeometryEffect(id: "Trade", in: namespace)
                    }
                    Button {
                        trade = selection
                        reset()
                    } label: {
                        Text(selection.name)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .frame(width: 64, height: 24)
                            .foregroundColor(trade == selection ? .white : .secondary)
                    }
                }
                .frame(height: 24)
            }
        }
        .background(.secondary.opacity(0.1))
        .cornerRadius(10)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    private var quantityField: some View {
        HStack {
            Text("Quantity")
            Spacer()
            TextField("Quantity", value: $quantity, formatter: quantity?.decimalFormatterForQuantity() ?? NumberFormatter())
                .keyboardType(.decimalPad)
                .frame(width: 120, height: 36)
                .textFieldStyle(.roundedBorder)
                .focused($isFocused)
            Button {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    if let value = quantity {
                        quantity = value + 1
                    }
                }
                reset()
            } label: {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
            }
            Divider()
                .frame(height: 20)
            Button {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    if let value = quantity {
                        quantity = max(value - 1, 0)
                    }
                }
                reset()
            } label: {
                Image(systemName: "minus.circle")
                    .imageScale(.large)
            }
        }
    }
    
    private var priceField: some View {
        HStack(alignment: .lastTextBaseline) {
            Text("Total Price")
            Spacer()
            VStack(alignment: .trailing) {
                Text("Current Price: \(coin.currentPriceString)")
                    .font(.subheadline)
                Text(totalPrice.asCurrencyWithDecimals())
            }
        }
    }
    
    private var confirmButton: some View {
        Button(action: executeTradeTask) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.whiteAndBlack)
                    .shadow(color: .accentColor, radius: 5)
                    .frame(height: 48)
                Text(trade.name)
                    .font(.title2)
                    .fontWeight(.bold)
            }
        }
    }
    
    private func executeTradeTask() {
        tradeTask?.cancel()
        tradeTask = Task {
            switch trade {
            case .buy:
                await portfolioManager.buyCoin(coin: coin, buyPrice: price, quantity: quantity ?? 0)
            case .sell:
                await portfolioManager.sellCoin(coin: coin, sellPrice: price, quantity: quantity ?? 0)
            }
            withAnimation {
                showPromptMessage = true
            }
            isFocused = false
            quantity = nil
        }
    }
    
    private func reset() {
        isFocused = false
        showPromptMessage = false
    }
}

