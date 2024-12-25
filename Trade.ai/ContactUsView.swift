import SwiftUI

struct ContactUsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var emailText: String = ""
    @State private var messageText: String = ""
    @State private var showErrorAlert = false

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
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text("Unable to send the message. Please make sure you have a valid email client configured."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func sendContactUsMessage() {
        guard !emailText.isEmpty, !messageText.isEmpty else {
            showErrorAlert = true
            return
        }

        // Create the mailto URL
        let subject = "Contact Us Inquiry"
        let body = "From: \(emailText)\n\n\(messageText)"
        if let emailURL = URL(string: "mailto:fzhire@gmail.com?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") {
            // Open the default email app
            if UIApplication.shared.canOpenURL(emailURL) {
                UIApplication.shared.open(emailURL)
            } else {
                showErrorAlert = true
            }
        }
    }
}