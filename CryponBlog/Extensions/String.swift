//
//  String.swift
//  CryponBlog
//
//  Created by Furkan Başoğlu on 1.02.2022.
//

import Foundation

extension String {
    
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}
