//
//  PaywallView.swift
//  CryponBlog
//
//  Created by Furkan Başoğlu on 02.07.2022
//

import SwiftUI
import StoreKit

struct PaywallView: View {
    @State private var selectedProductID = SubscriptionProduct.weeklySub.productID
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject private(set) var storeManager: StoreManager
    @AppStorage(SubscriptionProduct.weeklySub.productID) var weeklySubPrice = "$12.99"
    @AppStorage(SubscriptionProduct.monthlySub.productID) var monthlySubPrice = "$39.99"
    
    // update to use stored App Store price instead of fixed price
    private var packages: [Package] {
        var weeklyPackage = Package.weeklyPackage
        weeklyPackage.price = weeklySubPrice
        var monthlyPackage = Package.monthlyPackage
        monthlyPackage.price = monthlySubPrice
        
        return [weeklyPackage, monthlyPackage]
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack {
                Image("back")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    Image("clogoseffaf")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                    Text("Get access to our private signals and become rich with us!")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    ForEach(packages, id: \.productID) { package in
                        PackageCellView(package: package, isSelected: selectedProductID == package.productID) {
                            selectedProductID = package.productID
                        }
                        .frame(maxHeight: 80)
                        .padding([.top])
                    }

                    Spacer()
                    
                    SubscriptionButton {
                        presentationMode.wrappedValue.dismiss()
                        
                        if let product = storeManager.myProducts.first(where: { $0.productIdentifier == selectedProductID })  {
                            storeManager.purchaseProduct(product: product)
                        }
                    }
                    
                    HStack {
                        FooterNoteButton(title: "Privacy Policy") {
                            UIApplication.shared.open(AppConfig.privacyURL)
                        }
                        Spacer()
                        FooterNoteButton(title: "Restore") {
                            presentationMode.wrappedValue.dismiss()
                            
                            storeManager.restorePurchases { _ in }
                        }
                        Spacer()
                        FooterNoteButton(title: "Terms of Use") {
                            UIApplication.shared.open(AppConfig.tosURL)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    
                }
                .padding()
            }
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .foregroundColor(.white)
            .opacity(0.8)
            .padding()
        }
        .animation(.easeInOut)
    }
}

struct FooterNoteButton: View {
    let title: String
    let onTap: () -> Void
    
    var body: some View {
        Button(title, action: onTap)
            .font(.footnote)
            .foregroundColor(.gray)
    }
}

struct SubscriptionButton: View {
    let onTap: () -> Void
    
    private let clipShape = RoundedRectangle(cornerRadius: 16)
    
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack {
                Text("SUBSCRIBE")
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                Image(systemName: "arrowtriangle.forward.fill")
                    .resizable()
                    .frame(width: 8, height: 8)
                    .foregroundColor(.lightBlue)
            }
            .frame(maxWidth: .infinity, minHeight: 60)
            .contentShape(Rectangle())
        }
        .overlay(clipShape.stroke(Color.lightBlue, lineWidth: 1))
        .background(
            clipShape
                .foregroundColor(.gray)
                .opacity(0.3)
        )
    }
}

struct PackageCellView: View {
    let package: Package
    let isSelected: Bool
    let onTap: () -> Void
    
    var formattedPrice: some View {
        let splits = package.price.split(separator: ".")
        
        let text = Text(splits[0])
            .font(.title3)
            .fontWeight(.heavy)
            .foregroundColor(.lightBlue)
        
        if splits.count == 2 {
            return text +
            Text("."+splits[1])
                .font(.title3)
                .fontWeight(.heavy)
                .foregroundColor(.gray)
        } else {
            return text
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomTrailing) {
                HStack(alignment: .top) {
                    Image(systemName: isSelected ? "circle.inset.filled" : "circle")
                        .foregroundColor(isSelected ? .white : .gray)
                    
                    VStack(alignment: .leading) {
                        Text(package.title)
                            .foregroundColor(.white)
                        Text(package.description)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    formattedPrice
                    
                }
                .padding()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .overlay(RoundedRectangle(cornerSize: .init(width: 16, height: 16)).stroke(package.color, lineWidth: 2))
                
                PromptBanner(title: package.prompt, color: package.color, radius: 16)
                    .frame(width: 100, height: 24)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}

struct PromptBanner: View {
    let title: String
    let color: Color
    let radius: CGFloat
    
    var body: some View {
        ZStack {
            color
                .clipShape(PartialRoundedCorner(radius: radius))
            Text(title)
                .font(.caption)
                .bold()
        }
    }
}

struct PartialRoundedCorner: Shape {
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        let width = rect.width
        let height = rect.height
        
        p.move(to: .init(x: 0, y: height))
        p.addLine(to: .init(x: 0, y: radius))
        p.addArc(center: .init(x: radius, y: radius), radius: radius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        p.addLine(to: .init(x: width, y: 0))
        p.addLine(to: .init(x: width, y: height-radius))
        p.addArc(center: .init(x: width-radius, y: height-radius), radius: radius, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        
        return p
    }
}

struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView(storeManager: StoreManager(onPurchaseProduct: { _ in }))
    }
}
