//
//  Adequate_CalcTests.swift
//  Adequate CalcTests
//
//  Created by Rashmi Liyanawadu on 2025-03-02.
//

import Testing
@testable import Adequate_Calc

struct Adequate_CalcTests {

    // format years
    @Test func testFormatYears() async throws {
           
            #expect(CommonModels.formatYears(2.0) == "2 years")
            #expect(CommonModels.formatYears(1.5) == "1 year and 6 months")
            #expect(CommonModels.formatYears(0.0) == "0 years")
        }

    // Calculate MonthlyPayment
    @Test func testCalculateMonthlyPayment_ValidInput() async throws {
           let loanAmount = 10000.0
           let rate = 5.0
           let years = 5.0

           var validationErrorCalled = false
           var positiveValueErrorCalled = false

           let result = MortgageCalculation.calculateMonthlyPayment(
               loanAmount: loanAmount,
               rate: rate,
               years: years,
               showValidationError: { validationErrorCalled = true },
               showPositiveValueError: { positiveValueErrorCalled = true }
           )

           #expect(result != nil)
           #expect(validationErrorCalled == false)
           #expect(positiveValueErrorCalled == false)
       }

    // Calculate MonthlyPayment - ValidationError
       @Test func testCalculateMonthlyPayment_NilInput_ShouldCallValidationError() async throws {
           var validationErrorCalled = false
           var positiveValueErrorCalled = false

           let result = MortgageCalculation.calculateMonthlyPayment(
               loanAmount: nil,
               rate: 5.0,
               years: 5.0,
               showValidationError: { validationErrorCalled = true },
               showPositiveValueError: { positiveValueErrorCalled = true }
           )

           #expect(result == nil)
           #expect(validationErrorCalled == true)
           #expect(positiveValueErrorCalled == false)
       }

    // Calculate MonthlyPayment - PositiveValueError
       @Test func testCalculateMonthlyPayment_NegativeValues_ShouldCallPositiveValueError() async throws {
           var validationErrorCalled = false
           var positiveValueErrorCalled = false

//           let invalidLoanAmount = Double("abc")

           let result = MortgageCalculation.calculateMonthlyPayment(
               loanAmount: -5000.0,
               rate: 5.0,
               years: 5.0,
               showValidationError: { validationErrorCalled = true },
               showPositiveValueError: { positiveValueErrorCalled = true }
           )

           #expect(result == nil)
           #expect(validationErrorCalled == false)
           #expect(positiveValueErrorCalled == true)
       }
    
    @Test func testCalculateLoanAmount_ValidInput() async throws {
        let payment = 500.0
        let rate = 5.0
        let years = 10.0

        var validationErrorCalled = false
        var positiveValueErrorCalled = false

        let result = MortgageCalculation.calculateLoanAmount(
            payment: payment,
            rate: rate,
            years: years,
            showValidationError: { validationErrorCalled = true },
            showPositiveValueError: { positiveValueErrorCalled = true }
        )

        #expect(result != nil)
        #expect(validationErrorCalled == false)
        #expect(positiveValueErrorCalled == false)
    }

    @Test func testCalculateLoanAmount_NilValues() async throws {
        var validationErrorCalled = false
        var positiveValueErrorCalled = false

        let result = MortgageCalculation.calculateLoanAmount(
            payment: nil,
            rate: 5.0,
            years: 10.0,
            showValidationError: { validationErrorCalled = true },
            showPositiveValueError: { positiveValueErrorCalled = false }
        )

        #expect(result == nil)
        #expect(validationErrorCalled == true)
        #expect(positiveValueErrorCalled == false)
    }

    @Test func testCalculateLoanAmount_NegativeValues() async throws {
        var validationErrorCalled = false
        var positiveValueErrorCalled = false

        let result = MortgageCalculation.calculateLoanAmount(
            payment: -500.0,
            rate: 5.0,
            years: 10.0,
            showValidationError: { validationErrorCalled = false },
            showPositiveValueError: { positiveValueErrorCalled = true }
        )

        #expect(result == nil)
        #expect(validationErrorCalled == false)
        #expect(positiveValueErrorCalled == true)
    }

    @Test func testCalculateLoanAmount_ZeroValues() async throws {
        var validationErrorCalled = false
        var positiveValueErrorCalled = false

        let result = MortgageCalculation.calculateLoanAmount(
            payment: 0.0,
            rate: 5.0,
            years: 10.0,
            showValidationError: { validationErrorCalled = false },
            showPositiveValueError: { positiveValueErrorCalled = true }
        )

        #expect(result == nil)
        #expect(validationErrorCalled == false)
        #expect(positiveValueErrorCalled == true)
    }

