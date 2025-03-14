//
//  CurrencyExchangeView.swift
//  Adequate Calc
//
//  Created by Rashmi Liyanawadu on 2025-03-09.
//

import SwiftUI

struct CurrencyExchangeView: View {
    @State private var exchangeRates: ExchangeRateResponse?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var baseCurrency = "USD"
    @State private var searchText = ""
    @EnvironmentObject var darkModeManager: DarkModeManager

    private let currencyService = CurrencyExchangeService()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                
                Text("Exchange Rates")
                    .font(.title)
                    .bold()
                    .padding()
                
                // Search bar
                TextField("Search Currency", text: $searchText)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 10)
                
                if isLoading {
                    ProgressView()
                        .padding()
                } else if let errorMessage = errorMessage {
                    VStack {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                        Button("Retry") {
                            fetchRates()
                        }
                        .padding()
                    }
                } else if let rates = exchangeRates {
                    HStack {
                        Text("Currency")
                            .font(.headline)
                            .frame(width: UIScreen.main.bounds.width * 0.8, alignment: .leading)
                        Text("Rate")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(darkModeManager.isDarkMode ? Color.black : Color(.systemGray5))
                    .foregroundColor(darkModeManager.isDarkMode ? .white : .black)
                    
                    // Exchange rates list
                    List {
                        Section(header: Text("Updated: \(rates.date)")) {
                            ForEach(filteredRates(rates), id: \.key) { currency, rate in
                                HStack {
                                    Text(currency)
                                        .frame(width: UIScreen.main.bounds.width * 0.6, alignment: .leading)
                                    Spacer()
                                    Text(String(format: "%.2f", rate))
                                }
                                .contentShape(Rectangle())
                                .listRowBackground(darkModeManager.isDarkMode ? Color.black : Color.white)
                            }
                        }
                    }
                    .foregroundColor(darkModeManager.isDarkMode ? .white : .black)
                    .listStyle(PlainListStyle())
                }
                else {
                    VStack {
                        Text("No data available")
                        Button("Fetch Rates") {
                            fetchRates()
                        }
                        .padding()
                    }
                    .foregroundColor(darkModeManager.isDarkMode ? .white : .black)
                }
            }
            .toolbar {
                Button(action: fetchRates) {
                    Image(systemName: "arrow.clockwise")
                }
            }
            .foregroundStyle(darkModeManager.isDarkMode ? Color.white : Color.black)
            .background(darkModeManager.isDarkMode ? Color.black : Color.white)
            .onAppear {
                fetchRates()
            }
        }
    }
    
    // Filter rates based on search text
    private func filteredRates(_ rates: ExchangeRateResponse) -> [(key: String, value: Double)] {
        let sortedRates = rates.rates.sorted { $0.key < $1.key }
        if searchText.isEmpty {
            return sortedRates
        } else {
            return sortedRates.filter { $0.key.contains(searchText.uppercased()) }
        }
    }
    
    // Fetch exchange rates
    private func fetchRates() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let result = try await currencyService.fetchExchangeRates(baseCurrency: baseCurrency)
                DispatchQueue.main.async {
                    self.exchangeRates = result
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}

#Preview {
    CurrencyExchangeView()
        .environmentObject(DarkModeManager())
}
