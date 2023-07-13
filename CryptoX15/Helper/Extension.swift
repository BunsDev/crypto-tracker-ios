//
//  Extension.swift
//  Crypto
//
//  Created by CJ on 7/7/23.
//

import Foundation
import SwiftUI

// MARK: Double Extension
extension Double {
    
    /// Returns corresponding color reflecting the gains and losses of stocks/portfolios
    var gainLossColor: Color {
        self < 0 ? .red : .green
    }
    
    /// Converts a double value into a tuple with a scaled value and a corresponding string representation in short scale.
    var inShortScale: (Double, String) {
        switch self {
        case let number where abs(number) >= 1_000_000_000_000:
            return (self / 1_000_000_000_000, " Trillion")
        case let number where abs(number) >= 1_000_000_000:
            return (self / 1_000_000_000, " Billion")
        default:
            return (self, "")
        }
    }
    
    /// Formats a Double value as a currency string with a specified number of decimal places.
    func asCurrencyWithDecimals() -> String {
        let formatter = NumberFormatter()
    //    formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        return "$" + (formatter.string(from: NSNumber(value: self.inShortScale.0)) ?? "") + self.inShortScale.1
    }
    
    /// Formates a Double value as a percentage with 2 decimal places
    func asPercentWith2Decimals() -> String {
        String(format: "%.2f", self) + "%"
    }
    
    /// Formats a Double value as a currency string with a prefix (+ or -) indicating whether the value is positive or negative.
    func asCurrencyWithPrefix() -> String {
        let prefix = self >= 0 ? "+" : ""
        return prefix+self.asCurrencyWithDecimals()
    }
    
    /// Formats a Double value as a percentage with a prefix (+ or -) indicating whether the value is positive or negative.
    func asPercentWithPrefix() -> String {
        let prefix = self >= 0 ? "+" : ""
        return prefix+self.asPercentWith2Decimals()
    }
    
    /// Returns a NumberFormatter object with the number style set to decimal, maximum fraction digits set to 4, and zero symbol set to empty string
    func decimalFormatterForQuantity() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 4
        formatter.zeroSymbol = ""
        return formatter
    }
}

// MARK: String Extension
extension String {
    
    /// Returns a boolean value indicating whether a string matches regex patthern
    func isValidRegex(_ regex: Regex) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex.format)
        return predicate.evaluate(with: self)
    }
    
    /// Converts a string formatted as "yyyy-MM-dd'T'HH:mm:ss.SSSZ" to a Date object
    func asDateFormat() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter.date(from: self) ?? Date()
    }
    
    /// Removes html code in a string
    var removingHTMLOccurances: String {
        self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}

// MARK: CaseIterable Extension
extension CaseIterable where Self: Equatable {
    
    /// Returns the next case of the current case in the enum. If current case is the last one, it returns the first case.
    func next() -> Self {
        let all = Self.allCases
        guard let index = all.firstIndex(of: self) else { return self }
        let next = all.index(after: index)
        return all[next == all.endIndex ? all.startIndex : next]
    }
}