    @Test func testCalculateLoanAmount_ZeroMonthlyRate() async throws {
        let payment = 200.0
        let rate = 0.0
        let years = 5.0

        var validationErrorCalled = false
        var positiveValueErrorCalled = false

        let result = MortgageCalculation.calculateLoanAmount(
            payment: payment,
            rate: rate,
            years: years,
            showValidationError: { validationErrorCalled = true },
            showPositiveValueError: { positiveValueErrorCalled = true }
        )

        #expect(result != nil)
        #expect(validationErrorCalled == false)
        #expect(positiveValueErrorCalled == false)
        #expect(result == payment * years * 12) // rate is 0, loan amount = payment * months
    }
    
    @Test func testCalculateInterestRate_ValidInputs() async throws {
            let loanAmount = 10000.0
            let payment = 200.0
            let years = 5.0

            var validationErrorCalled = false
            var positiveValueErrorCalled = false

            let result = MortgageCalculation.calculateInterestRate(
                loanAmount: loanAmount,
                payment: payment,
                years: years,
                showValidationError: { validationErrorCalled = true },
                showPositiveValueError: { positiveValueErrorCalled = true }
            )

            #expect(result != nil)
            #expect(validationErrorCalled == false)
            #expect(positiveValueErrorCalled == false)
        }

        @Test func testCalculateInterestRate_NilInputs_ShouldTriggerValidationError() async throws {
            var validationErrorCalled = false
            var positiveValueErrorCalled = false

            let result = MortgageCalculation.calculateInterestRate(
                loanAmount: nil,
                payment: 200.0,
                years: 5.0,
                showValidationError: { validationErrorCalled = true },
                showPositiveValueError: { positiveValueErrorCalled = true }
            )

            #expect(result == nil)
            #expect(validationErrorCalled == true)
            #expect(positiveValueErrorCalled == false)
        }

        @Test func testCalculateInterestRate_NegativeValues_ShouldTriggerPositiveValueError() async throws {
            let loanAmount = -10000.0
            let payment = 200.0
            let years = 5.0

            var validationErrorCalled = false
            var positiveValueErrorCalled = false

            let result = MortgageCalculation.calculateInterestRate(
                loanAmount: loanAmount,
                payment: payment,
                years: years,
                showValidationError: { validationErrorCalled = true },
                showPositiveValueError: { positiveValueErrorCalled = true }
            )

            #expect(result == nil)
            #expect(validationErrorCalled == false)
            #expect(positiveValueErrorCalled == true)
        }

        @Test func testCalculateInterestRate_ZeroValues_ShouldTriggerPositiveValueError() async throws {
            let loanAmount = 0.0
            let payment = 200.0
            let years = 5.0

            var validationErrorCalled = false
            var positiveValueErrorCalled = false

            let result = MortgageCalculation.calculateInterestRate(
                loanAmount: loanAmount,
                payment: payment,
                years: years,
                showValidationError: { validationErrorCalled = true },
                showPositiveValueError: { positiveValueErrorCalled = true }
            )

            #expect(result == nil)
            #expect(validationErrorCalled == false)
            #expect(positiveValueErrorCalled == true)
        }

        @Test func testCalculateInterestRate_HighLoanAmount_LowPayment() async throws {
            let loanAmount = 1000000.0
            let payment = 50.0
            let years = 30.0

            var validationErrorCalled = false
            var positiveValueErrorCalled = false

            let result = MortgageCalculation.calculateInterestRate(
                loanAmount: loanAmount,
                payment: payment,
                years: years,
                showValidationError: { validationErrorCalled = true },
                showPositiveValueError: { positiveValueErrorCalled = true }
            )

            #expect(result == nil) // Should return nil as the payment is too low for such a high loan
            #expect(validationErrorCalled == false)
            #expect(positiveValueErrorCalled == false)
        }
    
    @Test func testCalculateLoanTerm_ValidInputs() async throws {
         let loanAmount = 10000.0
         let payment = 200.0
         let rate = 5.0

         var validationErrorCalled = false
         var positiveValueErrorCalled = false

         let result = MortgageCalculation.calculateLoanTerm(
             loanAmount: loanAmount,
             payment: payment,
             rate: rate,
             showValidationError: { _ in validationErrorCalled = true },
             showPositiveValueError: { positiveValueErrorCalled = true }
         )

         #expect(result != nil)
         #expect(validationErrorCalled == false)
         #expect(positiveValueErrorCalled == false)
     }

