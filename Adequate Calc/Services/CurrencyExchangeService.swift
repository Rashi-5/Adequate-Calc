//
//  CurrencyExchangeService.swift
//  Adequate Calc
//
//  Created by Rashmi Liyanawadu on 2025-03-09.
//

import Foundation


class CurrencyExchangeService {
    
    private let apiKey = APIConfig.apiKey
    private let baseURL = APIConfig.baseURL
    
    func fetchExchangeRates(baseCurrency: String = "USD") async throws -> ExchangeRateResponse {
        guard let url = URL(string: "\(baseURL)\(baseCurrency)") else {
            throw CurrencyExchangeError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw CurrencyExchangeError.requestFailed
        }
        
        if httpResponse.statusCode != 200 {
            throw CurrencyExchangeError.serverError(httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(ExchangeRateResponse.self, from: data)
        } catch {
            throw CurrencyExchangeError.decodingFailed
        }
    }
}
