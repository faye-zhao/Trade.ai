import SwiftUI
import MessageUI

struct ContactUsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var emailText: String = ""
    @State private var messageText: String = ""
    @State private var showAlert = false // Alert for confirmation

    var body: some View {
        VStack(spacing: 20) {
            Text("Contact Us")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            TextField("Your Email Address", text: $emailText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextEditor(text: $messageText)
                .frame(height: 200)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                .padding(.horizontal)

            Button(action: {
                sendContactUsMessage()
            }) {
                Text("Send Message")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(.red)
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Message Sent"),
                message: Text("Thank you for contacting us. We’ll get back to you soon!"),
                dismissButton: .default(Text("OK"), action: {
                    presentationMode.wrappedValue.dismiss()
                })
            )
        }
    }

    private func sendContactUsMessage() {
        // Simulated contact us functionality
        guard !emailText.isEmpty, !messageText.isEmpty else {
            // Optionally add validation for empty fields
            return
        }

        // Simulate sending the message (Replace with actual email API or mailto functionality)
        print("Email: \(emailText)")
        print("Message: \(messageText)")

        // Show confirmation alert
        showAlert = true
    }
}