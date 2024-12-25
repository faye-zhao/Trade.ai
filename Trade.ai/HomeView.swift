import SwiftUI

struct HomeView: View {
    var body: some View {
        
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("AI Signals")
        }
        .padding()
        
        WatchCardView()
    }
}

