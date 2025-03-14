//
//  MortgageClaculations.swift
//  Adequate Calc
//
//  Created by Rashmi Liyanawadu on 2025-03-02.
//

import Foundation

struct MortgageCalculation{
    
    static func calculateMonthlyPayment(loanAmount: Double?, rate: Double?, years: Double?, showValidationError: () -> Void, showPositiveValueError: () -> Void) -> Double? {
        // Validate inputs
        guard let loanAmount = loanAmount, let rate = rate, let years = years else {
            showValidationError()
            return nil
        }
        
        // Check for positive values
        if loanAmount <= 0 || rate <= 0 || years <= 0 {
            showPositiveValueError()
            return nil
        }
        
        let monthlyRate = rate / 100 / 12
        let totalPayments = years * 12
        
        // Calculate monthly payment
        let numerator = loanAmount * monthlyRate * pow(1 + monthlyRate, totalPayments)
        let denominator = pow(1 + monthlyRate, totalPayments) - 1
        return numerator / denominator
    }
        
    static func calculateLoanAmount(
        payment: Double?,
        rate: Double?,
        years: Double?,
        showValidationError: () -> Void,
        showPositiveValueError: () -> Void
    ) -> Double? {
        // Validate inputs
        guard let payment = payment, let rate = rate, let years = years else {
            showValidationError()
            return nil
        }
        
        // Check for positive values
        if payment <= 0 || rate <= 0 || years <= 0 {
            showPositiveValueError()
            return nil
        }
        
        let monthlyRate = rate / 100 / 12
        let totalPayments = years * 12
        
        // Avoid division by zero
        if monthlyRate == 0 {
            return payment * totalPayments
        }
        
        let numerator = payment * (1 - pow(1 + monthlyRate, -totalPayments))
        let denominator = monthlyRate
        return numerator / denominator
    }
    
    static func calculateInterestRate(
        loanAmount: Double?,
        payment: Double?,
        years: Double?,
        showValidationError: () -> Void,
        showPositiveValueError: () -> Void
    ) -> Double? {
        
        // Validate inputs
        guard let loanAmount = loanAmount, let payment = payment, let years = years else {
            showValidationError()
            return nil
        }
        
        // Ensure all values are positive
        if loanAmount <= 0 || payment <= 0 || years <= 0 {
            showPositiveValueError()
            return nil
        }
        
        let totalPayments = years * 12
        var low: Double = 0.0
        var high: Double = 1.0  // 100% interest rate as an upper bound
        var guessRate: Double = (low + high) / 2
        let tolerance: Double = 1e-6  // Precision level
        let maxIterations = 100
        var iterations = 0
        
        while iterations < maxIterations {
            let calculatedPayment = (loanAmount * guessRate * pow(1 + guessRate, totalPayments)) / (pow(1 + guessRate, totalPayments) - 1)
            
            if abs(calculatedPayment - payment) < tolerance {
                return guessRate * 12 * 100 // Convert monthly rate to annual percentage
            }
            
            if calculatedPayment > payment {
                high = guessRate
            } else {
                low = guessRate
            }
            
            guessRate = (low + high) / 2
            iterations += 1
        }
        
        return nil
    }

    static func calculateLoanTerm(
        loanAmount: Double?,
        payment: Double?,
        rate: Double?,
        showValidationError: () -> Void,
        showPositiveValueError: () -> Void
    ) -> Double? {
        
        // Validate inputs
        guard let loanAmount = loanAmount, let payment = payment, let rate = rate else {
            showValidationError()
            return nil
        }
        
        // Check for positive values
        if loanAmount <= 0 || payment <= 0 || rate <= 0 {
            showPositiveValueError()
            return nil
        }
        
        let monthlyRate = rate / 100 / 12
        
        // Ensure payment covers at least the interest
        if payment <= loanAmount * monthlyRate {
            showValidationError() 
            return nil
        }
        
        // Calculate loan term in months
        let numerator = log(payment / (payment - loanAmount * monthlyRate))
        let denominator = log(1 + monthlyRate)
        let totalPayments = numerator / denominator
        
        // Convert to years
        return totalPayments / 12
    }

}
