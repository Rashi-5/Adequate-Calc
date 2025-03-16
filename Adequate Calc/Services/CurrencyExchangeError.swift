//
//  CurrencyExchangeError.swift
//  Adequate Calc
//
//  Created by Rashmi Liyanawadu on 2025-03-16.
//

import Foundation

struct ExchangeRateResponse: Codable {
    let base: String
    let date: String
    let rates: [String: Double]
}

enum CurrencyExchangeError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
    case serverError(Int)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL. Please check the API endpoint."
        case .requestFailed:
            return "Failed to fetch exchange rates. Please try again later."
        case .decodingFailed:
            return "Failed to parse exchange rate data."
        case .serverError(let code):
            return "Server responded with an error (Code: \(code))."
        }
    }
}
