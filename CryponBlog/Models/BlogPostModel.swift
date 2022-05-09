//
//  BlogPostModel.swift
//  CryponBlog
//
//  Created by Furkan Başoğlu on 12.01.2022.
//

import Foundation

struct BlogPost: Identifiable {
    let id = UUID() // needed for using ForEach statement
    
    var title: String
    var subtitle: String
    var image: URL?
    var blogpost: String
    var featured = false
}

var articleList: [BlogPost] = []

