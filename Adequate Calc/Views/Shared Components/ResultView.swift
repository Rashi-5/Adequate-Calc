//
//  ResultView.swift
//  Adequate Calc
//
//  Created by Rashmi Liyanawadu on 2025-03-10.
//

import SwiftUI
import Charts

struct ResultView : View {
    
    var result: (value: Double, type: String)?
    var chartData: [(type: String, value: Double)]
    var sumData: [(type: String, value: Double)]
    @EnvironmentObject var darkModeManager: DarkModeManager
    
    var body: some View {
        
        VStack(spacing: 20) {
            ScrollView {
                
                Text("Calculation Result")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                
                if let result = result {
                    VStack(alignment: .center, spacing: 6) {
                        Text(result.type)
                            .font(.title3)
                            .fontWeight(.medium)
                        
                        // Format years
                        if result.type == "Time Period (Years)" {
                            Text(CommonModels.formatYears(result.value))
                                .font(.system(size: 26, weight: .bold))
                        } else {
                            Text(String(format: "%.2f", result.value))
                                .font(.system(size: 26, weight: .bold))
                        }
                    }
                    .padding(.vertical)
                } else {
                    Text("No result available")
                        .font(.title3)
                }
                
                let compoundFrequency = sumData.first { $0.type == "Compound Frequency" }?.value
                let numberOfPayments = sumData.first { $0.type == "Number of Payments" }?.value
                let paymentDue = sumData.first(where: { $0.type == "Payment Timing" })?.value

                if let compoundFrequency = compoundFrequency,
                   let numberOfPayments = numberOfPayments,
                   let paymentDue = paymentDue {
                    
                    let annuityType = compoundFrequency == numberOfPayments ? "Simple" : "General"
                    let paymentType = paymentDue == 1.0 ? "- ordinary Annuity" : "- Annuity due"
                    
                    Text("\(annuityType) \(paymentType) ")
                        .foregroundColor(.blue)
                        .bold()
                }
                
                Chart(chartData, id: \.type) { item in
                    SectorMark(
                        angle: .value("Count", item.value),
                        innerRadius: .ratio(0.5),
                        angularInset: 2
                    )
                    .cornerRadius(5)
                    .foregroundStyle(by: .value("Category", item.type))
                }
                .frame(height: UIScreen.main.bounds.height * 0.33)
                .chartLegend(alignment: .center)
                .padding(.bottom, 8)
                
                ForEach(sumData, id: \.type) { item in
                    HStack {
                        Text(item.type)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(String(format: "%.2f", item.value))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .cornerRadius(5)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(darkModeManager.isDarkMode ? Color(.systemGray2) : Color(.systemGray5))
            .foregroundColor(Color.black)
        }
    }
}

#Preview {
    ResultView(chartData: [
        (type: "Xcode", value: 79),
        (type: "Swift", value: 73),
        (type: "SwiftUI", value: 58),
        (type: "SwiftData", value: 9)
    ], sumData: [(type: "Payment" , value: 265),
                 (type: "Rates" , value: 5),
                 (type: "Months" , value: 25)])
    .environmentObject(DarkModeManager())
}
