//
//  CryponBlogApp.swift
//  CryponBlog
//
//  Created by Furkan Başoğlu on 12.01.2022.
//

import SwiftUI
import Firebase
import StoreKit

struct SubscriptionProduct {
    static let expirationKey = "subExpiration"
    let productID: String
    
    static let weeklySub = SubscriptionProduct(productID: "com.furkanbasoglu.crypon.blog.subscription.weekly")
    static let monthlySub = SubscriptionProduct(productID: "com.furkanbasoglu.crypon.blog.subscription.monthly")
}

@main
struct CryponBlogApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    @StateObject private var vm = HomeViewModel()
    
    @StateObject var storeManager = StoreManager(onPurchaseProduct: { product in
        guard let subscriptionPeriod = product.subscriptionPeriod else {
            print("Product not handled: \(product.productIdentifier)")
            return
        }
        
        // derive the expiration date and add one more day in case of offsets.
        // every time a product is purchased or restored, the dereive expiration date would be recalculated.
        let timeIntervalUnit: Double
        let unit: Calendar.Component
        let fallbackDays: Int
        
        switch subscriptionPeriod.unit {
        case .month:
            unit = .month
            fallbackDays = 30
          
        default:
            unit = .weekOfYear
            fallbackDays = 7
        }

        let expirationDate: Date
        if let derivedDate = Calendar.current.date(byAdding: unit, value: subscriptionPeriod.numberOfUnits, to: Date()), let derivedDateWithOffset =  Calendar.current.date(byAdding: .day, value: 1, to: derivedDate) {
            
            expirationDate = derivedDateWithOffset
        } else {
            assertionFailure("Derived date can not be made.")
            expirationDate = Date().addingTimeInterval(Double(fallbackDays*86400*subscriptionPeriod.numberOfUnits))
        }
        
        UserDefaults.standard.set(expirationDate.timeIntervalSince1970, forKey: SubscriptionProduct.expirationKey)
    })
    
    
    @StateObject private var vm = HomeViewModel()
    @State private var showLaunchView: Bool = true
    @State private var presentPaywall = false
    @AppStorage(SubscriptionProduct.expirationKey) private var expirationTime: TimeInterval = 0
    private var subscriptionActive: Bool { expirationTime > Date().timeIntervalSince1970 }
    
    let productIDs = [
        //Use your product IDs instead
        SubscriptionProduct.monthlySub.productID,
        SubscriptionProduct.weeklySub.productID
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
                ContentView(storeManager: storeManager, months: "", total: "", subscriptionActive: subscriptionActive)
                    .onAppear(perform: {
                        SKPaymentQueue.default().add(storeManager)
                        storeManager.getProducts(productIDs: productIDs)
                    })
                    .onChange(of: storeManager.myProducts, perform: { products in
                        products.forEach {
                            // save price string from App Store, so we can show it faster on next launch
                            UserDefaults.standard.set($0.localizedPrice, forKey: $0.productIdentifier)
                            // save price from App Store, so we can calculate the discount rate
                            UserDefaults.standard.set($0.price, forKey: "\($0.productIdentifier)_price")
                        }
                    })
                    .fullScreenCover(isPresented: $presentPaywall) {
                        PaywallView(storeManager: storeManager)
                    }
                
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
        
        // Force link text in text view to be blue
        UITextView.appearance().linkTextAttributes = [.foregroundColor: UIColor.systemBlue ]
        
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

