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
    @State  var freeDays: String
    
    
    
    
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
            
            AllPosts( premiumBS: $premiumBottomSheetPosition, storeManager: storeManager)
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
            PremiumView(selectedPackage: { months, total, freeDays in
                self.months = months
                self.total = total
                self.freeDays = freeDays
            }, selectedPremiumBS: $selectedBottomSheetPosition)
        })
        .bottomSheet(bottomSheetPosition: $selectedBottomSheetPosition, options: [  .noBottomPosition, .allowContentDrag, .swipeToDismiss, ], headerContent: {
            
        }, mainContent: {
            SelectedPremiumView(months: months, total: total, freeDays: freeDays, is12Months: months == "12" ? true : false, storeManager: storeManager)
        })
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
