//
//  Savings_Tests.swift
//  Adequate CalcTests
//
//  Created by Rashmi Liyanawadu on 2025-03-16.
//

import Testing
@testable import Adequate_Calc

struct Savings_Tests {

    @Test func testCalculateFutureValue_InvalidInputs_ShouldTriggerValidationError() async throws {
        let pv: Double? = nil
        let r: Double? = 5.0
        let t: Double? = 10.0
        let interestAdded: Double = 100.0

        var validationErrorCalled = false
        var positiveValueErrorCalled = false

        let result = InvestmentCalculation.calculateFutureValue(
            pv: pv,
            r: r,
            t: t,
            interestAdded: interestAdded,
            showValidationError: { validationErrorCalled = true },
            showPositiveValueError: { positiveValueErrorCalled = true }
        )

        #expect(result == nil)
        #expect(validationErrorCalled == true)
        #expect(positiveValueErrorCalled == false)  
    }

    @Test func testCalculateFutureValue_ZeroValue_ShouldTriggerPositiveValueError() async throws {
        let pv: Double = 0.0
        let r: Double = 5.0
        let t: Double = 10.0
        let interestAdded: Double = 100.0

        var validationErrorCalled = false
        var positiveValueErrorCalled = false

        let result = InvestmentCalculation.calculateFutureValue(
            pv: pv,
            r: r,
            t: t,
            interestAdded: interestAdded,
            showValidationError: { validationErrorCalled = true },
            showPositiveValueError: { positiveValueErrorCalled = true }
        )

        #expect(result == nil)
        #expect(validationErrorCalled == false)
        #expect(positiveValueErrorCalled == true)
    }

    @Test func testCalculateFutureValue_ValidInputs_ShouldReturnCorrectFutureValue() async throws {
        let pv: Double = 1000.0
        let r: Double = 5.0
        let t: Double = 10.0
        let interestAdded: Double = 200.0

        var validationErrorCalled = false
        var positiveValueErrorCalled = false

        let result = InvestmentCalculation.calculateFutureValue(
            pv: pv,
            r: r,
            t: t,
            interestAdded: interestAdded,
            showValidationError: { validationErrorCalled = true },
            showPositiveValueError: { positiveValueErrorCalled = true }
        )

        #expect(result == 1700.0)
        #expect(validationErrorCalled == false)
        #expect(positiveValueErrorCalled == false)
    }

    @Test func testCalculateFutureValue_NegativeValue_ShouldTriggerPositiveValueError() async throws {
        let pv: Double = -1000.0  // Negative present value
        let r: Double = 5.0
        let t: Double = 10.0
        let interestAdded: Double = 200.0

        var validationErrorCalled = false
        var positiveValueErrorCalled = false

        let result = InvestmentCalculation.calculateFutureValue(
            pv: pv,
            r: r,
            t: t,
            interestAdded: interestAdded,
            showValidationError: { validationErrorCalled = true },
            showPositiveValueError: { positiveValueErrorCalled = true }
        )

        #expect(result == nil)
        #expect(validationErrorCalled == false)
        #expect(positiveValueErrorCalled == true)
    }

