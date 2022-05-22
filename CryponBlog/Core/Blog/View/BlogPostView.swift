//
//  BlogPostView.swift
//  CryponBlog
//
//  Created by Furkan Başoğlu on 12.01.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct BlogPostView: View {
    
    var blogPost: BlogPost
    let store = FirestoreManager()
    
    @State var viewCount: Int?
    @State var uniqueViewCount: Int?
    
    var viewCountDisplay: String {
        if let viewCount = viewCount, let uniqueViewCount = uniqueViewCount {
            return "\(uniqueViewCount):\(viewCount)"
        } else {
            return "-:-"
        }
    }
    
    @ViewBuilder
    var viewCountView: some View {
        HStack {
            Image(systemName: "eye")
            Text(viewCountDisplay)
        }
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    WebImage(url: blogPost.image)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 310)
                        .frame(maxWidth: UIScreen.main.bounds.width)
                        .clipped()
                    
                    VStack {
                        HStack {
                            Text(blogPost.title)
                                .font(.title3)
                                .fontWeight(.heavy)
                                .foregroundColor(.primary)
                                .lineLimit(3)
                                .padding(.vertical, 15)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        
                        if blogPost.blogpost.hasPrefix("_") && blogPost.blogpost.hasSuffix("_") {
                            
                            Text(removeBold(text:blogPost.blogpost))
                                .multilineTextAlignment(.leading)
                                .font(.system(size: 14, weight: .bold, design: .default))
                                .foregroundColor(Color.primary.opacity(0.9))
                                .padding(.bottom, 25)
                                .frame(maxWidth: .infinity)
                        }else {
                            Text(blogPost.blogpost)
                                .multilineTextAlignment(.leading)
                                .font(.body)
                                .foregroundColor(Color.primary.opacity(0.9))
                                .padding(.bottom, 25)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    viewCountView
                }
            }
        }
    }
}

func removeBold(text: String) -> String {
    var changedText  = text
    changedText.removeFirst()
    changedText.removeLast()
    return changedText
}

struct BlogPostView_Previews: PreviewProvider {
    static let placeholder = BlogPost(id: "id placeholder", title: "This is a placeholder", subtitle: "A subtitle for the placeholder", image: URL(string: "https://media.nature.com/lw800/magazine-assets/d41586-020-03053-2/d41586-020-03053-2_18533904.jpg"), blogpost: "_Blog post_")
    
    static var previews: some View {
        BlogPostView(blogPost: placeholder)
        
        BlogPostView(blogPost: placeholder)
            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
            .previewDisplayName("iPhone 8")
            .preferredColorScheme(.dark)
    }
    
}
