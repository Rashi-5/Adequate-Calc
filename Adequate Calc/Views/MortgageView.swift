//
//  MorgageView.swift
//  Adequate Calc
//
//  Created by Rashmi Liyanawadu on 2025-03-02.
//

import SwiftUI

import SwiftUI

struct MortgageView: View {
    @State private var loanAmount: String = ""
    @State private var rate: String = ""
    @State private var years: String = ""
    @State private var payment: String = ""
    @State private var result: (value: Double, type: String)?
    
    @State private var calculationType: CalculationType = .payment
    @EnvironmentObject var darkModeManager: DarkModeManager
    
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var showResultSheet: Bool = false
    
    // enum for calculation types
    enum CalculationType: String, CaseIterable, Identifiable {
        case loanAmount = "Loan Amount"
        case rate = "Interest Rate"
        case years = "Time Period"
        case payment = "Monthly Payment"
        
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
                            
                            // calculation selection
                            Picker("Calculate", selection: $calculationType) {
                                ForEach(CalculationType.allCases) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(darkModeManager.isDarkMode ? Color.white : Color.black)
                        }
                        
                        if calculationType != .loanAmount {
                            CommonTextField(label: "Loan Amount ($)", text: $loanAmount)
                        }
                        
                        if calculationType != .rate {
                            CommonTextField(label: "Interest Rate (%)", text: $rate)
                        }
                        
                        if calculationType != .years {
                            CommonTextField(label: "Time Period (Years)", text: $years)
                        }
                        
                        if calculationType != .payment {
                            CommonTextField(label: "Monthly Payment ($)", text: $payment)
                        }
                        
                    }
                    
                    Spacer()
                    
                    CommonButton(label: "Calculate") {
                        calculateMortgageValue()
                        
                        if let calculatedResult = result, calculatedResult.value >= 0 {
                                DispatchQueue.main.async {
                                    showResultSheet = true
                                }
                            } else {
                                showError(.valueMismatch)
                            }
                    }
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("Mortgage Loans")
                            .font(.system(size: 26 , weight: .bold))
                            .foregroundColor(darkModeManager.isDarkMode ? Color.white : Color.black)
                            .padding(.top, 20)
                    }
                }
                .alert("Error Occured!", isPresented: $showingAlert) {
                    Button("Try Again", role: .cancel){}
                } message: {
                    Text(alertMessage)
                        .foregroundColor(Color.red)
                }
                .onChange(of: calculationType) {
                    result = nil
                }
            }.background(darkModeManager.isDarkMode ? Color.black : Color.white)
                .sheet(isPresented: $showResultSheet) { [result] in
                    ResultView(result: result,
                               chartData: [
                                (type: "Loan Amount", value: Double(loanAmount) ?? 0),
                                (type: "Interest", value: (Double(loanAmount) ?? 0) * (Double(rate) ?? 0) / 100)],
                               sumData: [(type :"Loan amount ($)", value: Double(loanAmount) ?? 0),
                                        (type: "Interest (%)", value: Double(rate) ?? 0),
                                        (type: "Time period (Years)", value: Double(years) ?? 0),
                                        (type: "Monthly payment ($)", value: Double(payment) ?? 0)]
                    )
                    .presentationDetents([.fraction(0.9)])
                    .presentationDragIndicator(.visible)
                }
        }
    }
    
    private func calculateMortgageValue() {
        
        let loanAmountValue = Double(loanAmount)
        let rateValue = Double(rate)
        let yearsValue = Double(years)
        let paymentValue = Double(payment)
                
        switch calculationType {
        case .loanAmount:
            if let calculatedLoanAmount = MortgageCalculation.calculateLoanAmount(
                payment: paymentValue,
                rate: rateValue,
                years: yearsValue,
                showValidationError: { showError(.validationError) },
                showPositiveValueError: { showError(.positiveValueError) }
            ) {
                result = (calculatedLoanAmount, "Loan Amount ($)")
                loanAmount = String(format: "%.2f", calculatedLoanAmount)        }
            
        case .rate:
            if let calculatedRate = MortgageCalculation.calculateInterestRate(
                loanAmount: loanAmountValue,
                payment: paymentValue,
                years: yearsValue,
                showValidationError: { showError(.validationError) },
                showPositiveValueError: { showError(.positiveValueError) }
            ) {
                result = (calculatedRate, "Interest Rate (%)")
                rate = String(format: "%.2f", calculatedRate)
            }
        case .years:
            if let calculatedYears = MortgageCalculation.calculateLoanTerm(
                loanAmount: loanAmountValue,
                payment: paymentValue,
                rate: rateValue,
                showValidationError: { showError(.validationError) },
                showPositiveValueError: { showError(.positiveValueError) }
            ) {
                result = (calculatedYears, "Time Period (Years)")
                years = (CommonModels.formatYears(calculatedYears))
            }
            
        case .payment:
            if let calculatedPayment = MortgageCalculation.calculateMonthlyPayment(
                loanAmount: loanAmountValue,
                rate: rateValue,
                years: yearsValue,
                showValidationError: { showError(.validationError) },
                showPositiveValueError: { showError(.positiveValueError) }
            ) {
                result = (calculatedPayment, "Monthly Payment ($)")
                payment = String(format: "%.2f", calculatedPayment)
            }

        }
    }

    private func showError(_ error: AppError) {
        alertMessage = error.localizedDescription
        showingAlert = true
    }
}

#Preview {
    MortgageView()
        .environmentObject(DarkModeManager())
}
