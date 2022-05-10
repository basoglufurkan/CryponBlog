//
//  SelectedPremiumView.swift
//  CryponBlog
//
//  Created by Furkan Başoğlu on 10.04.2022.
//

import SwiftUI

struct SelectedPremiumView: View {
    let onClickPurchase: () -> Void
    var months: String
    var total: String
    var freeDays: String
    var is12Months: Bool
    @StateObject var storeManager: StoreManager
    
    var body: some View {
        VStack{
            Text("You Have Selected:")
                .foregroundColor(.black)
                .font(.system(size: 16, weight: .bold, design: .default))
            
            HStack{
                VStack{
                    Text("Total")
                        .font(.system(size: 16, weight: .bold, design: .default))
                    
                    Text("for \(months == "12" ? "1 Month" : "1 Week")")
                    
                }.padding()
                
                
                Spacer()
                
                VStack{
                    HStack{
                        Text("$35.00")
                            .foregroundColor(.red)
                            .strikethrough()
                            .opacity(is12Months ? 1 : 0)
                        
                        Text("$\(total)")
                            .font(.system(size: 16, weight: .bold, design: .default))
                    }
                    Text("You saved 44%")
                        .foregroundColor(.green)
                        .opacity(is12Months ? 1 : 0)
                }.padding()
            }
            .padding()
            
            Divider()
                .padding()
            
            BuyButton(onClick: onClickPurchase)
        }
    }
}

struct SelectedPremiumView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedPremiumView(onClickPurchase: {}, months: "12", total: "11", freeDays: "7", is12Months: true, storeManager: StoreManager())
    }
}

