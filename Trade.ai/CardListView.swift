import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let symbol: String
    let date: String
    let buyTarget: String
    let stopLoss: String
}

struct DetailCardView: View {
    let card: Card

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Symbol:")
                    .fontWeight(.bold)
                Text(card.symbol)
            }
            
            HStack {
                Text("Date:")
                    .fontWeight(.bold)
                Text(card.date)
            }
            
            HStack {
                Text("Buy Target:")
                    .fontWeight(.bold)
                Text(card.buyTarget)
            }
            
            HStack {
                Text("Stop Loss:")
                    .fontWeight(.bold)
                Text(card.stopLoss)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
    }
}

struct CardListView: View {
    let cards: [Card] = [
        Card(symbol: "AAPL", date: "2024-12-01", buyTarget: "$180", stopLoss: "$170"),
        Card(symbol: "TSLA", date: "2024-12-02", buyTarget: "$250", stopLoss: "$230"),
        Card(symbol: "AMZN", date: "2024-12-03", buyTarget: "$3500", stopLoss: "$3400")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(cards) { card in
                    DetailCardView(card: card)
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
}