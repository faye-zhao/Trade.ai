import SwiftUI

struct DisclaimerView: View {
    @Environment(\.presentationMode) var presentationMode // To dismiss the view

    var body: some View {
        VStack(spacing: 20) {
            Text("Disclaimer")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)

            ScrollView {
                Text("""
                This app is provided "as is" without any guarantees or warranties. The creators of this app are not responsible for any damage or issues caused by the use of this app.

                The information provided in the app is for educational and informational purposes only and is not intended as legal, financial, or medical advice. Users are responsible for their own actions and decisions based on the app's content.

                By using this app, you agree to these terms and conditions. If you do not agree, please discontinue the use of this app.
                """)
                .padding()
                .multilineTextAlignment(.leading)
            }
            .frame(maxHeight: .infinity)
            
            Button("Close") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .foregroundColor(.red)
        }
        .padding()
    }
}