//
//  ProfileImageView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/16/24.
//

import Kingfisher
import SwiftUI
import UIKit

struct ProfileImageView: UIViewRepresentable {
    
    var imageURL: String
        
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.tintColor = .black
        imageView.contentMode = .scaleToFill
        imageView.tintColor = .customGray
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        let url = URL(string: imageURL)
        let placeholderImage = UIImage(systemName: "photo")
        uiView.kf.setImageWithAuthHeaders(with: url, placeholder: placeholderImage)
    }
}
