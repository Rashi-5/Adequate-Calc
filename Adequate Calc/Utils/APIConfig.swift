//
//  APIConfig.swift
//  Adequate Calc
//
//  Created by Rashmi Liyanawadu on 2025-03-16.
//

import Foundation

struct APIConfig {
    
    static var apiKey: String {
        return getValue(for: "API_KEY")
    }
    
    static var baseURL: String {
        return getValue(for: "BASE_URL")
    }
    
    private static func getValue(for key: String) -> String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
              let value = dict[key] as? String else {
            fatalError("Missing or invalid \(key) in Config.plist")
        }
        return value
    }
}
