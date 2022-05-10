//
//  AllPosts.swift
//  CryponBlog
//
//  Created by Furkan Başoğlu on 12.01.2022.
//

import SwiftUI

struct AllPosts: View {
    @EnvironmentObject var store: BlogPostsStore
    @Binding var premiumBS: BottomSheetPremium
    @StateObject var storeManager: StoreManager
    var unlockAllPosts: Bool
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(store.blogPosts.enumerated()), id: \.offset) { index, element in
                    if storeManager.myProducts.isEmpty {
                        if index > 3 {
                            NavigationLink(destination: BlogPostView(blogPost: store.blogPosts[index])) {
                                BlogPostCardList(blogPost: store.blogPosts[index])
                            }
                        } else {
                            BlogPostCardLocked(premiumBS: $premiumBS, blogPost: store.blogPosts[index])
                        }
                    } else if !unlockAllPosts {
                        if index > 3 {
                            NavigationLink(destination: BlogPostView(blogPost: store.blogPosts[index])) {
                                BlogPostCardList(blogPost: store.blogPosts[index])
                            }
                        } else {
                            BlogPostCardLocked(premiumBS: $premiumBS, blogPost: store.blogPosts[index])
                        }
                    } else {
                        NavigationLink(destination: BlogPostView(blogPost: store.blogPosts[index])) {
                            BlogPostCardList(blogPost: store.blogPosts[index])
                        }
                    }
                }
                
            }
            .navigationTitle("Signals")
            .listStyle(InsetListStyle())
        }
        .navigationViewStyle(.stack)
    }
}

struct AllPosts_Previews: PreviewProvider {
    static var previews: some View {
        AllPosts(premiumBS: .constant(.hidden), storeManager: StoreManager(), unlockAllPosts: false)
    }
}

