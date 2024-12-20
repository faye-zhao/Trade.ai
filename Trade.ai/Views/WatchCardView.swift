import SwiftUI

struct WatchCardView: View {
    @State private var dateList: [DateEntry] = []
    @State private var isLoading = false

    var body: some View {
        ZStack {
            if isLoading {
                ProgressView("Loading data...")
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(dateList) { entry in
                            CardView(entry: entry)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            Task {
                await loadData()
            }
        }
    }
    
    private func loadData0() {
        let dummyData: [DateEntry] = [
            DateEntry(date: "2024-01-01", ticks: [
                Tick(symbol: "AAPL", sector: "Technology", close: 150.0, nowPrice: 152.5, closedPrice: nil, date: "2024-01-01"),
                Tick(symbol: "GOOGL", sector: "Technology", close: 2800.0, nowPrice: 2850.0, closedPrice: 2830.0, date: "2024-01-01"),
                Tick(symbol: "MSFT", sector: "Technology", close: 300.0, nowPrice: 305.0, closedPrice: nil, date: "2024-01-01")
            ]),
            DateEntry(date: "2024-01-02", ticks: [
                Tick(symbol: "AMZN", sector: "Consumer Cyclical", close: 3300.0, nowPrice: 3350.0, closedPrice: 3340.0, date: "2024-01-02"),
                Tick(symbol: "TSLA", sector: "Consumer Cyclical", close: 700.0, nowPrice: 720.0, closedPrice: nil, date: "2024-01-02")
            ])
        ]
        self.dateList = dummyData
    }

    private func loadData() async {
        isLoading = true
        defer { isLoading = false }

        // Implement data loading logic here
        //http://localhost:4001/signalsAuto?type=p
        //http://localhost:4001/signalsAuto?type=bo
        let hostname = "fz.whaty.org"
        let url = URL(string: "https://\(hostname)/csv/signalsAuto?type=p")!
        var request = URLRequest(url: url)
        request.setValue("text/csv", forHTTPHeaderField: "Accept")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            guard let csvString = String(data: data, encoding: .utf8) else {
                print("Invalid data")
                return
            }
            
            let parsedData = parseCSV(csvString)
            
            await MainActor.run {
                self.dateList = parsedData
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    private func parseCSV(_ csvString: String) -> [DateEntry] {
        // Split the CSV string into lines
        let lines = csvString.components(separatedBy: .newlines)
        // Print the lines to the console
        print("CSV Lines:")
        /*
        for (index, line) in lines.enumerated() {
            print("Line \(index + 1): \(line)")
        }
        */
        // Create a date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var dateEntries: [DateEntry] = []
        
        // Skip the header row
        for line in lines.dropFirst() {
            // Break the loop if we've processed 20 entries
            if dateEntries.count >= 20 {
                break
            }
            let columns = line.components(separatedBy: ",")

            guard columns.count >= 11 else { continue }

            //symbol,date,pattern,attr,price,strength,sector,lo,close,orderType,closedPrice

            //date,collectType,symbol,
            //pattern,briefPattern,rsi,attr,ratio,weight,strength,
            //sector,pRatio,cweight,ov,cover,sDur,uRatio,fsRelTotalStrength,
            //fsStrength,fsRatio,fsRelDur,
            //lo,close,er,noChange,volScore,vol,volRate,volCount,description,tableType,
            //nowPrice
            let date = columns[0]
            let cleanDate = date
                .replacingOccurrences(of: "\"", with: "")

            let symbol = columns[2]
            let cleanSymbol = symbol
                .replacingOccurrences(of: "\"", with: "")

            let sector = columns[10]

            let closeColumn = columns[22]
            let cleanCloseColumn = closeColumn
                .replacingOccurrences(of: "\"", with: "")

            let closedPriceColumn = columns[31]
            let cleanClosedPriceColumn = closedPriceColumn
                .replacingOccurrences(of: "\"", with: "")

            let nowPriceColumn = columns[31]
            let cleanNowPriceColumn = nowPriceColumn
                .replacingOccurrences(of: "\"", with: "")

            let close = Double(cleanCloseColumn) ?? 0.0
            let nowPrice = Double(cleanNowPriceColumn) ?? 0.0
            let closedPrice = Double(cleanClosedPriceColumn)
            
            //print("Date: \(columns[1]), \(columns[8]), \(Float(columns[8])) , Symbol: \(symbol), Sector: \(sector), Close: \(close), Now Price: \(nowPrice), Closed Price: \(closedPrice)")

            let tick = Tick(symbol: cleanSymbol, sector: sector, close: close, nowPrice: nowPrice, closedPrice: closedPrice, date: cleanDate)       
            
            let tickDate = tick.date
            if let index = dateEntries.firstIndex(where: { $0.date == tickDate }) {
                dateEntries[index].ticks.append(tick)  // Modify the entry directly in the array
            } else {
                let newEntry = DateEntry(date: tickDate, ticks: [tick])
                dateEntries.append(newEntry)
            }
        }
    
        return dateEntries
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

struct WatchCardView_Previews: PreviewProvider {
    static var previews: some View {
        WatchCardView()
    }
}
