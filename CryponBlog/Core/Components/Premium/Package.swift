//
//  Package.swift
//  CryponBlog
//
//  Created by Furkan Başoğlu on 26.07.2022
//

import SwiftUI
import StoreKit

struct Package: Equatable, Hashable {
    let productID: String
    let title: String
    let description: String
    let prompt: String
    var price: String
    let color: Color
    
    init(productID: String, title: String, description: String, prompt: String, price: String, color: Color) {
        self.productID = productID
        self.title = title
        self.description = description
        self.prompt = prompt
        self.price = price
        self.color = color
    }
    
    static let weeklyPackage: Package = .init(productID: SubscriptionProduct.weeklySub.productID,
                                              title: "Weekly",
                                              description: "Try making money",
                                              prompt: "First steps",
                                              price: "$12.99",
                                              color: .lightBlue)
    
    static let monthlyPackage: Package = .init(productID: SubscriptionProduct.monthlySub.productID,
                                               title: "Monthly",
                                               description: "Pay less, get more",
                                               prompt: "Best price",
                                               price: "$39.99",
                                               color: .lightGreen)
}

extension SKProduct {
    var localizedPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)
    }
}

extension Color {
    static let lightBlue = Color(.displayP3, red: 53, green: 221, blue: 242)
    static let lightGreen = Color(.displayP3, red: 59, green: 242, blue: 80)
}

