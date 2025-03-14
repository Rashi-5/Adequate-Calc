//
//  CommonComponents.swift
//  Adequate Calc
//
//  Created by Rashmi Liyanawadu on 2025-03-02.
//

import SwiftUI

struct CommonTextField: View {
    
    var label: String
    @Binding var text: String
    @EnvironmentObject var darkModeManager: DarkModeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(label)
                .frame(width: UIScreen.main.bounds.width * 0.4, alignment: .leading)
                .foregroundColor(darkModeManager.isDarkMode ? Color.white : Color.black)
            
            TextField("", text: $text)
                .padding()
                .foregroundColor(darkModeManager.isDarkMode ? Color.white : Color.black)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.05, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(darkModeManager.isDarkMode ? Color.white : Color.black, lineWidth: 0.3)
                )
                .keyboardType(.decimalPad)
            
        }.padding(.top, 8)
    }
}

#Preview {
    CommonTextField(label: "Label", text: .constant(""))
        .environmentObject(DarkModeManager())
}
