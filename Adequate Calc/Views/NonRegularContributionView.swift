//
//  NonRegularContributionView.swift
//  cw1
//
//  Created by Rashmi Liyanawadu on 2025-03-01.
//

import SwiftUI

struct NonRegularContributionView: View {
    @State private var futureValue: String = ""
    @State private var rate: String = ""
    @State private var years: String = ""
    @State private var initialInvestment: String = ""
    @State private var compound: String = ""
    @State private var result: (value: Double, type: String)?
    
    @State private var calculationType: CalculationType = .futureValue
    @EnvironmentObject var darkModeManager: DarkModeManager
    
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var showResultSheet: Bool = false

    enum CalculationType: String, CaseIterable, Identifiable {
        case futureValue = "Target Amount"
        case rate = "Interest Rate"
        case years = "Time Period"
        case initialInvestment = "Initial Investment"
        case compound = "Compound Per Year"
        
        var id: String { self.rawValue }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Section {
                        HStack{
                            Text("What to calculate")
                                .foregroundColor(darkModeManager.isDarkMode ? Color.white : Color.black)
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // dropdown for calculation selection
                            Picker("Calculate", selection: $calculationType) {
                                ForEach(CalculationType.allCases) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(darkModeManager.isDarkMode ? Color.white : Color.black)
                        }
                        
                        if calculationType != .futureValue {
                            CommonTextField(label: "Target Amount ($)", text: $futureValue, snackDesc: .constant("The goal amount you want to reach"))
                        }
                        
                        if calculationType != .rate {
                            CommonTextField(label: "Interest Rate (%)", text: $rate, snackDesc: .constant(""))
                        }
                        
                        if calculationType != .years {
                            CommonTextField(label: "Time Period(Years)", text: $years, snackDesc: .constant(""))
                        }
                        
                        if calculationType != .initialInvestment {
                            CommonTextField(label: "Initial Investment($)", text: $initialInvestment, snackDesc: .constant(""))
                        }
                        
                        if calculationType != .compound {
                            CommonTextField(label: "Compound Per Year", text: $compound, snackDesc: .constant("How many times the interest is added to your account in a year"))
                        }
                        
                    }
                    
                    Spacer()
                    
                    CommonButton(label: "Calculate") {
                        calculateMissingValue()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            if let calculatedResult = result, calculatedResult.value >= 0 {
                                showResultSheet = true
                            } else {
                                showError(.valueMismatch)
                            }
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("Fixed Investment")
                            .font(.system(size: 26 , weight: .bold))
                            .padding(.top, 20)
                            .foregroundColor(darkModeManager.isDarkMode ? Color.white : Color.black)
                    }
                }
                .alert("Error Occured!", isPresented: $showingAlert) {
                    Button("Try Again", role: .cancel){}
                } message: {
                    Text(alertMessage)
                }
                .onChange(of: calculationType) { oldValue, newValue in
                    result = nil
                }
            }
            .background(darkModeManager.isDarkMode ? Color.black : Color.white)
            .sheet(isPresented: $showResultSheet) { [result] in
                ResultView(result: result,
                           chartData: [
                            (type: "Initial Value", value: Double(initialInvestment) ?? 0),
                            (type: "Target Amount", value: Double(futureValue) ?? 0),
                            (type: "Interest", value: (Double(futureValue) ?? 0) - (Double(initialInvestment) ?? 0))],
                           sumData: [(type :"Initial Value (LKR)", value: Double(initialInvestment) ?? 0),
                                     (type: "Interest (%)", value: Double(rate) ?? 0),
                                     (type: "Time period (Years)", value: Double(years) ?? 0),
                                     (type: "Total Amount (LKR)", value: Double(futureValue) ?? 0),
                                     (type: "Interest Added (LKR)", value: Double(compound) ?? 0)]
                )
                .presentationDetents([.fraction(0.9)])
                .presentationDragIndicator(.visible)
            }
        }
    }
    
    private func calculateMissingValue() {
        
        // Parse the filled values
        let fv = Double(futureValue)
        let r = Double(rate)
        let t = Double(years)
        let pv = Double(initialInvestment)
        let interestAdded = Double(compound) ?? 0
        
        // Check which value to calculate
        switch calculationType {
        case .futureValue:
            if let calculatedFV = InvestmentCalculation.calculateFutureValue(pv: pv, r: r, t: t, interestAdded: interestAdded, showValidationError: { showError(.validationError) }, showPositiveValueError: { showError(.positiveValueError) }) {
                result = (calculatedFV, "Target Amount ($)")
                futureValue = String(calculatedFV)
            }
            
        case .rate:
            if let calculatedR = InvestmentCalculation.calculateInterestRate(fv: fv, pv: pv, t: t, interestAdded: interestAdded, showValidationError: { showError(.validationError) }, showPositiveValueError: { showError(.positiveValueError) }) {
                result = (calculatedR, "Interest Rate (%)")
                rate = String(calculatedR)
            }
            
        case .years:
            if let calculatedT = InvestmentCalculation.calculateTimePeriod(fv: fv, pv: pv, r: r, interestAdded: interestAdded, showValidationError: { showError(.validationError) }, showPositiveValueError: { showError(.positiveValueError) }) {
                result = (calculatedT, "Time Period (Years)")
                years = (CommonModels.formatYears(calculatedT))
            }
            
        case .initialInvestment:
            if let calculatedPV = InvestmentCalculation.calculatePresentValue(fv: fv, r: r, t: t, interestAdded: interestAdded, showValidationError: { showError(.validationError) }, showPositiveValueError: { showError(.positiveValueError) }) {
                result = (calculatedPV, "Initial Investment ($)")
                initialInvestment = String(calculatedPV)
            }
            
        case .compound:
            if let calculatedInterestAdded = InvestmentCalculation.calculateCoumpound(fv: fv, pv: pv, r: r, t: t, showValidationError: { showError(.validationError) }, showPositiveValueError: { showError(.positiveValueError) }) {
                result = (calculatedInterestAdded, "Compound per year ($)")
                compound = String(calculatedInterestAdded)
            }
        }
    }
    
    private func showError(_ error: AppError) {
        alertMessage = error.localizedDescription
        showingAlert = true
    }
}

#Preview {
    NonRegularContributionView()
        .environmentObject(DarkModeManager())
}
