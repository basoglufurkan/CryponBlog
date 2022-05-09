//
//  BuyButton.swift
//  CryponBlog
//
//  Created by Furkan Başoğlu on 10.04.2022.
//

import SwiftUI

struct BuyButton: View {
    var onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            Text("Buy")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.top, 20)
                .padding(.bottom, 20)
                .font(.system(size: 18, weight: .bold, design: .default))
                .background(Color.blue)
                .cornerRadius(10)
                .padding()
        }
        
    }
}

struct BuyButton_Previews: PreviewProvider {
    static var previews: some View {
        BuyButton(onClick: {
            
        })
    }
}

