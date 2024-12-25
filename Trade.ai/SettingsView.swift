import SwiftUI

struct SettingsView: View {
    var body: some View {
        
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Settings")
            
            WatchCardView()
        }
        .padding()
    }
}