    @Test func testCalculateInterestRate_ShouldCalculateCorrectRate() async throws {
        let fv: Double = 1700.0
        let pv: Double = 1000.0
        let t: Double = 10.0
        let interestAdded: Double = 200.0

        var validationErrorCalled = false
        var positiveValueErrorCalled = false

        let result = InvestmentCalculation.calculateInterestRate(
            fv: fv,
            pv: pv,
            t: t,
            interestAdded: interestAdded,
            showValidationError: { _ in validationErrorCalled = true },
            showPositiveValueError: { positiveValueErrorCalled = true }
        )

        #expect(result != nil)
        #expect(validationErrorCalled == false)
        #expect(positiveValueErrorCalled == false)
        #expect(result == 5.0) // Expected rate based on the formula
    }
    @Test func testCalculateInterestRate_ShouldTriggerValidationErrorForNilInputs() async throws {
        let fv: Double? = nil
        let pv: Double = 1000.0
        let t: Double = 10.0
        let interestAdded: Double = 200.0

        var validationErrorCalled = false
        var positiveValueErrorCalled = false

        let result = InvestmentCalculation.calculateInterestRate(
            fv: fv,
            pv: pv,
            t: t,
            interestAdded: interestAdded,
            showValidationError: { _ in validationErrorCalled = true },
            showPositiveValueError: { positiveValueErrorCalled = true }
        )

        #expect(result == nil)
        #expect(validationErrorCalled == true)  // Expect validation error due to nil value
        #expect(positiveValueErrorCalled == false)
    }
    @Test func testCalculateInterestRate_ShouldTriggerPositiveValueErrorForNegativeValues() async throws {
        let fv: Double = -1700.0 // Invalid negative value
        let pv: Double = 1000.0
        let t: Double = 10.0
        let interestAdded: Double = 200.0

        var validationErrorCalled = false
        var positiveValueErrorCalled = false

        let result = InvestmentCalculation.calculateInterestRate(
            fv: fv,
            pv: pv,
            t: t,
            interestAdded: interestAdded,
            showValidationError: { _ in validationErrorCalled = true },
            showPositiveValueError: { positiveValueErrorCalled = true }
        )

        #expect(result == nil)
        #expect(validationErrorCalled == false)
        #expect(positiveValueErrorCalled == true)  // Expect positive value error due to negative FV
    }
    
    @Test func testCalculateInterestRate_ShouldTriggerValidationErrorForLowPayment() async throws {
        let fv: Double = 500.0  // Payment not enough to cover the interest
        let pv: Double = 1000.0
        let t: Double = 10.0
        let interestAdded: Double = 200.0

        var validationErrorCalled = false
        var positiveValueErrorCalled = false

        let result = InvestmentCalculation.calculateInterestRate(
            fv: fv,
            pv: pv,
            t: t,
            interestAdded: interestAdded,
            showValidationError: { _ in validationErrorCalled = true },
            showPositiveValueError: { positiveValueErrorCalled = true }
        )

        #expect(result == nil)
        #expect(validationErrorCalled == true)  // Expect validation error due to insufficient payment
        #expect(positiveValueErrorCalled == false)
    }
    
    @Test func testCalculateInterestRate_ShouldTriggerPositiveValueErrorForZeroValues() async throws {
        let fv: Double = 0.0
        let pv: Double = 0.0
        let t: Double = 0.0
        let interestAdded: Double = 0.0

        var validationErrorCalled = false
        var positiveValueErrorCalled = false

        let result = InvestmentCalculation.calculateInterestRate(
            fv: fv,
            pv: pv,
            t: t,
            interestAdded: interestAdded,
            showValidationError: { _ in validationErrorCalled = true },
            showPositiveValueError: { positiveValueErrorCalled = true }
        )

        #expect(result == nil)
        #expect(validationErrorCalled == false)
        #expect(positiveValueErrorCalled == true)  // Expect positive value error for zero values
    }

    @Test func testCalculateTimePeriod_ShouldCalculateCorrectTimePeriod() async throws {
        let fv: Double = 1700.0
        let pv: Double = 1000.0
        let r: Double = 5.0
        let interestAdded: Double = 200.0

        var validationErrorCalled = false
        var positiveValueErrorCalled = false

        let result = InvestmentCalculation.calculateTimePeriod(
            fv: fv,
            pv: pv,
            r: r,
            interestAdded: interestAdded,
            showValidationError: { validationErrorCalled = true },
            showPositiveValueError: { positiveValueErrorCalled = true }
        )

        #expect(result != nil)
        #expect(validationErrorCalled == false)
        #expect(positiveValueErrorCalled == false)
        #expect(result == 10.0)
    }
    
