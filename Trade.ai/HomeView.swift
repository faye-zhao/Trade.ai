import SwiftUI

struct HomeView: View {
    @State private var showSettings = false // State to control the side panel
    @State private var selectedTab = 0
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
                
            VStack {
                // Tab Buttons
                HStack(spacing: 16) {
                    TabButton(icon: "arrow.up.circle.fill", title: "Buy", isSelected: selectedTab == 0) {
                        selectedTab = 0
                    }
                    
                    TabButton(icon: "arrow.down.circle.fill", title: "Short", isSelected: selectedTab == 1) {
                        selectedTab = 1
                    }

                    TabButton(icon: "arrow.up.circle.fill", title: "Auto Buy", isSelected: selectedTab == 2) {
                        selectedTab = 2
                    }
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)

                // Tab Content
                if selectedTab == 0 {
                    BuySignalsView()
                } else if selectedTab == 1 {
                    ShortSignalsView()
                } else {
                    AutoSignalsView()
                }
            }
            .animation(.easeInOut, value: selectedTab) 
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Take remaining space
            }
            .animation(.easeInOut, value: showSettings) // Smooth transition
        }
}

// Reusable Tab Button
struct TabButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.footnote)
            }
            .padding()
            .foregroundColor(isSelected ? .white : .gray)
            .background(isSelected ? Color.blue : Color.clear)
            .cornerRadius(8)
            .shadow(color: isSelected ? Color.blue.opacity(0.3) : Color.clear, radius: 4, x: 0, y: 2)
        }
    }
}
// Buy Signals View
struct BuySignalsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {            
            SignalView(signalType: "Buy")
        }
        .padding(.horizontal)
    }
}

// Short Signals View
struct ShortSignalsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SignalView(signalType: "Short")
        }
        .padding(.horizontal)
    }
}


// Auto Buy Signals View
struct AutoSignalsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SignalView(signalType: "Auto")
        }
        .padding(.horizontal)
    }
}


