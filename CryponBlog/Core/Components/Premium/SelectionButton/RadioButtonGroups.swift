//
//  RadioButtonGroups.swift
//  CryponBlog
//
//  Created by Furkan Başoğlu on 10.04.2022.
//

import SwiftUI

enum Packages: String {
    case months12 = "months12"
    case months1 = "months1"
}

struct RadioButtonGroups: View {
    let callback: (String) -> ()
    
    @State var selectedId: String = ""
    
    var body: some View {
        HStack {
            Spacer()
            
            radioMaleMajority
            
            Spacer(minLength: 10)
            
            radioFemaleMajority
            
            Spacer()
        }
    }
    
    var radioMaleMajority: some View {
        RadioButtonField(
            months: "12", price: "39.99", is12Months: true,
            id: Packages.months12.rawValue,
            label: Packages.months12.rawValue,
            isMarked: selectedId == Packages.months12.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    var radioFemaleMajority: some View {
        RadioButtonField(
            months: "1", price: "12.99", is12Months: false,
            id: Packages.months1.rawValue,
            label: Packages.months1.rawValue,
            isMarked: selectedId == Packages.months1.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    func radioGroupCallback(id: String) {
        selectedId = id
        callback(id)
    }
}
