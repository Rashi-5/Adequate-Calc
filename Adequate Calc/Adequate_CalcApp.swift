//
//  Adequate_CalcApp.swift
//  Adequate Calc
//
//  Created by Rashmi Liyanawadu on 2025-03-02.
//

import SwiftUI

@main
struct Adequate_CalcApp: App {
    @StateObject private var darkModeManager = DarkModeManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(darkModeManager) 
        }
    }
}
