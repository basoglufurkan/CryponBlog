//
//  PaywallView.swift
//  CryponBlog
//
//  Created by Ming-Ta Yang on 2022/7/2.
//

import SwiftUI
import Contentful

extension Color {
    static let cyan = Color(.displayP3, red: 53, green: 221, blue: 242, opacity: 1)
}

struct Package: Equatable {
    let title: String
    let description: String
    let prompt: String
    let price: String
    
    static let weeklyPackage = Package(title: "Weekly", description: "Try making money", prompt: "First steps", price: "$49.99")
    static let monthlyPackage = Package(title: "Monthly", description: "Pay less, get more", prompt: "Best price", price: "$799.99")
}


struct PaywallView: View {
    @State private var selectedPackage: Package?
    @Environment(\.presentationMode) var presentationMode
    
    let storeManager: StoreManager
    
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
                        .frame(width: 300, height: 300)
                    Text("Get access to our private signals and become rich with us!")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    PackageCellView(package: .weeklyPackage, color: .cyan, isSelected: selectedPackage == .weeklyPackage) {
                        selectedPackage = .weeklyPackage
                    }
                    .padding(.bottom)
                    PackageCellView(package: .monthlyPackage, color: .green, isSelected: selectedPackage == .monthlyPackage) {
                        selectedPackage = .monthlyPackage
                    }
                    Spacer()
                    
                    SubscribeButton {
                    }
                    
                    HStack {
                        FooterNoteButton(title: "Privacy Policy") {
                            UIApplication.shared.open(AppConfig.privacyURL)
                        }
                        Spacer()
                        FooterNoteButton(title: "Restore") {
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
                Label("Close", systemImage: "xmark.circle.fill")
                    .labelStyle(.iconOnly)
            }
            .foregroundColor(.white)
            .opacity(0.8)
            .padding()
        }
        .onAppear {
            selectedPackage = .weeklyPackage
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

struct SubscribeButton: View {
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
        }
        .padding()
        .frame(maxWidth: .infinity)
        .overlay(clipShape.stroke(Color.cyan, lineWidth: 1))
        .background(
            clipShape
                .foregroundColor(.gray)
                .opacity(0.3)
        )
        .contentShape(Rectangle())
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
            .font(.headline)
            .foregroundColor(.cyan)
        
        if splits.count == 2 {
            return text +
            Text("."+splits[1])
                .font(.headline)
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
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading) {
                        Text(package.title)
                            .font(.title3)
                            .foregroundColor(.white)
                        Text(package.description)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    formattedPrice
                    
                }
                .padding()
                .overlay(RoundedRectangle(cornerSize: .init(width: 16, height: 16)).stroke(color, lineWidth: 2))
                
                PromptBanner(title: package.prompt, color: color, radius: 16)
                    .frame(width: 120, height: 28)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .frame(height: 100)
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
                .clipShape(RoundedCorner(radius: radius, corners: [.topLeft, .bottomRight]))
            Text(title)
                .bold()
        }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 16
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: .init(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView(storeManager: StoreManager(onPurchaseProduct: { _ in }))
    }
}
