//
//  InvestmentCalculation.swift
//  cw1
//
//  Created by Rashmi Liyanawadu on 2025-02-23.
//

import Foundation

struct InvestmentCalculation {
    
    static func calculateFutureValue(pv: Double?, r: Double?, t: Double?, interestAdded: Double, showValidationError: () -> Void, showPositiveValueError: () -> Void) -> Double? {
        guard let pv = pv, let r = r, let t = t else {
            showValidationError()
            return nil
        }
        
        // Check for positive values
        if pv <= 0 || r <= 0 || t <= 0 {
            showPositiveValueError()
            return nil
        }
        
        return pv + (pv * (r / 100) * t) + interestAdded
    }
    
    static func calculateInterestRate(fv: Double?, pv: Double?, t: Double?, interestAdded: Double, showValidationError: (AppError) -> Void, showPositiveValueError: () -> Void) -> Double? {
        guard let fv = fv, let pv = pv, let t = t else {
            showValidationError(.validationError)
            return nil
        }
        
        // Check for positive values
        if fv <= 0 || pv <= 0 || t <= 0 {
            showPositiveValueError()
            return nil
        }
        
        // Check if the payment is enough to cover principal and added interest
        if fv < pv + interestAdded {
            showValidationError(.insufficientDataError)
            return nil
        }
        
        return ((fv - pv - interestAdded) / (pv * t)) * 100
    }
    
    static func calculateTimePeriod(fv: Double?, pv: Double?, r: Double?, interestAdded: Double, showValidationError: () -> Void, showPositiveValueError: () -> Void) -> Double? {
        guard let fv = fv, let pv = pv, let r = r else {
            showValidationError()
            return nil
        }
        
        // Check for positive values
        if fv <= 0 || pv <= 0 || r <= 0 {
            showPositiveValueError()
            return nil
        }
        
        return (fv - pv - interestAdded) / (pv * (r / 100))
    }
    
    static func calculatePresentValue(fv: Double?, r: Double?, t: Double?, interestAdded: Double, showValidationError: () -> Void, showPositiveValueError: () -> Void) -> Double? {
        guard let fv = fv, let r = r, let t = t else {
            showValidationError()
            return nil
        }
        
        // Check for positive values
        if fv <= 0 || r <= 0 || t <= 0 || interestAdded < 0 {
            showPositiveValueError()
            return nil
        }
        
        return (fv - interestAdded) / (1 + (r / 100) * t)
    }
    
    static func calculateCoumpound(fv: Double?, pv: Double?, r: Double?, t: Double?, showValidationError: () -> Void, showPositiveValueError: () -> Void) -> Double? {
        guard let fv = fv, let pv = pv, let r = r, let t = t else {
            showValidationError()
            return nil
        }
        
        // Check for positive values
        if fv <= 0 || pv <= 0 || r <= 0 || t <= 0 {
            showPositiveValueError()
            return nil
        }
        
        // interestAdded = FV - PV - (PV * r * t)
        return fv - pv - (pv * (r / 100) * t)
    }
    
    
}

