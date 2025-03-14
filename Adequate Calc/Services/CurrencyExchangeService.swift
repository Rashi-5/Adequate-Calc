//
//  CurrencyExchangeService.swift
//  Adequate Calc
//
//  Created by Rashmi Liyanawadu on 2025-03-09.
//

import Foundation

// currency-exchange-service.js

import Foundation

// Model for exchange rate data
struct ExchangeRateResponse: Codable {
    let base: String
    let date: String
    let rates: [String: Double]
}

class CurrencyExchangeService {
    
    private let apiKey = "fa79afdb00d268135968228652884c6c"
    private let baseURL = "https://api.exchangerate-api.com/v4/latest/"
    
    func fetchExchangeRates(baseCurrency: String = "USD") async throws -> ExchangeRateResponse {
        guard let url = URL(string: "\(baseURL)\(baseCurrency)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(ExchangeRateResponse.self, from: data)
    }
}
