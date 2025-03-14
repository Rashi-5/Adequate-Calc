//
//  CommonButton.swift
//  Adequate Calc
//
//  Created by Rashmi Liyanawadu on 2025-03-02.
//

import SwiftUI

struct CommonButton: View {
    
    var label: String
    var action: () -> Void
    @EnvironmentObject var darkModeManager: DarkModeManager
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.headline)
                .foregroundColor(darkModeManager.isDarkMode ? Color.black : Color.white)
                .frame(width:  UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(darkModeManager.isDarkMode ? Color.white : Color.black, lineWidth: 0.3)
                )
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(darkModeManager.isDarkMode ? Color.white : Color.black)
            
        )
        .padding(.top, 30)
        
        
    }
}

#Preview {
    CommonButton(label: "label", action: { })
        .environmentObject(DarkModeManager())
}
