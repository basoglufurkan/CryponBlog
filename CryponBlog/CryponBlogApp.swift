//
//  CryponBlogApp.swift
//  CryponBlog
//
//  Created by Furkan Başoğlu on 12.01.2022.
//

import SwiftUI
import Firebase
import StoreKit

@main
struct CryponBlogApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    @StateObject private var vm = HomeViewModel()
    
    @StateObject var storeManager = StoreManager()
    @StateObject private var vm = HomeViewModel()
    @State private var showLaunchView: Bool = true
    
    let productIDs = [
        //Use your product IDs instead
        "com.furkanbasoglu.crypon.blog.subscription.monthly",
        "com.furkanbasoglu.crypon.blog.subscription.weekly"
    ]
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent)
        UITableView.appearance().backgroundColor = UIColor.clear
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView(storeManager: storeManager, months: "", total: "")
                    .onAppear(perform: {
                        SKPaymentQueue.default().add(storeManager)
                        storeManager.getProducts(productIDs: productIDs)
                    })
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
        }
    }
}

//Intializng Firebase and Cloud Messaging...

class AppDelegate: NSObject, UIApplicationDelegate {
    
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        
        FirebaseApp.configure()
        
        //Setting Up Cloud Messaging...
        
        Messaging.messaging().delegate = self
        
        //Setting Up Notifications
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

        
        return true
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                       -> Void) {
    
        //Do something with message data here
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
    
}

//Cloud messaging
extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        
        //Store token in firestore for sending notifications from server in future
        
        print(dataDict)
        
    }

    
}

//User notifications... (AKA InAoo Notifications)
@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
      let userInfo = notification.request.content.userInfo

      //Do something with msg data
      
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      print(userInfo)

      completionHandler([[.banner, .badge, .sound]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo

      if let messageID = userInfo[gcmMessageIDKey] {
         print("Message ID: \(messageID)")
       }

    print(userInfo)

    completionHandler()
  }
}

