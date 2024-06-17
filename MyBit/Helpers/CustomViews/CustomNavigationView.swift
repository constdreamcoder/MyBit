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
    @Binding var profileImage: String
    
    init(
        title: String,
        isProfile: Bool = false,
        profileImage: Binding<String> = .constant(""),
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.isProfile = isProfile
        self._profileImage = profileImage
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle(title)
                .listStyle(.plain)
                .toolbar  {
                    if !isProfile {
                        ProfileImageView(imageURL: "\(APIKeys.userBaseURL)\(profileImage)")
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 36, height: 36)
                            .background(.customWhite)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(.brandPoint, lineWidth: 3.0))
                    }
                }
        }
    }
}

