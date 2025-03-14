//
//  AppError.swift
//  Adequate Calc
//
//  Created by Rashmi Liyanawadu on 2025-03-13.
//

import Foundation

enum AppError: Error {
    case validationError
    case positiveValueError
    case valueMismatch
    case invalidResponse
    case internalError
    case unknown

    var localizedDescription: String {
        switch self {
        case .validationError:
            return "Please enter valid numbers"
        case .positiveValueError:
            return "Values must be greater than zero"
        case .valueMismatch:
            return "Values provided weren't a match"
        case .invalidResponse:
            return "Invalid Response"
        case .internalError:
            return "Initial value cannot be less that the target"
        case .unknown:
            return "Unknown Error"
        }
    }
}

