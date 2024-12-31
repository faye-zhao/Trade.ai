import SwiftUI

struct NotificationsView: View {
    @State private var selectedSentiment = "Short"

    let sentimentOptions = [
        (icon: "📈", label: "Buy"),
        (icon: "📉", label: "Short"),
        (icon: "⚖️", label: "Auto")
    ]

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Menu {
                    ForEach(sentimentOptions, id: \.label) { option in
                        Button(action: {
                            selectedSentiment = option.label
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

struct BuySignalsAllView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            WatchCardView(signalType: "Buy")
        }
        .padding(.horizontal)
    }
}

struct ShortSignalsAllView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            WatchCardView(signalType: "Short")
        }
        .padding(.horizontal)
    }
}

struct AutoSignalsAllView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            WatchCardView(signalType: "Auto")
        }
        .padding(.horizontal)
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}