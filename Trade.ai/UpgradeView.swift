import SwiftUI

struct UpgradeView: View {
    @State private var isSubscribed = false // Tracks subscription state
    @Environment(\.presentationMode) var presentationMode // Dismiss the view
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Upgrade to Pro")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if isSubscribed {
                Text("🎉 Thank you for subscribing! 🎉")
                    .font(.title2)
                    .foregroundColor(.green)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                Text("Unlock premium features and take your AI Signal experience to the next level!")
                    .multilineTextAlignment(.center)
                    .padding()
                
                Button(action: {
                    subscribeNow()
                }) {
                    Text("Subscribe Now")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            Button("Cancel") {
                presentationMode.wrappedValue.dismiss() // Dismiss the Upgrade View
            }
            .foregroundColor(.red)
        }
        .padding()
    }
    
    // Simulated Subscription Logic
    private func subscribeNow() {
        // Simulate a subscription process
        print("Subscription process started...")
        
        // Mock delay to simulate payment processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isSubscribed = true
            print("Subscription successful!")
        }
    }
}