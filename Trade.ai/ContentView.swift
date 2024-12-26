import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "arrow.up.right.circle" : "arrow.up.right.circle.fill")
                        .font(.largeTitle)
                        .padding()

                    Text("New Signals")
                }
                .tag(0)
                        
            NotificationsView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "doc.text" : "doc.text.fill")
                        .font(.largeTitle)
                        .padding()
                    Text("Past Signals")
                }
                .tag(1)
            /*
            ERView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "bell.fill" : "bell")
                    Text("Recent ERs")
                }
                .tag(2)
            */
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
