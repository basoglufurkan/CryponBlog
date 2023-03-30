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
    private let store = FirestoreManager()
    
    @State private var viewCount: Int?
    @State private var uniqueViewCount: Int?
    @State private var isFirstAppear = true
    
    private var viewCountDisplay: String {
        if let viewCount = viewCount, let uniqueViewCount = uniqueViewCount {
            return "\(uniqueViewCount):\(viewCount)"
        } else {
            return "-:-"
        }
    }
    
    @ViewBuilder
    private var viewCountView: some View {
        HStack {
//            Image(systemName: "eye")
            Text(viewCountDisplay)
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if let content = blogPost.content {
            RichTextView(content: content)
        } else {
            if blogPost.blogpost.hasPrefix("_") && blogPost.blogpost.hasSuffix("_") {
                
                Text(removeBold(text:blogPost.blogpost))
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 14, weight: .bold, design: .default))
                    .foregroundColor(Color.primary.opacity(0.9))
                    .padding(.bottom, 25)
                    .frame(maxWidth: .infinity)
            } else {
                Text(blogPost.blogpost)
                    .multilineTextAlignment(.leading)
                    .font(.body)
                    .foregroundColor(Color.primary.opacity(0.9))
                    .padding(.bottom, 25)
                    .frame(maxWidth: .infinity)
            }
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
                        
                        content
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
        .onAppear {
            if isFirstAppear {
                isFirstAppear = false
                
                Task {
                    await incrementViewCount()
                    await requestViewCount()
                }
            }
        }
    }
    
    private func incrementViewCount() async {
        let writeError = await store.incrementPostViewCount(postID: blogPost.id, postTitle: blogPost.title)
        if let error = writeError {
            print("Date: \(Date()), File: \(#filePath), Line: \(#line), Func: \(#function) --error when incrementPostViewCount-\(error)----")
        }
    }
    
    private func requestViewCount() async {
        let viewCountResult = await store.getPostViewCount(for: blogPost.id)
        switch viewCountResult {
        case .success(let count):
            self.viewCount = count
        case .failure(let error):
            print("Date: \(Date()), File: \(#filePath), Line: \(#line), Func: \(#function) --error when getPostViewCount-\(error)----")
        }
        
        let uniqueViewCountResult = await store.getUniquePostViewCount(for: blogPost.id)
        switch uniqueViewCountResult {
        case .success(let count):
            self.uniqueViewCount = count
        case .failure(let error):
            print("Date: \(Date()), File: \(#filePath), Line: \(#line), Func: \(#function) --error when getPostViewCount-\(error)----")
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
    static let placeholder = BlogPost(id: "id placeholder", title: "This is a placeholder", subtitle: "A subtitle for the placeholder", image: URL(string: "https://media.nature.com/lw800/magazine-assets/d41586-020-03053-2/d41586-020-03053-2_18533904.jpg"), blogpost: "_Blog post_", content: nil)
    
    static var previews: some View {
        BlogPostView(blogPost: placeholder)
        
        BlogPostView(blogPost: placeholder)
            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
            .previewDisplayName("iPhone 8")
            .preferredColorScheme(.dark)
    }
    
}
