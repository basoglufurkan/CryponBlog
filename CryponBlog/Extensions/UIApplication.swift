//
//  UIApplication.swift
//  CryponBlog
//
//  Created by Furkan Başoğlu on 16.01.2022.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
