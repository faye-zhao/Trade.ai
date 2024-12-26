import SwiftUI

struct SignalView: View {
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
                            CardView(entry: firstEntry)
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
        
        for (index, line) in lines.enumerated() {
            print("Line \(index + 1): \(line)")
        }
        
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

            let closeColumn = columns[23]
            let cleanCloseColumn = closeColumn
                .replacingOccurrences(of: "\"", with: "")

            let closedPriceColumn = columns[32]
            let cleanClosedPriceColumn = closedPriceColumn
                .replacingOccurrences(of: "\"", with: "")

            let nowPriceColumn = columns[32]
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

