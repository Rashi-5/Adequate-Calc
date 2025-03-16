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
    @Binding var snackDesc: String
    @EnvironmentObject var darkModeManager: DarkModeManager
    @State private var showSnackBar = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(label)
                    .foregroundColor(darkModeManager.isDarkMode ? Color.white : Color.black)

                if snackDesc != "" {
                    Label("", systemImage: "questionmark.circle")
                        .foregroundColor(Color.blue)
                        .padding(.bottom, 2)
                        .onTapGesture {
                            self.showSnackBar = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    self.showSnackBar = false
                                }
                            }
                        }
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.8, alignment: .leading)
            
            TextField("", text: $text)
                .padding()
                .foregroundColor(darkModeManager.isDarkMode ? Color.white : Color.black)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.05, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(darkModeManager.isDarkMode ? Color.white : Color.black, lineWidth: 0.3)
                )
                .keyboardType(.decimalPad)
        }
        .padding(.top, 8)
        .overlay(
            Group {
                if showSnackBar {
                    Text(snackDesc)
                        .padding(6)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.9)))
                        .foregroundColor(.white)
                        .offset(y: -UIScreen.main.bounds.height * 0.055)
                        .zIndex(1)
                        .transition(.opacity) // Fade in/out animation
                }
            }
            .animation(.easeInOut(duration: 0.5), value: showSnackBar),
            alignment: .bottom
        )
    }
}

#Preview {
    CommonTextField(label: "Label", text: .constant(""), snackDesc:.constant("description"))
        .environmentObject(DarkModeManager())
}
