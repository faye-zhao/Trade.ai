import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = false // State for toggle
    @State private var isUpgradeViewPresented = false // State to show Upgrade View
    @State private var isDisclaimerPresented = false // State to show Disclaimer view

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Settings")
                .font(.headline)
                .padding(.top)
            
            // Enable Notifications Toggle with Icon
            HStack {
                Image(systemName: "bell.fill") // Notification icon
                    .foregroundColor(.blue)
                    .imageScale(.large)
                
                Toggle(isOn: $notificationsEnabled) {
                    Text("Enable Notifications")
                        .font(.body)
                }
            }
            .padding(.horizontal)
            
            // Upgrade AI Signal Section
            VStack(alignment: .leading, spacing: 10) {
                Text("Upgrade AI Signal")
                    .font(.headline)
                    .padding(.horizontal)
                
                Button(action: {
                    isUpgradeViewPresented.toggle() // Present the Upgrade View
                }) {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("Upgrade to Pro")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .sheet(isPresented: $isUpgradeViewPresented) {
                    UpgradeView() // Navigate to Upgrade Screen
                }
            }
            
            // Additional Options
            VStack(alignment: .leading, spacing: 20) {
                Button(action: {
                    print("Join Discord Channel tapped")
                }) {
                    HStack {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                            .foregroundColor(.purple)
                        Text("Join Discord Channel")
                            .foregroundColor(.primary)
                    }
                }
                
                Button(action: {
                    print("Share App tapped")
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.green)
                        Text("Share App")
                            .foregroundColor(.primary)
                    }
                }
                
                Button(action: {
                    print("Contact Us tapped")
                }) {
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.orange)
                        Text("Contact Us")
                            .foregroundColor(.primary)
                    }
                }

                // Disclaimer Button
                Button(action: {
                    isDisclaimerPresented.toggle()
                }) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.red)
                        Text("Disclaimer")
                            .foregroundColor(.primary)
                    }
                }
                .padding(.horizontal)
                .sheet(isPresented: $isDisclaimerPresented) {
                    DisclaimerView()
                }                

            }
            .padding(.horizontal)
            
            Spacer()
            
            // Close Button
            Button("Close") {
                // Add close action if needed
            }
            .padding()
        }
        .frame(maxHeight: .infinity)
        .padding() // Overall padding for the view
    }
}