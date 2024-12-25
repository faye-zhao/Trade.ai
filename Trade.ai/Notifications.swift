import SwiftUI

struct NotificationsView: View {
    var body: some View {
        
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Notifications")
            
            WatchCardView()
        }
        .padding()
    }
}
