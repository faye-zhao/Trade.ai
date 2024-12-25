import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings")
                .font(.headline)
                .padding()
            Spacer()
            Button("Close") {
                // Add close action if needed
            }
            .padding()
        }
        .frame(maxHeight: .infinity)
    }
}