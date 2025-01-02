import SwiftUI

struct StockChartView: View {
    let tick: Tick
    @State private var chartData: [ChartDataPoint] = []
    @State private var isLoading: Bool = true
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            // Chart Title
            Text("Stock Chart for \(tick.symbol)")
                .font(.headline)
                .padding(.bottom, 10)

            // Chart Area
            if isLoading {
                ProgressView("Loading chart data...")
                    .padding()
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                GeometryReader { geometry in
                    Path { path in
                        guard !chartData.isEmpty else { return }
                        
                        let width = geometry.size.width
                        let height = geometry.size.height
                        let stepX = width / CGFloat(chartData.count - 1)
                        
                        let maxY = chartData.map { $0.high }.max() ?? 1
                        let minY = chartData.map { $0.low }.min() ?? 0
                        let range = maxY - minY
                        
                        for (index, point) in chartData.enumerated() {
                            let x = stepX * CGFloat(index)
                            let y = height * (1 - CGFloat((point.close - minY) / range))
                            
                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .stroke(Color.blue, lineWidth: 2)
                }
                .frame(height: 200)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 5)
            }

            // Additional Info
            HStack {
                Text("Close: \(String(format: "%.2f", tick.close))")
                Spacer()
                Text("Support: \(String(format: "%.2f", tick.support))")
            }
            .padding(.top, 10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .onAppear {
            Task {
                await fetchChartData()
            }
        }
    }

    private func fetchChartData() async {
        do {
            chartData = try await DataLoader.loadChartData(symbol: tick.symbol)
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
}