//
//  CoinManager.swift
//  Crypto
//
//  Created by CJ on 7/13/23.
//

import Foundation
import Observation

@Observable
final class CoinManager {
    private(set) var coins: [Coin] = []
    private let url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1&sparkline=true"
    private(set) var coinDic: [String: Coin] = [:]
    private(set) var top10MovingCoins: [Coin] = []
    private(set) var error: Error? = nil
    
    func fetchCoinData() async {
        do {
            let data = try await APIService.downloadData(from: url)
            coins = try JSONDecoder().decode([Coin].self, from: data)
            coinDic = mapCoinDic()
            top10MovingCoins = getTop10Movers()
        } catch {
            self.error = error
            print(error.localizedDescription)
        }
    }
    
    private func mapCoinDic() -> [String: Coin] {
        coins.reduce(into: [String: Coin]()) { $0[$1.nameString] = $1 }
    }
    
    private func getTop10Movers() -> [Coin] {
        Array(coins.sorted { abs($0.priceChangePercentage24HDouble) > abs($1.priceChangePercentage24HDouble) }.prefix(10))
    }
}
