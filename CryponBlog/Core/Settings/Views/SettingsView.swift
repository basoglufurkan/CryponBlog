//
//  SettingsView.swift
//  CryponBlog
//
//  Created by Furkan Başoğlu on 5.02.2022.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                // background
                Color.theme.background
                    .ignoresSafeArea()
                
                // content
                List {
                    swiftfulThinkingSection
                        .listRowBackground(Color.theme.background.opacity(0.5))
//                    coinGeckoSection
//                        .listRowBackground(Color.theme.background.opacity(0.5))
//                    developerSection
//                        .listRowBackground(Color.theme.background.opacity(0.5))
                    applicationSection
                        .listRowBackground(Color.theme.background.opacity(0.5))
                }
            }
            .font(.headline)
            .accentColor(.blue)
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
//                    XMarkButton()
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

extension SettingsView {
    
    private var swiftfulThinkingSection: some View {
        Section(header: Text("Crypon")) {
            VStack(alignment: .leading) {
                HStack {
                    Image("telinsta")
                        .resizable()
                        .frame(width: 150, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                }
                Text("Follow us on Instagram and Telegram.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Instagram 🥳", destination: AppConfig.instagramURL)
            Link("Telegram 🥳", destination: AppConfig.telegramURL)
        }
    }
    
    
    private var applicationSection: some View {
        Section(header: Text("Application")) {
            Link("Terms of Service", destination: AppConfig.tosURL)
            Link("Privacy Policy", destination: AppConfig.privacyURL)
            
        }
    }
    
    
}

