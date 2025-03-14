//
//  DarkModeManager.swift
//  Adequate Calc
//
//  Created by Rashmi Liyanawadu on 2025-03-02.
//

import Foundation
import SwiftUI


class DarkModeManager: ObservableObject {
    @AppStorage("isDarkMode") var isDarkMode = false {
        willSet { objectWillChange.send() } // Ensure views update
    }
}


