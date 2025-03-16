//
//  ContentView.swift
//  Adequate Calc
//
//  Created by Rashmi Liyanawadu on 2025-03-02.
//

import SwiftUI

struct ContentView: View {
    @State private var isSidebarVisible = false
    @EnvironmentObject var darkModeManager: DarkModeManager
    let buttonSize = UIScreen.main.bounds.width * 0.2
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView{
                    // Main Content
                    VStack(spacing: 50) {
                        
                        Spacer()
                        VStack(alignment: .leading){
                            Text("Ease Your Goals!")
                                .font(.system(size: 28, weight: .bold))
                                .padding(.bottom, 16)
                            
                            Text("Easy and Fast way to calculate all your finacial goals..")
                                .font(.system(size: 18, weight: .medium))
                            
                        }
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.18)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(darkModeManager.isDarkMode ? Color.black.opacity(0.8) : Color.white.opacity(0.8))
                                .shadow(color: darkModeManager.isDarkMode ? Color.white.opacity(0.3) : Color.black.opacity(0.3), radius: 10, x: 0, y: 0)
                        )
                        .foregroundColor(darkModeManager.isDarkMode ? .white : .black)
                        .padding(.top, 30)
                        
                        Spacer()
                        
                        HStack(spacing: 50) {
                            NavigationLink(destination: SavingsView()) {
                                CustomButton(imageName: "savings", size: buttonSize, title: "Savings", isDarkMode: darkModeManager.isDarkMode)
                            }
                            NavigationLink(destination: RegularContributionView(title: "Loan Calculation")) {
                                CustomButton(imageName: "tax", size: buttonSize, title: "Loans", isDarkMode: darkModeManager.isDarkMode)
                            }
                            
                        }
                        
                        HStack(spacing: 50) {
                            NavigationLink(destination: MortgageView()) {
                                CustomButton(imageName: "home-insurance", size: buttonSize, title: "Mortgage", isDarkMode: darkModeManager.isDarkMode)
                            }
                            NavigationLink(destination: HelpView()) {
                                CustomButton(imageName: "question-mark", size: buttonSize, title: "Help", isDarkMode: darkModeManager.isDarkMode)
                            }
                        }
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .background(darkModeManager.isDarkMode ? Color.black : Color.white)

                // Settings button
                VStack {
                    HStack {
                        
                        Text("Adequate Calc")
                            .foregroundColor(darkModeManager.isDarkMode ? Color.white : Color.black)
                            .font(.system(size: 28, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.leading, 38)
                            .shadow(color: darkModeManager.isDarkMode ? Color.white.opacity(0.5) : Color.black.opacity(0.3), radius: 10, x: 0, y: 0)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                isSidebarVisible.toggle()
                            }
                        }) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 20))
                                .foregroundColor(darkModeManager.isDarkMode ? .white : .black)
                                .padding()
                            
                        }
                        
                    }
                    .padding(.trailing, 10)
                    
                    
                    Spacer()
                }
                
                // Settings Sidebar
                if isSidebarVisible {
                    
                    Color.black.opacity(0.5)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                isSidebarVisible = false
                            }
                        }
                    
                    HStack {
                        
                        VStack {
                            // heading
                            HStack {
                                Text("Settings")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(darkModeManager.isDarkMode ? .white : .black)
                                
                                Spacer()
                                
                                Button(action: {
                                    withAnimation(.spring()) {
                                        isSidebarVisible = false
                                    }
                                }) {
                                    Image(systemName: "xmark")
                                        .font(.title3)
                                        .foregroundColor(darkModeManager.isDarkMode ? .white : .black)
                                }
                            }
                            .padding()
                            .padding(.top, UIScreen.main.bounds.height * 0.08)
                            
                            // Dark Mode Toggle
                            HStack {
                                
                                Image(systemName: darkModeManager.isDarkMode ? "moon.fill" : "sun.max.fill")
                                    .foregroundColor(darkModeManager.isDarkMode ? .white : .black)
                                
                                Text("Dark Mode")
                                    .foregroundColor(darkModeManager.isDarkMode ? .white : .black)
                                
                                Spacer()
                                
                                Toggle("", isOn: $darkModeManager.isDarkMode)
                                    .labelsHidden()
                            }
                            .padding()
                            .preferredColorScheme(darkModeManager.isDarkMode ? .dark : .light)
                            
                            // Currency rates
                            HStack {
                                
                                Button(action: {}) {
                                    NavigationLink(destination: CurrencyExchangeView()) {
                                        HStack {
                                            Image(systemName: "coloncurrencysign.bank.building")
                                            Text("Currency Rates")
                                        }
                                        .foregroundColor(darkModeManager.isDarkMode ? .white : .black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                
                            }
                            .padding()
                            
                            Spacer()
                        }
                        .padding(.bottom, UIScreen.main.bounds.height * 0.08)
                        .frame(width: UIScreen.main.bounds.width * 1, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 1)
                                .fill(darkModeManager.isDarkMode ? Color.black : Color.white)
                            
                        )
                        .offset(x: isSidebarVisible ? 0 : UIScreen.main.bounds.width)
                        .animation(.spring(), value: isSidebarVisible)
                    }
                    .ignoresSafeArea()
                }
            }
        }
    }
    
    struct CustomButton: View {
        let imageName: String
        let size: CGFloat
        let title: String
        let isDarkMode: Bool
        
        var body: some View {
                VStack {
                    Image(imageName)
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: size, height: size)
                        .padding(10)
                    
                    Divider()
                        .background(isDarkMode ? Color.white.opacity(0.4) : Color.black.opacity(0.4))
                        .frame(height: 1)
                        .padding(.horizontal, 1)
                    
                    Text(title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(isDarkMode ? .white : .black)
                        .padding(.bottom, 10)
                }
                .frame(width: size + 60, height: size + 60)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isDarkMode ? Color.black.opacity(0.8) : Color.white.opacity(0.8))
                        .shadow(color: isDarkMode ? Color.white.opacity(0.5) : Color.black.opacity(0.3), radius: 10, x: 0, y: 0)
                )
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DarkModeManager())
}
