import Foundation

struct DataLoader {
    static func loadData(signalType: String) async throws -> [DateEntry] {
        let url = getURL(for: signalType)

        var request = URLRequest(url: url)
        request.setValue("text/csv", forHTTPHeaderField: "Accept")

        let (data, _) = try await URLSession.shared.data(for: request)
        guard let csvString = String(data: data, encoding: .utf8) else {
            throw DataLoaderError.invalidData
        }

        return signalType == "Buy" || signalType == "Short"
            ? parseCSVManul(csvString)
            : parseCSV(csvString)
    }

    static func loadChartData(symbol: String) async throws -> [ChartDataPoint] {
        let url = getChartURL(for: symbol)

        var request = URLRequest(url: url)
        request.setValue("text/csv", forHTTPHeaderField: "Accept")

        let (data, _) = try await URLSession.shared.data(for: request)
        guard let csvString = String(data: data, encoding: .utf8) else {
            throw DataLoaderError.invalidData
        }

        return parseChartCSV(csvString)
    }

    private static func getURL(for signalType: String) -> URL {
        let hostname = "fz.whaty.org" // Replace with your actual hostname
        let urlString: String

        switch signalType {
        case "Buy":
            urlString = "https://\(hostname)/csv/signals"
        case "Short":
            urlString = "https://\(hostname)/csv/signalsNeg"
        case "Auto":
            urlString = "https://\(hostname)/csv/signalsAuto?type=p"
        default:
            urlString = "https://\(hostname)/csv/signalsAuto?type=p"
        }

        return URL(string: urlString)!
    }

    private static func getChartURL(for symbol: String) -> URL {
        let hostname = "fz.whaty.org" // Replace with your actual hostname
        let urlString = "https://\(hostname)/chart/?type=c&symbol=\(symbol)"
        return URL(string: urlString)!
    }

    private static func parseCSVManul(_ csvString: String) -> [DateEntry] {
        // Parsing logic from WatchCardView
        let lines = csvString.components(separatedBy: .newlines)
        var dateEntries: [DateEntry] = []

        for line in lines.dropFirst() {
            if dateEntries.count >= 20 { break }
            let columns = line.components(separatedBy: ",")
            guard columns.count >= 11 else { continue }

            let date = columns[1].replacingOccurrences(of: "\"", with: "")
            let symbol = columns[0].replacingOccurrences(of: "\"", with: "")
            let sector = columns[7]
            let close = Double(columns[9].replacingOccurrences(of: "\"", with: "")) ?? 0.0
            let nowPrice = Double(columns[12].replacingOccurrences(of: "\"", with: "")) ?? 0.0
            let closedPrice = Double(columns[11].replacingOccurrences(of: "\"", with: ""))
            let support = Double(columns[8].replacingOccurrences(of: "\"", with: "")) ?? 0.0

            let tick = Tick(
                symbol: symbol,
                sector: sector,
                support: support,
                close: close,
                nowPrice: nowPrice,
                closedPrice: closedPrice,
                date: date
            )

            if let index = dateEntries.firstIndex(where: { $0.date == tick.date }) {
                dateEntries[index].ticks.append(tick)
            } else {
                dateEntries.append(DateEntry(date: tick.date, ticks: [tick]))
            }
        }

        return dateEntries
    }

    private static func parseCSV(_ csvString: String) -> [DateEntry] {
        let lines = csvString.components(separatedBy: .newlines)
        var dateEntries: [DateEntry] = []

        for line in lines.dropFirst() {
            if dateEntries.count >= 20 { break }
            let columns = line.components(separatedBy: ",")
            guard columns.count >= 11 else { continue }

            let date = columns[0].replacingOccurrences(of: "\"", with: "")
            let symbol = columns[2].replacingOccurrences(of: "\"", with: "")
            let sector = columns[10]
            let close = Double(columns[23].replacingOccurrences(of: "\"", with: "")) ?? 0.0
            let nowPrice = Double(columns[32].replacingOccurrences(of: "\"", with: "")) ?? 0.0
            let closedPrice = Double(columns[32].replacingOccurrences(of: "\"", with: ""))

            let tick = Tick(
                symbol: symbol,
                sector: sector,
                support: 0,
                close: close,
                nowPrice: nowPrice,
                closedPrice: closedPrice,
                date: date
            )

            if let index = dateEntries.firstIndex(where: { $0.date == tick.date }) {
                dateEntries[index].ticks.append(tick)
            } else {
                dateEntries.append(DateEntry(date: tick.date, ticks: [tick]))
            }
        }

        return dateEntries
    }

    private static func parseChartCSV(_ csvString: String) -> [ChartDataPoint] {
        let lines = csvString.components(separatedBy: .newlines)
        var chartData: [ChartDataPoint] = []

        for line in lines.dropFirst() {
            let columns = line.components(separatedBy: ",")
            guard columns.count >= 4 else { continue }

            let date = columns[0].replacingOccurrences(of: "\"", with: "")
            let open = Double(columns[1]) ?? 0.0
            let high = Double(columns[2]) ?? 0.0
            let low = Double(columns[3]) ?? 0.0
            let close = Double(columns[4]) ?? 0.0

            let dataPoint = ChartDataPoint(date: date, open: open, high: high, low: low, close: close)
            chartData.append(dataPoint)
        }

        return chartData
    }
}

enum DataLoaderError: Error {
    case invalidData
}

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let date: String
    let open: Double
    let high: Double
    let low: Double
    let close: Double
}
