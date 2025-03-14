//
//  HelpView.swift
//  Adequate Calc
//
//  Created by Rashmi Liyanawadu on 2025-03-08.
//

import SwiftUI

struct HelpView: View {
    @EnvironmentObject var darkModeManager: DarkModeManager
    
    @State private var currentCardIndex = 0
       
       // Define your help cards
       let helpCards: [HelpCard] = [
           HelpCard(
               title: "Welcome to Adaque Calculator!",
               image: "calculator",
               content: "This app helps you calculate financial metrics such as savings, loans, and mortgages. You can determine future values, present values, interest rates, and more."
           ),
           HelpCard(
               title: "How to Use the App",
               image: "book",
               content: "1. Navigate between the Savings, Loans, and Mortgage views using the tab bar.\n\n2. Enter the required values (e.g., present value, payment, interest rate).\n3. Tap 'Calculate' to see the results."
           ),
           HelpCard(
               title: "Examples",
               image: "reference",
               content: "Example 1: If you invest $10,000 at an annual interest rate of 5% for 10 years, how much will you have?\n\nExample 2: If you borrow $50,000 at an annual interest rate of 7% and pay $500 monthly, how long will it take to repay the loan?"
           ),
           HelpCard(
               title: "Troubleshooting",
               image: "troubleshooting",
               content: "• Ensure all fields are filled with positive numbers.\n\n• If the app crashes, restart it and try again."
           ),
           HelpCard(
               title: "FAQs",
               image: "faq",
               content: "Q: Can I calculate both savings and loans in this app?\n\nA: Yes, the app supports calculations for savings, loans, and mortgages."
           ),
           HelpCard(
               title: "Tips and Best Practices",
               image: "cloud",
               content: "• Use realistic values for accurate results.\n\n• Double-check your inputs before calculating."
           ),
           HelpCard(
               title: "Legal and Privacy Information",
               image: "compliant",
               content: "This app is for educational and informational purposes only. The results are estimates and may not reflect actual financial outcomes.\n\nWe do not collect or store any personal data. All calculations are performed locally on your device."
           ),
           HelpCard(
               title: "Version and Credits",
               image: "customer-service",
               content: "Version 1.0.0\nSupports IOS 17+\nBuilt with SwiftUI and Xcode."
           )
       ]
       
       var body: some View {
           ScrollView{
               VStack {
                   // Card counter indicator
                   Text("\(currentCardIndex + 1) / \(helpCards.count)")
                       .font(.caption)
                       .padding(.top)
                   
                   // Card swipe area
                   TabView(selection: $currentCardIndex) {
                       ForEach(0..<helpCards.count, id: \.self) { index in
                           CardView(card: helpCards[index], isDarkMode: darkModeManager.isDarkMode)
                               .tag(index)
                       }
                   }
                   .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                   .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                   .frame(height: UIScreen.main.bounds.height * 0.65)
                   
                   // Navigation buttons
                   HStack {
                       Button(action: {
                           withAnimation {
                               currentCardIndex = max(currentCardIndex - 1, 0)
                           }
                       }) {
                           Image(systemName: "chevron.left")
                               .font(.title2)
                               .padding()
                               .foregroundColor(currentCardIndex > 0 ? (darkModeManager.isDarkMode ? .white : .black) : .gray)
                       }
                       .disabled(currentCardIndex == 0)
                       
                       Button(action: {
                           withAnimation {
                               currentCardIndex = min(currentCardIndex + 1, helpCards.count - 1)
                           }
                       }) {
                           Image(systemName: "chevron.right")
                               .font(.title2)
                               .padding()
                               .foregroundColor(currentCardIndex < helpCards.count - 1 ? (darkModeManager.isDarkMode ? .white : .black) : .gray)
                       }
                       .disabled(currentCardIndex == helpCards.count - 1)
                   }
                   .padding(.horizontal)
               }
               .navigationTitle("Help")
               .foregroundColor(darkModeManager.isDarkMode ? Color.white : Color.black)
           }.background(darkModeManager.isDarkMode ? Color.black : Color.white)
               
       }
}

struct HelpCard {
    let title: String
    let image: String
    let content: String
}

// Individual card view
struct CardView: View {
    let card: HelpCard
    let isDarkMode: Bool
    
    var body: some View {
        VStack {
            // Image at the top
            Image(card.image)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.2)
                .foregroundColor(isDarkMode ? .white : .black)
                .padding(.top, 20)
                .padding(.bottom, 30)
            
            // Card content
            VStack(alignment: .leading, spacing: 20) {
                Text(card.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(isDarkMode ? .white : .black)
                    .padding(.bottom, 10)
                
                Text(card.content)
                    .font(.body)
                    .foregroundColor(isDarkMode ? .white : .black)
            }
            .padding()
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(isDarkMode ? Color.black.opacity(0.8) : Color.white)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}


#Preview {
    HelpView()
        .environmentObject(DarkModeManager())
}
