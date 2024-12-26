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
                
                // Main Content of Home View
                VStack(alignment: .leading, spacing: 16) { // Align and add spacing
                    Text("AI Signals")
                        .font(.title) // Optional: Adjust font size
                    
                    SignalView()
                }
                .padding(.horizontal) // Add consistent left and right padding
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Take remaining space
        }
        .animation(.easeInOut, value: showSettings) // Smooth transition
    }
}

