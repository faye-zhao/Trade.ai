import UIKit
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configure notification center
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        // Request notification permissions
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
                return
            }
            
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        
        return true
    }
    
    // Handle successful registration of device token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        // TODO: Send this token to your server
        sendDeviceTokenToServer(token: token)
    }
    
    // Handle failed registration
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    // Handle receiving notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    // Handle user tapping on notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // Handle the notification data
        if let aps = userInfo["aps"] as? [String: Any] {
            print("Notification content: \(aps)")
            // TODO: Handle notification data (e.g., navigate to specific screen)
        }
        
        completionHandler()
    }
    
    // Handle receiving remote notification
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Handle the notification data
        if let aps = userInfo["aps"] as? [String: Any] {
            print("Remote notification received: \(aps)")
            // TODO: Handle notification data
        }
        
        completionHandler(.newData)
    }
    /*
    private func sendDeviceTokenToServer(token: String) {
        // Replace with your backend's URL
        let url = URL(string: "https://your-backend.com/register-device-token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["device_token": token]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to send device token: \(error.localizedDescription)")
            } else {
                print("Device token sent successfully")
            }
        }
        task.resume()
    }
    */
    private func sendDeviceTokenToServer(token: String) {
        let storedToken = UserDefaults.standard.string(forKey: "deviceToken")
        
        // Compare new token with stored token
        if storedToken != token {
            // Update locally
            UserDefaults.standard.set(token, forKey: "deviceToken")
            
            // Prepare payload
            let payload: [String: String] = [
                "userId": "12345", //TBD
                "oldToken": storedToken ?? "",
                "newToken": token
            ]
            print("Update Token on Server")
            // Send to backend
            updateTokenOnServer(payload)
        }
    }

    func updateTokenOnServer(_ payload: [String: String]) {
        // Example backend request
        //${DOMAIN_NAME}/chart/updateToken
        guard let url = URL(string: "https://fz.whaty.org/chart/updateToken") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating token: \(error.localizedDescription)")
            } else {
                print("Successfully updated token")
            }
        }.resume()
    }

}
