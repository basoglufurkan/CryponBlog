//
//  ContentView.swift
//  CryponBlog
//
//  Created by Furkan Başoğlu on 12.01.2022.
//

import SwiftUI
import BottomSheet

enum BottomSheetPremium: CGFloat, CaseIterable {
    case top = 0.6, hidden = 0
}

enum BottomSheetSelectedPremium: CGFloat, CaseIterable {
    case top = 0.6, hidden = 0
}

struct ContentView: View {
    @StateObject var store = BlogPostsStore()
    @StateObject private var vm = HomeViewModel()
    @State private var premiumBottomSheetPosition: BottomSheetPremium = .hidden
    @State private var selectedBottomSheetPosition: BottomSheetSelectedPremium = .hidden
    
    @StateObject var storeManager: StoreManager
    
    @State  var months: String
    @State  var total: String
    
    @State private var alertMessage: String?
    private var showAlert: Binding<Bool> { Binding (
        get: { alertMessage != nil },
        set: { if !$0 { alertMessage = nil } }
        )
    }
    
    let subscriptionActive: Bool
    
    var body: some View {
        
        TabView {
            ZStack {
                NavigationView {
                    HomeView()
                        .navigationBarHidden(true)
                        
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .environmentObject(vm)
                
            }
            .tabItem {
                Image(systemName: "bitcoinsign.circle.fill")
                Text("Store")
            }
//            HomeView()
//                .environmentObject(vm)
//                .navigationBarHidden(true)
//                .tabItem {
//                    Image(systemName: "bitcoinsign.circle.fill")
//                    Text("Store")
//                }
            
            AllPosts( premiumBS: $premiumBottomSheetPosition, storeManager: storeManager, unlockAllPosts: subscriptionActive)
                .environmentObject(store)
                .navigationBarHidden(true)
                .tabItem {
                    Image(systemName: "wand.and.stars.inverse")
                    Text("Signals")
                }
            
            MainView()
                .environmentObject(store)
                .navigationBarHidden(true)
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Post")
                }
            
        }
        .bottomSheet(bottomSheetPosition: $premiumBottomSheetPosition, options: [  .noBottomPosition, .allowContentDrag, .swipeToDismiss, ], headerContent: {
        }, mainContent: {
            PremiumView(
                restorePurchases: { [weak storeManager] in
                    premiumBottomSheetPosition = .hidden
                    
                    storeManager?.restorePurchases { result in
                        switch result {
                        case let .success(hasRestoredProducts):
                            alertMessage = hasRestoredProducts ? "Restore Complete" : "Nothing to Restore"
                        case .failure:
                            alertMessage = "Restore Failed with Error"
                        }
                    }
                },
                selectedPackage: { months, total in
                    self.months = months
                    self.total = total
                },
                selectedPremiumBS: $selectedBottomSheetPosition)
        })
        .bottomSheet(bottomSheetPosition: $selectedBottomSheetPosition, options: [  .noBottomPosition, .allowContentDrag, .swipeToDismiss, ], headerContent: {
            
        }, mainContent: {
            SelectedPremiumView(onClickPurchase: {
                selectedBottomSheetPosition = .hidden
                premiumBottomSheetPosition = .hidden
                
                print("on buy button \(months)")
                if !storeManager.myProducts.isEmpty {
                    let productID = months == "12" ? SubscriptionProduct.monthlySub.productID : SubscriptionProduct.weeklySub.productID
                    
                    guard let product = storeManager.myProducts.first(where: { $0.productIdentifier == productID }) else {
                        assertionFailure("No product with ID: \(productID)")
                        return }
                        
                    storeManager.purchaseProduct(product: product)

                } else {
                    assertionFailure("No products available")
                }
            },months: months, total: total, is12Months: months == "12" ? true : false, storeManager: storeManager)
        })
        .alert(isPresented: showAlert) {
            Alert(title: Text(alertMessage ?? ""))
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
