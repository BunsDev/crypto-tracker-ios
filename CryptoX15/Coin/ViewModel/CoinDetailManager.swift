//
//  CoinDetailManager.swift
//  Crypto
//
//  Created by CJ on 7/13/23.
//

import Foundation
import Observation

@Observable final class CoinDetailManager {
    private(set) var coinDetail = CoinDetail()
    private(set) var coin = Coin()
    private(set) var coinPrice7D: [CoinPricePair] = []
    private(set) var statRows: [StatRow] = []
    private(set) var error: Error? = nil
    
    init(coin: Coin) {
        self.coin = coin
        mapCoinPriceSparklineToCoinPricePairArray()
        mapCoinStatRows()
    }

    func fetchCoinDetail() async {
        let url = "https://api.coingecko.com/api/v3/coins/\(coin.idString)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
        do {
            let data = try await APIService.downloadData(from: url)
            try await MainActor.run {
                coinDetail = try JSONDecoder().decode(CoinDetail.self, from: data)
            }
        } catch {
            self.error = error
            print(error.localizedDescription)
        }
    }
    
    /// Transforms the coin's price sparkline into an array of tuples representing dates and prices.
    private func mapCoinPriceSparklineToCoinPricePairArray() {
        let calendar = Calendar.current
        coinPrice7D = coin.unwrappedSparklineIn7D.price.enumerated().compactMap { (index, price) in
            guard let date = calendar.date(byAdding: .hour, value: index, to: coin.startDate) else { return nil }
            return CoinPricePair(date: date, price: price)
        }
    }
    
    private func mapCoinStatRows() {
        statRows =
        [
            StatRow(title: "Market Cap", value: coin.marketCapString, isAlwaysVisible: true),
            StatRow(title: "Cap Change", value: coin.marketCapChange24HString, isAlwaysVisible: true),
            StatRow(title: "Cap Change%", value: coin.marketCapChangePercentage24HString, isAlwaysVisible: true),
            StatRow(title: "24H High", value: coin.high24HString, isAlwaysVisible: false),
            StatRow(title: "24H Low", value: coin.low24HString, isAlwaysVisible: false),
            StatRow(title: "Rank", value: coin.marketCapRankString, isAlwaysVisible: false),
            StatRow(title: "ATH", value: coin.athString, isAlwaysVisible: false),
            StatRow(title: "ATL", value: coin.atlString, isAlwaysVisible: false),
            StatRow(title: "Total Volume", value: coin.totalVolumeString, isAlwaysVisible: false),
            StatRow(title: "Circulating Supply", value: coin.circulatingSupplyString, isAlwaysVisible: false),
            StatRow(title: "Total Supply", value: coin.totalSupplyString, isAlwaysVisible: false),
            StatRow(title: "Max Supply", value: coin.maxSupplyString, isAlwaysVisible: false)
        ]
    }
}

/// Represents a single row in the stats section.
struct StatRow: Hashable {
    let title: String
    let value: String
    let isAlwaysVisible: Bool
}

struct CoinPricePair: Hashable {
    var date: Date
    var price: Double
}
