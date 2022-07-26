//
//  RadioButtonField.swift
//  CryponBlog
//
//  Created by Furkan Başoğlu on 10.04.2022.
//

import SwiftUI


//MARK:- Single Radio Button Field
struct RadioButtonField: View {
    let months: String
    let price: String
    let is12Months: Bool
    let id: String
    let label: String
    let size: CGFloat
    let color: Color
    let textSize: CGFloat
    let isMarked:Bool
    let callback: (String)->()
    
    @AppStorage("\(SubscriptionProduct.weeklySub.productID)_price") private var weeklyPrice: Double = 12.99
    @AppStorage("\(SubscriptionProduct.monthlySub.productID)_price") private var monthlyPrice: Double = 39.99
    
    private var discount: Int {
        let originalPrice = weeklyPrice * 4
        let newPrice = monthlyPrice
        return Int(round((originalPrice - newPrice) / originalPrice * 10000) / 100)
    }
    
    init(
        months: String,
        price: String,
        is12Months: Bool,
        id: String,
        label:String,
        size: CGFloat = 20,
        color: Color = Color.black,
        textSize: CGFloat = 14,
        isMarked: Bool = false,
        callback: @escaping (String)->()
    ) {
        self.months = months
        self.price = price
        self.is12Months = is12Months
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.textSize = textSize
        self.isMarked = isMarked
        self.callback = callback
    }
    
    var body: some View {
        Button(action:{
            self.callback(self.id)
        }) {
            
            VStack{
                Text("Best Value")
//                    .foregroundColor(Color.black)
                    .opacity(is12Months ? 1 : 0)
                ZStack{
                    Image(systemName: "checkmark.circle.fill")
                        .offset(x: 55, y: -55)
                        .foregroundColor(Color.green)
                        .opacity(self.isMarked ? 1 : 0)
                    VStack{
                        Text(months == "12" ? "1" : "1")
                            .font(.system(size: 16, weight: .bold, design: .default))
                        
                        Text(months == "1" ? "Week" : "Months")
                            .font(.system(size: 12, weight: .regular, design: .default))
                        
                        Text("SAVE \(discount)%")
                            .foregroundColor(.white)
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                            .padding(.leading, 30)
                            .padding(.trailing, 30)
                            .background(Color.green)
                            .cornerRadius(40)
                            .font(.system(size: 12, weight: .bold, design: .default))
                            .padding(.top, 1)
                            .padding(.bottom, 1)
                            .opacity(is12Months ? 1 : 0)
                        
                        
                        Text(price)
                            .font(.system(size: 14, weight: .bold, design: .default))
                        
                        Text(months == "1" ? "Week" : "Month")
                            .font(.system(size: 12, weight: .regular, design: .default))
                        
                    }
                    
//                    .foregroundColor(.black)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(self.isMarked ? Color.green : Color.black, lineWidth: 1.5))
                }
            }
            
        }
    }
}

//struct RadioButtonField_Previews: PreviewProvider {
//    static var previews: some View {
//        RadioButtonField(months: "12", price: "1.66", is12Months: true, id: "", label: "")
//    }
//}
