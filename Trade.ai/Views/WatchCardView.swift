import SwiftUI

struct WatchCardView: View {
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
                        Text("Today")
                            .font(.headline)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        ForEach(dateList.indices, id: \.self) { index in
                            if index > 0, index == 1 {
                                Text("Older")
                                    .font(.headline)
                                    .padding(.horizontal)
                                    .padding(.top, 20)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }

                            CardView(entry: dateList[index])
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

struct CardView: View {
    let entry: DateEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(entry.date)
                .font(.subheadline)
                .foregroundColor(.secondary)
            ForEach(entry.ticks) { tick in
                TickRow(tick: tick)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct TickRow: View {
    let tick: Tick
    
    var body: some View {
        HStack {
            Text(tick.symbol)
                .onTapGesture {
                    // Implement popover functionality
                }
            
            Spacer()
            
            Text(String(format: "%.2f", tick.close))
            
            Spacer()
            
            Text(String(format: "%.2f", tick.nowPrice))

            Spacer()
            
            Text(percentageText)
                .foregroundColor(percentageColor)
            
            Spacer()
            
            Circle()
                .fill(tick.closedPrice == nil ? Color.green : Color.blue)
                .frame(width: 10, height: 10)
                .onTapGesture(count: 2) {
                    closeWatch(tick)
                }
        }
    }
    
    private var percentageText: String {
        let percentage: Double
        if let closedPrice = tick.closedPrice {
            percentage = (closedPrice - tick.close) / tick.close * 100
        } else {
            percentage = (tick.nowPrice - tick.close) / tick.close * 100
        }
        return String(format: "%+.1f%%", percentage)
    }
    
    private var percentageColor: Color {
        if percentageText.starts(with: "+") {
            return .green
        } else if percentageText.starts(with: "-") {
            return .red
        } else {
            return .black
        }
    }
    
    private func getSectorName(_ sector: String) -> String {
        // Implement sector name lookup
        return sector
    }
    
    private func closeWatch(_ tick: Tick) {
        // Implement watch closing functionality
    }
}

