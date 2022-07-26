//
//  SelectedPremiumView.swift
//  CryponBlog
//
//  Created by Furkan Başoğlu on 10.04.2022.
//

import SwiftUI

let priceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
}()

struct SelectedPremiumView: View {
    let onClickPurchase: () -> Void
    var months: String
    var total: String
    var is12Months: Bool
    @StateObject var storeManager: StoreManager
    
    @AppStorage("\(SubscriptionProduct.weeklySub.productID)_price") private var weeklyPrice: Double = 12.99
    @AppStorage("\(SubscriptionProduct.monthlySub.productID)_price") private var monthlyPrice: Double = 39.99
    private var originalPrice: String { priceFormatter.string(from: round(weeklyPrice*400) / 100 as NSNumber) ?? "51.96" }
    
    private var discount: Int {
        let originalPrice = weeklyPrice * 4
        let newPrice = monthlyPrice
        return Int(round((originalPrice - newPrice) / originalPrice * 10000) / 100)
    }
    
    var body: some View {
        VStack{
            Text("You Have Selected:")
//                .foregroundColor(.black)
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
                        Text(originalPrice)
                            .foregroundColor(.red)
                            .strikethrough()
                            .opacity(is12Months ? 1 : 0)
                        
                        Text(total)
                            .font(.system(size: 16, weight: .bold, design: .default))
                    }
                    Text("You saved \(discount)%")
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
        SelectedPremiumView(onClickPurchase: {}, months: "12", total: "11", is12Months: true, storeManager: StoreManager(onPurchaseProduct: { _ in }))
    }
}