    @Test func testCalculateTimePeriod_ShouldTriggerPositiveValueErrorForZeroInterestRate() async throws {
        let fv: Double = 1700.0
        let pv: Double = 1000.0
        let r: Double = 0.0 // Zero interest rate
        let interestAdded: Double = 200.0

        var validationErrorCalled = false
        var positiveValueErrorCalled = false

        let result = InvestmentCalculation.calculateTimePeriod(
            fv: fv,
            pv: pv,
            r: r,
            interestAdded: interestAdded,
            showValidationError: { validationErrorCalled = true },
            showPositiveValueError: { positiveValueErrorCalled = true }
        )

        #expect(result == nil)
        #expect(validationErrorCalled == false)
        #expect(positiveValueErrorCalled == true)  // Expect positive value error due to zero interest rate
    }

    @Test func testCalculateTimePeriod_ShouldTriggerPositiveValueErrorForZeroValues() async throws {
        let fv: Double = 0.0
        let pv: Double = 0.0
        let r: Double = 0.0
        let interestAdded: Double = 0.0

        var validationErrorCalled = false
        var positiveValueErrorCalled = false

        let result = InvestmentCalculation.calculateTimePeriod(
            fv: fv,
            pv: pv,
            r: r,
            interestAdded: interestAdded,
            showValidationError: { validationErrorCalled = true },
            showPositiveValueError: { positiveValueErrorCalled = true }
        )

        #expect(result == nil)
        #expect(validationErrorCalled == false)
        #expect(positiveValueErrorCalled == true)  // Expect positive value error for zero values
    }

    @Test func testCalculateTimePeriod_ShouldHandleLargeValues() async throws {
        let fv: Double = 1000000.0
        let pv: Double = 500000.0
        let r: Double = 5.0
        let interestAdded: Double = 100000.0

        var validationErrorCalled = false
        var positiveValueErrorCalled = false

        let result = InvestmentCalculation.calculateTimePeriod(
            fv: fv,
            pv: pv,
            r: r,
            interestAdded: interestAdded,
            showValidationError: { validationErrorCalled = true },
            showPositiveValueError: { positiveValueErrorCalled = true }
        )

        #expect(result != nil)
        #expect(validationErrorCalled == false)
        #expect(positiveValueErrorCalled == false)
        #expect(result == 16.0)
    }

    @Test func testCalculatePresentValue_ValidInputs() async throws {
        let fv: Double = 1000000.0
        let r: Double = 5.0
        let t: Double = 10.0
        let interestAdded: Double = 200000.0

        var validationErrorCalled = false
        var positiveValueErrorCalled = false

        let result = InvestmentCalculation.calculatePresentValue(
            fv: fv,
            r: r,
            t: t,
            interestAdded: interestAdded,
            showValidationError: { validationErrorCalled = true },
            showPositiveValueError: { positiveValueErrorCalled = true }
        )

        #expect(result != nil)
        #expect(validationErrorCalled == false)
        #expect(positiveValueErrorCalled == false)

        let expectedPV = (fv - interestAdded) / (1 + (r / 100) * t)
        #expect(result == expectedPV)
    }

    @Test func testCalculatePresentValue_InsufficientData_ShouldTriggerValidationError() async throws {
        let fv: Double = 1000000.0
        let r: Double = 5.0
        let t: Double = 10.0
        let interestAdded: Double = 200000.0

        var validationErrorCalled = false
        var positiveValueErrorCalled = false

        let result = InvestmentCalculation.calculatePresentValue(
            fv: fv,
            r: r,
            t: nil,  // Missing time period
            interestAdded: interestAdded,
            showValidationError: { validationErrorCalled = true },
            showPositiveValueError: { positiveValueErrorCalled = true }
        )

        #expect(result == nil)
        #expect(validationErrorCalled == true)
        #expect(positiveValueErrorCalled == false)
    }

    @Test func testCalculatePresentValue_NegativeValue_ShouldTriggerPositiveValueError() async throws {
        let fv: Double = 1000000.0
        let r: Double = 5.0
        let t: Double = 10.0
        let interestAdded: Double = -200000.0  // Invalid interestAdded value

        var validationErrorCalled = false
        var positiveValueErrorCalled = false

        let result = InvestmentCalculation.calculatePresentValue(
            fv: fv,
            r: r,
            t: t,
            interestAdded: interestAdded,
            showValidationError: { validationErrorCalled = true },
            showPositiveValueError: { positiveValueErrorCalled = true }
        )

        #expect(result == nil)
        #expect(validationErrorCalled == false)
        #expect(positiveValueErrorCalled == true)  
    }

