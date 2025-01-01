import SwiftUI

struct StockChartView: View {
    let tick: Tick

    var body: some View {
        VStack {
            // Chart Title
            Text("Stock Chart for \(tick.symbol)")
                .font(.headline)
                .padding(.bottom, 10)

            // Chart Placeholder (Replace with actual chart implementation)
            GeometryReader { geometry in
                Path { path in
                    // Example chart data points (mock data)
                    let dataPoints: [CGFloat] = [0.8, 0.6, 0.9, 1.2, 1.0, 0.7]
                    let width = geometry.size.width
                    let height = geometry.size.height
                    let stepX = width / CGFloat(dataPoints.count - 1)
                    
                    for (index, value) in dataPoints.enumerated() {
                        let x = stepX * CGFloat(index)
                        let y = height * (1 - value)
                        
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
    }
}