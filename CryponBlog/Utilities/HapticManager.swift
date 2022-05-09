//
//  HapticManager.swift
//  CryponBlog
//
//  Created by Furkan Başoğlu on 30.01.2022.
//

import Foundation
import SwiftUI

class HapticManager {
    
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
    
}