    @Test func testCalculatePresentValue_ZeroValues_ShouldTriggerPositiveValueError() async throws {
        let fv: Double = 1000000.0
        let r: Double = 0.0  // Invalid interest rate
        let t: Double = 10.0
        let interestAdded: Double = 200000.0

        var validationErrorCalled = false
        var positiveValueErrorCalled = false

        let result = InvestmentCalculation.calculatePresentValue(
            fv: fv,
            r: r,
            t: t,
            interestAdded: interestAdded,
            showValidationError: { validationErrorCalled = true },
            showPositiveValueError: { positiveValueErrorCalled = true }
        )

        #expect(result == nil)
        #expect(validationErrorCalled == false)
        #expect(positiveValueErrorCalled == true)
    }

    @Test func testCalculateCompound_ValidInputs() async throws {
        let fv: Double = 1000000.0
        let pv: Double = 500000.0
        let r: Double = 5.0
        let t: Double = 10.0

        var validationErrorCalled = false
        var positiveValueErrorCalled = false

        let result = InvestmentCalculation.calculateCoumpound(
            fv: fv,
            pv: pv,
            r: r,
            t: t,
            showValidationError: { validationErrorCalled = true },
            showPositiveValueError: { positiveValueErrorCalled = true }
        )

        #expect(result != nil)
        #expect(validationErrorCalled == false)
        #expect(positiveValueErrorCalled == false)

        let expectedInterestAdded = fv - pv - (pv * (r / 100) * t)
        #expect(result == expectedInterestAdded)
    }

    @Test func testCalculateCompound_MissingFV_ShouldTriggerValidationError() async throws {
        let fv: Double? = nil
        let pv: Double = 500000.0
        let r: Double = 5.0
        let t: Double = 10.0

        var validationErrorCalled = false
        var positiveValueErrorCalled = false

        let result = InvestmentCalculation.calculateCoumpound(
            fv: fv,
            pv: pv,
            r: r,
            t: t,
            showValidationError: { validationErrorCalled = true },
            showPositiveValueError: { positiveValueErrorCalled = true }
        )

        #expect(result == nil)
        #expect(validationErrorCalled == true)
        #expect(positiveValueErrorCalled == false)
    }

    @Test func testCalculateCompound_NegativeValue_ShouldTriggerPositiveValueError() async throws {
        let fv: Double = 1000000.0
        let pv: Double = 500000.0
        let r: Double = 5.0
        let t: Double = -10.0  // Invalid negative time period

        var validationErrorCalled = false
        var positiveValueErrorCalled = false

        let result = InvestmentCalculation.calculateCoumpound(
            fv: fv,
            pv: pv,
            r: r,
            t: t,
            showValidationError: { validationErrorCalled = true },
            showPositiveValueError: { positiveValueErrorCalled = true }
        )

        #expect(result == nil)
        #expect(validationErrorCalled == false)
        #expect(positiveValueErrorCalled == true)
    }

    @Test func testCalculateCompound_ZeroValue_ShouldTriggerPositiveValueError() async throws {
        let fv: Double = 1000000.0
        let pv: Double = 500000.0
        let r: Double = 0.0  // Invalid zero interest rate
        let t: Double = 10.0

        var validationErrorCalled = false
        var positiveValueErrorCalled = false

        let result = InvestmentCalculation.calculateCoumpound(
            fv: fv,
            pv: pv,
            r: r,
            t: t,
            showValidationError: { validationErrorCalled = true },
            showPositiveValueError: { positiveValueErrorCalled = true }
        )

        #expect(result == nil)
        #expect(validationErrorCalled == false)
        #expect(positiveValueErrorCalled == true)
    }

}
