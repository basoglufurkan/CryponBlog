//
//  PremiumView.swift
//  CryponBlog
//
//  Created by Furkan Başoğlu on 10.04.2022.
//

import SwiftUI

struct PremiumView: View {
    let restorePurchases: () -> Void
    var selectedPackage: (_ months: String, _ total: String) -> Void
    @AppStorage(SubscriptionProduct.weeklySub.productID) private var weeklyPrice = Package.weeklyPackage.price
    @AppStorage(SubscriptionProduct.monthlySub.productID) private var monthlyPrice = Package.monthlyPackage.price
    @Binding var selectedPremiumBS: BottomSheetSelectedPremium
    
    var body: some View {
        VStack(spacing: 8){
            RadioButtonGroups { package in
                
                if package == "months12" {
                    selectedPackage("12", monthlyPrice)
                } else {
                    selectedPackage("1", weeklyPrice)
                }
            }
            
            Text("Access to crypto signals, pre-sale, airdrop, bitcoin analysis and lots of useful information.")
                .fixedSize(horizontal: false, vertical: true)
                .padding(.leading)
                .padding(.trailing)
            
            BuyButton(){
                selectedPremiumBS = .top
            }
            
            Text("Cancel anytime")
            
            Button("Restore Purchases", action: restorePurchases)
                .foregroundColor(.blue)
            
        }
    }
}

struct PremiumView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumView(restorePurchases: {}, selectedPackage: { months, _ in

        }, selectedPremiumBS: .constant(.hidden))
    }
}
