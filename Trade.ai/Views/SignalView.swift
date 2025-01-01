import SwiftUI

struct SignalView: View {
    var signalType: String = "Default"

    @State private var dateList: [DateEntry] = []
    @State private var isLoading = false

    var body: some View {
        ZStack {
            if isLoading {
                ProgressView("Loading data...")
            } else {
                ScrollView {
                    VStack(spacing: 10) {                        
                        if let firstEntry = dateList.first {
                            SignalCardView(entry: firstEntry)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            Task {
                await fetchData()
            }
        }
    }

    private func fetchData() async {
        isLoading = true
        defer { isLoading = false }

        do {
            dateList = try await DataLoader.loadData(signalType: signalType)
        } catch {
            print("Error loading data: \(error.localizedDescription)")
        }
    }
}

struct SignalCardView: View {
    let entry: DateEntry
    
    var body: some View {
        VStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 10) {
                Text(entry.date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text("Symbol")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("Buy Price")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("Support Price")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.horizontal)
                
                ForEach(entry.ticks) { tick in
                    VStack(alignment: .leading, spacing: 10) {
                        SignalTickRow(tick: tick)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
            }
            .padding()
            .background(Color.white)
        }
    }
}

struct SignalTickRow: View {
    let tick: Tick
    @State private var showChart: Bool = false // Track chart visibility

    var body: some View {
        VStack {
            // Row Content
            HStack {
                Text(tick.symbol)
                    .onTapGesture {
                        toggleChart()
                    }

                Spacer()

                Text(String(format: "%.2f", tick.close))

                Spacer()

                Text(String(format: "%.2f", tick.support))

                Spacer()
            }
            .padding()

            // Conditionally display the stock chart
            if showChart {
                StockChartView(tick: tick)
                    .transition(.opacity) // Smooth animation
                    .padding(.top, 10)
            }
        }
    }

    private func toggleChart() {
        withAnimation {
            showChart.toggle() // Toggle chart visibility
        }
    }
}