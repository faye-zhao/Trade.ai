import SwiftUI

struct HomeView: View {
    @State private var showSettings = false // State to control the side panel
    
    var body: some View {
        HStack {
            // Side Panel (conditionally visible)
            if showSettings {
                SettingsView()
                    .frame(width: 250) // Adjust width as needed
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            
            // Main Content
            VStack {
                // Top Bar with Button on the Left
                HStack {
                    Button(action: {
                        showSettings.toggle() // Toggle side panel
                    }) {
                        Image(systemName: "gearshape")
                            .imageScale(.large)
                            .padding()
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                TabView {
                    BuySignalsView()
                        .tabItem {
                            Image(systemName: "arrow.up.circle.fill")
                            Text("Buy Signals")
                        }
                    
                    ShortSignalsView()
                        .tabItem {
                            Image(systemName: "arrow.down.circle.fill")
                            Text("Short Signals")
                        }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Take remaining space
        }
        .animation(.easeInOut, value: showSettings) // Smooth transition
    }
}

// Buy Signals View
struct BuySignalsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Buy Signals")
                .font(.title)
            
            SignalView(signalType: "Buy")
        }
        .padding(.horizontal)
    }
}

// Short Signals View
struct ShortSignalsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Short Signals")
                .font(.title)
            
            SignalView(signalType: "Short")
        }
        .padding(.horizontal)
    }
}


