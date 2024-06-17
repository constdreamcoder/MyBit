//
//  ProfilePhotoView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/16/24.
//

import SwiftUI
import PhotosUI

struct ProfilePhotoView: View {
    
    @Binding var showImagePicker: Bool
    var imageURL: String
    
    var body: some View {

        ProfileImageView(imageURL: "\(APIKeys.userBaseURL)\(imageURL)")
            .aspectRatio(1, contentMode: .fit)
            .foregroundStyle(.customGray)
            .background(.customWhite)
            .frame(width: 70, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(alignment: .bottomTrailing) {
                Image(systemName: "camera.circle.fill")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .background(.customWhite)
                    .foregroundStyle(.brandPoint)
                    .frame(width: 20)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.customWhite, lineWidth: 4.0))
            }
            .onTapGesture {
                showImagePicker = true
            }
    }
}

