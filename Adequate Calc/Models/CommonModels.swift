//
//  CommonModels.swift
//  Adequate Calc
//
//  Created by Rashmi Liyanawadu on 2025-03-02.
//

import Foundation

struct CommonModels {
    
    static func formatYears(_ years: Double) -> String {
        let wholeYears = Int(years)
        let months = Int((years - Double(wholeYears)) * 12)
        
        if months == 0 {
            return "\(wholeYears) year\(wholeYears == 1 ? "" : "s")"
        } else {
            return "\(wholeYears) year\(wholeYears == 1 ? "" : "s") and \(months) month\(months == 1 ? "" : "s")"
        }
    }
    
}
