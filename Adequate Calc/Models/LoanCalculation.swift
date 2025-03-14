//
//  LoanCalculation.swift
//  Adequate Calc
//
//  Created by Rashmi Liyanawadu on 2025-03-04.
//

import Foundation

struct LoanCalculation{
    
    static func calculateFutureValue(
        presentValue: Double?,
        payment: Double?,
        interestRate: Double?,
        numberOfPayments: Double?,
        compoundingPeriods: Double?,
        paymentTiming: Bool,
        showValidationError: () -> Void,
        showPositiveValueError: () -> Void
    ) -> Double? {
        // Guard let to ensure all required values are provided
        guard let pv = presentValue,
              let pmt = payment,
              let r = interestRate,
              let n = numberOfPayments,
              let cp = compoundingPeriods else {
            showValidationError() // Show error if any value is missing
            return nil
        }
        
        // Check for positive values
        if pv <= 0 || pmt <= 0 || r <= 0 || n <= 0 || cp <= 0 {
            showPositiveValueError() // Show error if any value is non-positive
            return nil
        }
        
        // Perform the calculation
        let rDecimal = r / 100
        let t = n / cp
        
        let futureValueEnd = pv * pow(1 + rDecimal / cp, cp * t) + pmt * (pow(1 + rDecimal / cp, cp * t) - 1) / (rDecimal / cp)
        
        // Adjust for payment timing (beginning or end of period)
        switch paymentTiming {
        case false:
            return futureValueEnd
        case true:
            return futureValueEnd * (1 + rDecimal / cp)
        }
    }
    
    static func calculatePresentValue(
        futureValue: Double?,
        payment: Double?,
        interestRate: Double?,
        numberOfPayments: Double?,
        compoundingPeriods: Double?,
        paymentTiming: Bool,
        showValidationError: () -> Void,
        showPositiveValueError: () -> Void
    ) -> Double? {
        // Guard let to ensure all required values are provided
        guard let fv = futureValue,
              let pmt = payment,
              let r = interestRate,
              let n = numberOfPayments,
              let cp = compoundingPeriods else {
            showValidationError() // Show error if any value is missing
            return nil
        }
        
        // Check for positive values
        if fv <= 0 || pmt <= 0 || r <= 0 || n <= 0 || cp <= 0 {
            showPositiveValueError() // Show error if any value is non-positive
            return nil
        }
        
        // Perform the calculation
        let rDecimal = r / 100
        let t = n / cp
        
        // Calculate the present value
        let numerator = fv - pmt * (pow(1 + rDecimal / cp, cp * t) - 1) / (rDecimal / cp)
        let denominator = pow(1 + rDecimal / cp, cp * t)
        
        let presentValue = numerator / denominator
        
        // Adjust for payment timing (beginning or end of period)
        switch paymentTiming {
        case false:
            return presentValue
        case true:
            return presentValue / (1 + rDecimal / cp)
        }
    }
    
    static func calculateInterestRate(
        presentValue: Double?,
        futureValue: Double?,
        numberOfPayments: Double?,
        compoundingPeriods: Double?,
        monthlyPayment: Double?,
        showValidationError: () -> Void,
        showPositiveValueError: () -> Void
    ) -> Double? {
        // Ensure all values are present
        guard let pv = presentValue,
              let fv = futureValue,
              let n = numberOfPayments,
              let cp = compoundingPeriods,
              let pmt = monthlyPayment else {
            showValidationError()
            return nil
        }

        // Ensure all values are positive
        if pv <= 0 || fv <= 0 || n <= 0 || cp <= 0 || pmt <= 0 {
            showPositiveValueError()
            return nil
        }

        let t = n / cp  // Convert months to years
        let guessRate = 0.05  // Initial guess (5% annual rate)

        // Function to solve
        func equation(rate: Double) -> Double {
            let r = rate / cp  // Convert annual rate to periodic rate
            return pv * pow(1 + r, cp * t) + pmt * ((pow(1 + r, cp * t) - 1) / r) - fv
        }

        // Use numerical solver (Newton’s method)
        var rate = guessRate
        for _ in 0..<1000 {
            let fValue = equation(rate: rate)
            let derivative = (equation(rate: rate + 1e-6) - fValue) / 1e-6  // Approximate derivative
            if abs(fValue) < 1e-6 { break }  // Convergence check
            rate -= fValue / derivative  // Newton-Raphson step
        }

        return rate * 100  // Convert to percentage
    }

    static func calculateNumberOfPayments(
        presentValue: Double?,
        futureValue: Double?,
        payment: Double?,
        interestRate: Double?,
        compoundingPeriods: Double?,
        showValidationError: () -> Void,
        showPositiveValueError: () -> Void
    ) -> Double? {
        // Ensure all values are present
        guard let pv = presentValue,
              let fv = futureValue,
              let pmt = payment,
              let r = interestRate,
              let cp = compoundingPeriods else {
            showValidationError()
            return nil
        }

        // Ensure all values are positive
        if pv <= 0 || fv <= 0 || pmt <= 0 || r <= 0 || cp <= 0 {
            showPositiveValueError()
            return nil
        }

        let rDecimal = r / 100.0  // Convert interest rate to decimal
        let periodicRate = rDecimal / cp  // Convert to periodic interest rate

        // Check if denominator is zero to avoid division errors
        if periodicRate == 0 {
            return nil
        }

        // Calculate number of payments
        let numerator = log((fv * periodicRate + pmt) / (pv * periodicRate + pmt))
        let denominator = cp * log(1 + periodicRate)
        let numberOfPayments = numerator / denominator

        return numberOfPayments
    }
                 
    static func calculatePayment(
        presentValue: Double?,
        futureValue: Double?,
        interestRate: Double?,
        numberOfPayments: Double?,
        compoundingPeriods: Double?,
        showValidationError: () -> Void,
        showPositiveValueError: () -> Void
    ) -> Double? {
        // Guard let to ensure all required values are provided
        guard let pv = presentValue,
              let fv = futureValue,
              let r = interestRate,
              let n = numberOfPayments,
              let cp = compoundingPeriods else {
            showValidationError() // Show error if any value is missing
            return nil
        }
        
        // Check for positive values
        if pv <= 0 || fv <= 0 || r <= 0 || n <= 0 || cp <= 0 {
            showPositiveValueError() // Show error if any value is non-positive
            return nil
        }
        
        // Perform the calculation
        let rDecimal = r / 100
        let t = n / cp // Total time in years
        
        let numerator = fv - pv * pow(1 + rDecimal / cp, cp * t)
        let denominator = (pow(1 + rDecimal / cp, cp * t) - 1) / (rDecimal / cp)
        
        let payment = numerator / denominator
        
        return payment
    }
    
}