     @Test func testCalculateLoanTerm_NilInputs_ShouldTriggerValidationError() async throws {
         var validationErrorCalled = false
         var positiveValueErrorCalled = false

         let result = MortgageCalculation.calculateLoanTerm(
             loanAmount: nil,
             payment: 200.0,
             rate: 5.0,
             showValidationError: { _ in validationErrorCalled = true },
             showPositiveValueError: { positiveValueErrorCalled = true }
         )

         #expect(result == nil)
         #expect(validationErrorCalled == true)
         #expect(positiveValueErrorCalled == false)
     }

     @Test func testCalculateLoanTerm_NegativeValues_ShouldTriggerPositiveValueError() async throws {
         let loanAmount = -10000.0
         let payment = 200.0
         let rate = 5.0

         var validationErrorCalled = false
         var positiveValueErrorCalled = false

         let result = MortgageCalculation.calculateLoanTerm(
             loanAmount: loanAmount,
             payment: payment,
             rate: rate,
             showValidationError: { _ in validationErrorCalled = true },
             showPositiveValueError: { positiveValueErrorCalled = true }
         )

         #expect(result == nil)
         #expect(validationErrorCalled == false)
         #expect(positiveValueErrorCalled == true)
     }

     @Test func testCalculateLoanTerm_ZeroValues_ShouldTriggerPositiveValueError() async throws {
         let loanAmount = 0.0
         let payment = 200.0
         let rate = 5.0

         var validationErrorCalled = false
         var positiveValueErrorCalled = false

         let result = MortgageCalculation.calculateLoanTerm(
             loanAmount: loanAmount,
             payment: payment,
             rate: rate,
             showValidationError: { _ in validationErrorCalled = true },
             showPositiveValueError: { positiveValueErrorCalled = true }
         )

         #expect(result == nil)
         #expect(validationErrorCalled == false)
         #expect(positiveValueErrorCalled == true)
     }

    @Test func testCalculateLoanTerm_InsufficientPayment_ShouldTriggerValidationError() async throws {
        let loanAmount = 10000.0
        let payment = 40.0 // Payment is too low to cover the interest
        let rate = 6.5

        var validationErrorCalled = false
        var positiveValueErrorCalled = false

        let result = MortgageCalculation.calculateLoanTerm(
            loanAmount: loanAmount,
            payment: payment,
            rate: rate,
            showValidationError: { error in
                if error == .insufficientDataError {
                    validationErrorCalled = true
                }
            },
            showPositiveValueError: { positiveValueErrorCalled = true }
        )

        #expect(result == nil)
        #expect(validationErrorCalled == true)
        #expect(positiveValueErrorCalled == false)  
    }

     @Test func testCalculateLoanTerm_HighLoanAmount_LowPayment_ShouldReturnNil() async throws {
         let loanAmount = 1000000.0
         let payment = 1000.0 // Payment is too low for such a large loan
         let rate = 5.0

         var validationErrorCalled = false
         var positiveValueErrorCalled = false

         let result = MortgageCalculation.calculateLoanTerm(
             loanAmount: loanAmount,
             payment: payment,
             rate: rate,
             showValidationError: { _ in validationErrorCalled = true },
             showPositiveValueError: { positiveValueErrorCalled = true }
         )

         #expect(result == nil)
         #expect(validationErrorCalled == true)
         #expect(positiveValueErrorCalled == false)
     }

     @Test func testCalculateLoanTerm_CorrectLoanTerm() async throws {
         let loanAmount = 50000.0
         let payment = 1000.0
         let rate = 5.0

         var validationErrorCalled = false
         var positiveValueErrorCalled = false

         let result = MortgageCalculation.calculateLoanTerm(
             loanAmount: loanAmount,
             payment: payment,
             rate: rate,
             showValidationError: { _ in validationErrorCalled = true },
             showPositiveValueError: { positiveValueErrorCalled = true }
         )

         #expect(result != nil)
         #expect(validationErrorCalled == false)
         #expect(positiveValueErrorCalled == false)
         #expect(result ?? 0 > 0) // Ensure the result is a positive loan term
     }
}
