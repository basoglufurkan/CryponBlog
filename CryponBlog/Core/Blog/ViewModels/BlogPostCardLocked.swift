//
//  BlogPostCardLocked.swift
//  CryponBlog
//
//  Created by Furkan Başoğlu on 10.04.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct BlogPostCardLocked: View {
    @Binding var premiumBS: BottomSheetPremium
    var blogPost: BlogPost
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack{
                WebImage(url: blogPost.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)
                    .frame(maxWidth: UIScreen.main.bounds.width - 60)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .blur(radius: 10)
                
                Text("Locked")
                    .foregroundColor(.white)
                    .font(.system(size: 23, weight: .bold, design: .default))
            }
            VStack(spacing: 6) {
                HStack {
                    Text(blogPost.title)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(3)
                        .font(Font.title2.bold())
                        .foregroundColor(.primary)
                    Spacer()
                }
                
                HStack {
                    Text(blogPost.subtitle)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(3)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width - 60, alignment: .leading)
        .padding()
        .onTapGesture {
            premiumBS = .top
        }
    }
}

//struct BlogPostCardList_Previews: PreviewProvider {
//    static let store = BlogPostsStore()
//    static let placeholder = BlogPost(title: "This is a placeholder", subtitle: "A subtitle for the placeholder", image: URL(string: "https://media.nature.com/lw800/magazine-assets/d41586-020-03053-2/d41586-020-03053-2_18533904.jpg"), blogpost: "Blog post")
//
//    static var previews: some View {
//        BlogPostCardList(blogPost: placeholder)
//            .environmentObject(store)
//
//        BlogPostCardList(blogPost: placeholder)
//            .environmentObject(store)
//            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
//            .previewDisplayName("iPhone 8")
//            .preferredColorScheme(.dark)
//    }
//}


