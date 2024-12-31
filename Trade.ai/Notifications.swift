import SwiftUI

struct NotificationsView: View {
    var body: some View {
        
        VStack {        
            //Buy/Short/Auto    
            WatchCardView(signalType: "Short")
        }
        .padding()
    }
}
