//
//  CustomNavigationView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/6/24.
//

import SwiftUI

struct CustomNavigationView<Content: View>: View {
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle("Search")
                .listStyle(.plain)
                .toolbar  {
                    ProfileImage()
                }
        }
    }
}

