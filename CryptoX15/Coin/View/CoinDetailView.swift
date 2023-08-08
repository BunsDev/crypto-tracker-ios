//
//  CoinDetailView.swift
//  Crypto
//
//  Created by CJ on 7/13/23.
//

import SwiftUI
import SwiftData

struct CoinDetailView: View {
    @Environment(\.modelContext) var context
    @State private var manager: CoinDetailManager
    @State private var showFullDescription = false
    @State private var showAllStats = false
    @State private var showTradeView = false
    @Bindable var user: UserProfile
    
    init(coin: Coin, user: UserProfile) {
        _manager = State(wrappedValue: CoinDetailManager(coin: coin))
        self.user = user
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 40) {
                    subHeadlineSection
                    CoinPriceChart(manager: manager)
                    marketStatsSection
                    descriptionSection
                    resourceSection
                }
                .padding()
            }
            .padding(.bottom, 65)
            tradeButton
        }
        .fullScreenCover(isPresented: $showTradeView) {
            TradePage(coinDetailManager: manager)
        }
        .navigationTitle(manager.coin.currentPriceString)
        .toolbar(.hidden, for: .tabBar)
        .task {
            await manager.fetchCoinDetail()
        }
    }
    
    private var subHeadlineSection: some View {
        HStack {
            Text("\(manager.coin.priceChange24HString) (\(manager.coin.priceChangePercentage24HString))")
                .foregroundStyle(manager.coin.priceChange24HDouble.gainLossColor)
            Spacer()
            FavoriteButton(coin: manager.coin, user: user)
                .font(.largeTitle)
                .contentShape(Circle().offset(y: -10))
        }
        .offset(y: -20)
    }
    
    private var tradeButton: some View {
        VStack {
            Spacer()
            SecondaryButton(text: "Trade") {
                showTradeView.toggle()
            }
        }
    }
    
    private var marketStatsSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Market Stats")
                    .sectionHeader()
                Spacer()
                Button {
                    showAllStats.toggle()
                } label: {
                    Image(systemName: "arrowshape.turn.up.forward.fill")
                        .rotationEffect(Angle(degrees: Double(showAllStats ? 90 : -90)))
                }
            }
    
            Divider()
        
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: 8) {
                ForEach(manager.statRows, id: \.self) { statRow in
                    if showAllStats || statRow.isAlwaysVisible {
                        VStack(alignment: .leading) {
                            Text(statRow.title)
                                .foregroundStyle(.secondary)
                            Text(statRow.value)
                        }
                    }
                }
            }
        }
        .font(.caption)
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading) {
            Text("About \(manager.coin.nameString)")
                .sectionHeader()
            Divider()
            Text(manager.coinDetail.coinDescription)
                .lineLimit(showFullDescription ? nil : 3)
                .foregroundStyle(.secondary)
            Button {
                showFullDescription.toggle()
            } label: {
                Text(showFullDescription ? "show less" : "read more...")
            }
        }
    }
    
    private var resourceSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Resources")
                .sectionHeader()
            Divider()
            if let homeURL = manager.coinDetail.homeURL, let forumURL = manager.coinDetail.forumURL {
                HStack {
                    Image(systemName: "globe")
                        .foregroundStyle(.secondary)
                    Link("Home Page", destination: homeURL)
                }
                HStack {
                    Image(systemName: "person.2.circle")
                        .foregroundStyle(.secondary)
                    Link("Official Forum", destination: forumURL)
                }
            }
        }
        .imageScale(.large)
    }
}
