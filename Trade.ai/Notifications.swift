import SwiftUI

struct NotificationsView: View {
    @State private var selectedSentiment = "Short" // Default sentiment

    // Sentiment options
    let sentimentOptions = [
        (icon: "📈", label: "Buy"),
        (icon: "📉", label: "Short"),
        (icon: "⚖️", label: "Auto")
    ]

    var body: some View {
        
        VStack {    
            // Top Bar with Button on the Left
            HStack {
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

            //Buy/Short/Auto    
            VStack {
                if selectedSentiment == "Buy" {
                    BuySignalsAllView()
                } else if selectedSentiment == "Short" {
                    ShortSignalsAllView()
                } else {
                    AutoSignalsAllView()
                }
            }
            .animation(.easeInOut, value: selectedSentiment)
        }
        .padding()
    }
}

// Buy Signals View
struct BuySignalsAllView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {            
            WatchCardView(signalType: "Buy")
        }
        .padding(.horizontal)
    }
}

// Short Signals View
struct ShortSignalsAllView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            WatchCardView(signalType: "Short")
        }
        .padding(.horizontal)
    }
}


// Auto Buy Signals View
struct AutoSignalsAllView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            WatchCardView(signalType: "Auto")
        }
        .padding(.horizontal)
    }
}
