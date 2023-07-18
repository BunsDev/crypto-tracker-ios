//
//  CoinListOperation.swift
//  CryptoX15
//
//  Created by CJ on 7/13/23.
//

/// An enum that represents the items in the horizontal scroll bar.
enum CoinMenuItem: String, CaseIterable, Identifiable {
    case cryptos
    case gainers
    case losers
    
    var name: String {
        rawValue.capitalized
    }
    
    var id: String {
        name
    }
}

/// An enum that represents the available sorting options.
enum SortOption: String, CaseIterable, Identifiable {
    case currentPrice
    case marketCapRank
    case priceChange24H
    case priceChangePercentage24H
    
    var title: String {
        switch self {
        case .currentPrice:
            "Price"
        case .marketCapRank:
            "Market Cap"
        case .priceChange24H:
            "Change 24H"
        case .priceChangePercentage24H:
            "% Change 24H"
        }
    }
    
    var id: String {
        rawValue
    }
}

final class CoinListOperation {
    
    static func update(_ coins: [Coin], in menuItem: CoinMenuItem, by option: SortOption, in descendingOrder: Bool, by searchText: String) -> [Coin] {
        let sortedCoins = update(coins, by: option, in: descendingOrder, by: searchText)
        return filter(sortedCoins, by: menuItem)
    }
    
    static func update(_ coins: [Coin], by option: SortOption, in descendingOrder: Bool, by searchText: String) -> [Coin] {
        let filteredCoins = filter(coins, by: searchText)
        return sort(filteredCoins, by: option, in: descendingOrder)
    }
    
    /// Filters an array of 'Coin' objects based on the currently selected menu item.
    static func filter(_ coins: [Coin], by menuItem: CoinMenuItem) -> [Coin] {
        return switch menuItem {
        case .cryptos:
            coins
        case .gainers:
            coins.filter { $0.priceChange24HDouble > 0 }
        case .losers:
            coins.filter { $0.priceChange24HDouble < 0 }
        }
    }
    
    /// Sorts an array of 'Coin' objects based on a given sorting option and direction.
    static func sort(_ coins: [Coin], by option: SortOption, in descendingOrder: Bool) -> [Coin] {
        return coins.sorted {
            switch option {
            case .currentPrice:
                descendingOrder ? $0.currentPriceDouble > $1.currentPriceDouble : $0.currentPriceDouble < $1.currentPriceDouble
            case .marketCapRank:
                descendingOrder ? $0.marketCapRankDouble < $1.marketCapRankDouble : $0.marketCapRankDouble > $1.marketCapRankDouble
            case .priceChange24H:
                descendingOrder ? $0.priceChange24HDouble > $1.priceChange24HDouble : $0.priceChange24HDouble < $1.priceChange24HDouble
            case .priceChangePercentage24H:
                descendingOrder ? $0.priceChangePercentage24HDouble > $1.priceChangePercentage24HDouble : $0.priceChangePercentage24HDouble < $1.priceChangePercentage24HDouble
            }
        }
    }
    
    /// Filters an array of `Coin` objects based on a search text.
    ///
    /// The function performs a case-insensitive search of each `Coin` object's `Name` and `Symbol` properties for a match with the provided `text`. If the `text` parameter is empty, the original array of `Coin` objects is returned unchanged.
    static func filter(_ coins: [Coin], by searchText: String) -> [Coin] {
        guard !searchText.isEmpty else { return coins }
        let lowercasedText = searchText.lowercased()
        return coins.filter { $0.nameString.lowercased().contains(lowercasedText) || $0.symbolString.lowercased().contains(lowercasedText) }
    }
}
