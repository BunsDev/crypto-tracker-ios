//
//  APIService.swift
//  CryptoX15
//
//  Created by CJ on 7/13/23.
//

import Foundation

/// An enumeration that represents various network-related errors.
enum CoinError: Error {
    case invalidURL
    case invalidHTTPResponse
}

/// An extension of NetworkError that provides localized descriptions for the errors.
extension CoinError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            NSLocalizedString("The URL provided is not valid. Please check that you have entered the correct URL and try again.", comment: "")
        case .invalidHTTPResponse:
            NSLocalizedString("The server returned an unexpected response. Please try again later or contact the server administrator.", comment: "")
        }
    }
}

/// A class provides method for downloading data from a REST API
final class APIService {
    
    /// Downloads data from a given specified URL using an asynchronous operation.
    /// - Parameter url: The URL to download the data from.
    /// - Returns: The downloaded data.
    static func downloadData(from url: String) async throws -> Data {
        guard let url = URL(string: url) else { throw CoinError.invalidURL }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw CoinError.invalidHTTPResponse
        }
        return data
    }
}
