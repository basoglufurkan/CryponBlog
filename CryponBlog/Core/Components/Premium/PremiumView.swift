//
//  PremiumView.swift
//  CryponBlog
//
//  Created by Furkan Başoğlu on 10.04.2022.
//

import SwiftUI

struct PremiumView: View {
    let restorePurchases: () -> Void
    var selectedPackage: (_ months: String, _ total: String, _ freeDays: String) -> Void
    
    @Binding var selectedPremiumBS: BottomSheetSelectedPremium
    
    var body: some View {
        
        Spacer()
        RadioButtonGroups { package in
            if package == "months12" {
                selectedPackage("12", "39.99", "7")
            } else {
                selectedPackage("1", "12.99", "3")
            }
        }
        
        BuyButton(){
            selectedPremiumBS = .top
        }
        
        Button("Restore Purchases", action: restorePurchases)
            .foregroundColor(.blue)
            .font(.footnote)
            .padding(.init(top: -16, leading: 0, bottom: 0, trailing: 0))
        
        Text("Cancel anytime")
        Spacer()
    }
}

//struct PremiumView_Previews: PreviewProvider {
//    static var previews: some View {
//        PremiumView(selectedPackage: { months in
//
//        }, selectedPremiumBS: .constant(.hidden))
//    }
//}
