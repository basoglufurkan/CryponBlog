//
//  PaywallView.swift
//  CryponBlog
//
//  Created by Ming-Ta Yang on 2022/7/2.
//

import SwiftUI
import StoreKit

struct Package: Equatable, Hashable {
    let productID: String
    let title: String
    let description: String
    let prompt: String
    let price: String
    let color: Color
    
    init(productID: String, title: String, description: String, prompt: String, price: String, color: Color) {
        self.productID = productID
        self.title = title
        self.description = description
        self.prompt = prompt
        self.price = price
        self.color = color
    }
    
    static var weeklyPackage: Package { .init(productID: SubscriptionProduct.weeklySub.productID,
                                              title: "Weekly",
                                              description: "Try making money",
                                              prompt: "First steops",
                                              price: UserDefaults.standard.string(forKey: SubscriptionProduct.weeklySub.productID) ?? "$12.99",
                                              color: .cyan) }
    
    static var monthlyPackage: Package { .init(productID: SubscriptionProduct.monthlySub.productID,
                                               title: "Monthly",
                                               description: "Pay less, get more",
                                               prompt: "Best price",
                                               price: UserDefaults.standard.string(forKey: SubscriptionProduct.monthlySub.productID) ?? "$39.99",
                                               color: .lightGreen) }
}

struct PaywallView: View {
    @State private var selectedProductID = SubscriptionProduct.weeklySub.productID
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject private(set) var storeManager: StoreManager
    @State private var packages: [Package] = [.weeklyPackage, .monthlyPackage]
    
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
                    ForEach(packages, id: \.self) { package in
                        PackageCellView(package: package, color: package.color, isSelected: selectedProductID == package.productID) {
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
        .onChange(of: storeManager.myProducts) { products in
            print("did change store Manager")
            
            // update price from App Store
            products.forEach {
                UserDefaults.standard.set($0.localizedPrice, forKey: $0.productIdentifier)
            }
            packages = [.weeklyPackage, .monthlyPackage]
        }
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
                    .foregroundColor(.cyan)
            }
            .frame(maxWidth: .infinity, minHeight: 60)
            .contentShape(Rectangle())
        }
        .overlay(clipShape.stroke(Color.cyan, lineWidth: 1))
        .background(
            clipShape
                .foregroundColor(.gray)
                .opacity(0.3)
        )
    }
}

struct PackageCellView: View {
    let package: Package
    let color: Color
    let isSelected: Bool
    let onTap: () -> Void
    
    var formattedPrice: some View {
        let splits = package.price.split(separator: ".")
        
        let text = Text(splits[0])
            .font(.title3)
            .fontWeight(.heavy)
            .foregroundColor(.cyan)
        
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
                .overlay(RoundedRectangle(cornerSize: .init(width: 16, height: 16)).stroke(color, lineWidth: 2))
                
                PromptBanner(title: package.prompt, color: color, radius: 16)
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

private extension SKProduct {
    var localizedPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)
    }
}

private extension Color {
    static let cyan = Color(.displayP3, red: 53, green: 221, blue: 242)
    static let lightGreen = Color(.displayP3, red: 59, green: 242, blue: 80)
}
