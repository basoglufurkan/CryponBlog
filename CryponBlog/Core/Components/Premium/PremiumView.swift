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
        VStack(spacing: 8){
            RadioButtonGroups { package in
                optionSelected = true
                
                if package == "months12" {
                    selectedPackage("12", "39.99")
                } else {
                    selectedPackage("1", "12.99")
                }
            }
            
            Text("Access to crypto signals, pre-sale, airdrop, bitcoin analysis and lots of useful information.")
                .fixedSize(horizontal: false, vertical: true)
                .padding(.leading)
                .padding(.trailing)
            
            BuyButton(){
                selectedPremiumBS = .top
            }
            .buttonStyle(.plain)
            .disabled(!optionSelected)
            
            
            Text("Cancel anytime")
            
            Button("Restore Purchases", action: restorePurchases)
                .foregroundColor(.blue)
            
        }
    }
}

struct PremiumView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumView(restorePurchases: {}, selectedPackage: { months,
            
            
            
            
            _  in

        }, selectedPremiumBS: .constant(.hidden))
    }
}
