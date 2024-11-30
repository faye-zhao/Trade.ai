//
//  ContentView.swift
//  Trade.ai
//
//  Created by fang zhao on 10/12/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, trader!")
        }
        .padding()
        
        WatchCardView()
    }
}

#Preview {
    ContentView()
}
