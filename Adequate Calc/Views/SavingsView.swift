import SwiftUI

struct SavingsView: View {
    @EnvironmentObject var darkModeManager: DarkModeManager
    var body: some View {
        
        TabView {
            NonRegularContributionView()
                .tabItem {
                    Label("One-Time Investment", systemImage: "timelapse")
                }
            
            RegularContributionView(title: "Recurrent Investment")
                .tabItem {
                    Label("Recurring Investment", systemImage: "clock.arrow.trianglehead.2.counterclockwise.rotate.90")
                }
            
        }.tint(darkModeManager.isDarkMode ? Color.white : Color.black)
    }
}

#Preview {
    SavingsView()
        .environmentObject(DarkModeManager())
}
