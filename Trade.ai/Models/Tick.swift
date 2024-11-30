import Foundation

struct Tick: Identifiable {
    let id = UUID()
    let symbol: String
    let sector: String
    let close: Double
    let nowPrice: Double
    let closedPrice: Double?
    let date: String
}

struct DateEntry: Identifiable {
    let id = UUID()
    let date: String
    var ticks: [Tick]
}