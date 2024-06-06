//
//  CustomNavigationView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/6/24.
//

import SwiftUI

struct CustomNavigationView<Content: View>: View {
    
    private let content: Content
    private let title: String
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle(title)
                .listStyle(.plain)
                .toolbar  {
                    ProfileImage()
                }
        }
    }
}

