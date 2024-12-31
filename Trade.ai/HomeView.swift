import SwiftUI

struct HomeView: View {
    @State private var showSettings = false // State to control the side panel
    //@State private var selectedTab = 0
    @State private var selectedSentiment = "Short" // Default sentiment

    // Sentiment options
    let sentimentOptions = [
        (icon: "📈", label: "Buy"),
        (icon: "📉", label: "Short"),
        (icon: "⚖️", label: "Auto")
    ]

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

                    // Sentiment Selector
                    Menu {
                        ForEach(sentimentOptions, id: \.label) { option in
                            Button(action: {
                                selectedSentiment = option.label // Update sentiment
                            }) {
                                HStack {
                                    Text(option.icon)
                                    Text(option.label)
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Text(sentimentOptions.first { $0.label == selectedSentiment }?.icon ?? "⚖️")
                            Text(selectedSentiment)
                        }
                        .font(.headline)
                        .padding()
                    }
                }
                .padding(.horizontal)

                VStack {
                    if selectedSentiment == "Buy" {
                        BuySignalsView()
                    } else if selectedSentiment == "Short" {
                        ShortSignalsView()
                    } else {
                        AutoSignalsView()
                    }
                }
                .animation(.easeInOut, value: selectedSentiment)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Take remaining space
            .animation(.easeInOut, value: showSettings) // Smooth transition
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


