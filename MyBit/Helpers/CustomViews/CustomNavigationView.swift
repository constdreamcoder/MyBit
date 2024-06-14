//
//  CustomNavigationView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/6/24.
//

import SwiftUI

struct CustomNavigationView<Content: View>: View {
    
    private let title: String
    private let isProfile: Bool
    private let content: Content
    
    init(title: String, isProfile: Bool = false, @ViewBuilder content: () -> Content) {
        self.title = title
        self.isProfile = isProfile
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle(title)
                .listStyle(.plain)
                .toolbar  {
                    if !isProfile {
                        ProfileImage()
                    }
                }
        }
    }
}

