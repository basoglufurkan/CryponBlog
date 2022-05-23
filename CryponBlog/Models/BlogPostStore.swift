//
//  BlogPostStore.swift
//  CryponBlog
//
//  Created by Furkan Başoğlu on 12.01.2022.
//

import SwiftUI
import Contentful
//import Combine
import Foundation

// change to your spaceID and accessToken
// you can find these in Settings -> API keys on Contentful
let spaceId = "z6v8t7djocdh"
let accessToken = "GzQezJ5TzisnZNjA6pIWKzy7YxixjSowCIUT4jIn7W8"

let client = Client(spaceId: spaceId, accessToken: accessToken)

func getArray(id: String, completion: @escaping([Entry]) -> ()) {
    let query = Query.where(contentTypeId: id)
    try! query.order(by: Ordering(sys: .createdAt, inReverse: true)) // ordering the list of articles by created date
    
    client.fetchArray(of: Entry.self, matching: query) { result in
        switch result {
            case .success(let array):
                DispatchQueue.main.async {
                    completion(array.items)
                }
            case .failure(let error):
                print(error)
        }
    }
}


class BlogPostsStore: ObservableObject {
    @Published var blogPosts: [BlogPost] = articleList
    
    init() {
        DispatchQueue.main.async {
            self.refreshView()
        }
    }
    func refreshView(){
        blogPosts = []
        DispatchQueue.main.async {
            getArray(id: "cryponBlogApp") {items in
                items.forEach {(item) in
                    self.blogPosts.append(
                        BlogPost(
                            id: item.id,
                            title: item.fields["title"] as! String,
                            subtitle: item.fields["subtitle"] as! String,
                            image: item.fields.linkedAsset(at: "image")?.url ?? URL(string: ""),
                            blogpost: item.fields["blogpost"] as? String ?? "",
                            content: item.fields["content"] as? RichTextDocument,
                            featured: item.fields["featured"] as? Bool ?? false
                        )
                    )
                }
            }
        }
    }
}
