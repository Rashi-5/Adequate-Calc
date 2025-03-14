//
//  RegularContributionView.swift
//  cw1
//
//  Created by Rashmi Liyanawadu on 2025-03-01.
//

import SwiftUI

struct RegularContributionView: View {
    let title: String
    
    @State private var futureValue: String = ""
    @State private var presentValue: String = ""
    @State private var rate: String = ""
    @State private var numOfPay: String = ""
    @State private var payment: String = ""
    @State private var compoundFrequency: Int = 12
    @State private var paymentTiming: Bool = false
    
    @State private var calculationType: CalculationType = .futureValue
    @State private var showResultSheet: Bool = false

    @State private var result: (value: Double, type: String)?
    @EnvironmentObject var darkModeManager: DarkModeManager
    
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""
    
    enum CalculationType: String, CaseIterable, Identifiable {
        case futureValue = "Target Amount"
        case presentValue = "Initial Investment"
        case rate = "Interest Rate"
        case numOfPay = "Number of Payments"
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
                            CommonTextField(label: "Target Amount ($)", text: $futureValue)
                        }
                        
                        if calculationType != .presentValue {
                            CommonTextField(label: "Initial Investment($)", text: $presentValue)
                        }
                        
                        if calculationType != .rate {
                            CommonTextField(label: "Interest Rate (%)", text: $rate)
                        }
                        
                        if calculationType != .numOfPay {
                            CommonTextField(label: "Number of Payments", text: $numOfPay)
                        }
                        
                        if calculationType != .payment {
                            CommonTextField(label: "Monthly Payment($)", text: $payment)
                        }
                        
                        HStack{
                            Text("Compounding Per Year")
                                .foregroundColor(darkModeManager.isDarkMode ? Color.white : Color.black)

                            Spacer()
                            
                            Picker("", selection: $compoundFrequency) {
                                Text("Monthly").tag(12)
                                Text("Quarterly").tag(4)
                                Text("Annually").tag(1)
                            }
                        }
                        .tint(darkModeManager.isDarkMode ? Color.white : Color.black)
                        .padding(.top, 10)
                        
                        Toggle("Payment Timing \(paymentTiming ? "(Beginning)" : "(End)")", isOn: $paymentTiming)
                            .foregroundColor(darkModeManager.isDarkMode ? Color.white : Color.black)
                            .preferredColorScheme(darkModeManager.isDarkMode ? .dark : .light)
                            .padding(.top, 10)
                        
                    }
        
                    Spacer()
                    
                    CommonButton(label: "Calculate") {
                        calculateMissingValue()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            
//                            if futureValue < presentValue {
//                                showError(.internalError)
//                                return
//                            } else {
                                
                                if let calculatedResult = result, calculatedResult.value >= 0 {
                                    showResultSheet = true
                                } else {
                                    showError(.valueMismatch)
                                }
//                            }
                        }
                                            
                    }
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text(title)
                            .font(.system(size: 26 , weight: .bold))
                            .foregroundColor(darkModeManager.isDarkMode ? Color.white : Color.black)
                            .padding(.top, 20)
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
                ResultView(
                    result: result,
                    chartData: [
                        (type: "Initial Investment", value: Double(presentValue) ?? 0),
                        (type: "Total Amount", value: Double(futureValue) ?? 0),
                        (type: "Interest", value: (Double(futureValue) ?? 0) * (Double(rate) ?? 0) / 100)
                    ],
                    sumData: [
                        (type: "Initial Investment (LKR)", value: Double(presentValue) ?? 0),
                        (type: "Interest (%)", value: Double(rate) ?? 0),
                        (type: "Number of Payments", value: Double(numOfPay) ?? 0),
                        (type: "Total Amount (LKR)", value: Double(futureValue) ?? 0),
                        (type: "Interest Added (LKR)", value: Double(payment) ?? 0),
                        (type: "Compound Frequency", value: Double(compoundFrequency))
                    ]
                )
                .presentationDetents([.fraction(0.9)])
                .presentationDragIndicator(.visible)
            }
        }
    }
    
    private func calculateMissingValue() {
        
        let pv = Double(presentValue)
        let pmt = Double(payment)
        let r = Double(rate)
        let n = Double(numOfPay)
        let cp = Double(compoundFrequency)
        let fv = Double(futureValue)
        let paymentTiming = Bool(paymentTiming)
        
        switch calculationType {
        case .futureValue:
            if let calculatedFV = LoanCalculation.calculateFutureValue(
                presentValue: pv,
                payment: pmt,
                interestRate: r,
                numberOfPayments: n,
                compoundingPeriods: cp,
                paymentTiming: paymentTiming,
                showValidationError: { showError(.validationError) },
                showPositiveValueError: { showError(.positiveValueError) }
            ) {
                result = (calculatedFV, "Target Amount ($)")
                futureValue = String(calculatedFV)
            }
            
        case .presentValue:
            if let calculatedPV = LoanCalculation.calculatePresentValue(
                futureValue: fv,
                payment: pmt,
                interestRate: r,
                numberOfPayments: n,
                compoundingPeriods: cp,
                paymentTiming: paymentTiming,
                showValidationError: {showError(.validationError)} ,
                showPositiveValueError: { showError(.positiveValueError) }
            ) {
                result = (calculatedPV, "Target Amount ($)")
                presentValue = String(calculatedPV)
            }
            
        case .rate:
            if let calculatedRate = LoanCalculation.calculateInterestRate(
                presentValue: pv,
                futureValue: fv,
                numberOfPayments: n,
                compoundingPeriods: cp, monthlyPayment: pmt,
                showValidationError: { showError(.validationError) },
                showPositiveValueError: { showError(.positiveValueError) }
            ) {
                result = (calculatedRate, "Interest Rate ($)")
                rate = String(calculatedRate)
            }
            
        case .numOfPay:
            if let calculatedNofPmt = LoanCalculation.calculateNumberOfPayments(
                presentValue: pv,
                futureValue: fv,
                payment: pmt,
                interestRate: r,
                compoundingPeriods: cp,
                showValidationError: { showError(.validationError) },
                showPositiveValueError: { showError(.positiveValueError) }
            ) {
                result = (calculatedNofPmt, "Number of Payments")
                numOfPay = String(calculatedNofPmt)
            }
        
        case .payment:
            if let calculatedPayment = LoanCalculation.calculatePayment(
                presentValue: pv,
                futureValue: fv,
                interestRate: r,
                numberOfPayments: n,
                compoundingPeriods: cp,
                showValidationError: { showError(.validationError) },
                showPositiveValueError: { showError(.positiveValueError) }
            ) {
                result = (calculatedPayment, "Monthly Payment")
                payment = String(calculatedPayment)
            }
        }
    }
    
    private func showError(_ error: AppError) {
        alertMessage = error.localizedDescription
        showingAlert = true
    }
}

#Preview {
    RegularContributionView(title: "")
        .environmentObject(DarkModeManager())
}
