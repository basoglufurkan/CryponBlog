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
    
    @Binding var selectedPremiumBS: BottomSheetSelectedPremium
    @State var optionSelected = false
    
    var body: some View {
        
        Spacer()
        RadioButtonGroups { package in
            optionSelected = true
            
            if package == "months12" {
                selectedPackage("12", "39.99")
            } else {
                selectedPackage("1", "12.99")
            }
        }
        
        BuyButton(){
            selectedPremiumBS = .top
        }
        .buttonStyle(.plain)
        .disabled(!optionSelected)
        
        Text("Cancel anytime")
        
        Button("Restore Purchases", action: restorePurchases)
            .foregroundColor(.blue)
        
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
