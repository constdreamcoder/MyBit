//
//  ProfileView.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/6/24.
//

import SwiftUI
import PhotosUI
import Combine

struct ProfileView: View {
    
    @StateObject private var intent = ProfileIntent()
    @State private var selection: String? = nil
    @State private var showImagePicker: Bool = false
    @Binding var profileImage: String

    private var configuration : PHPickerConfiguration {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.selectionLimit = 1
        config.preferredAssetRepresentationMode = .current
        return config
    }
    
    var body: some View {
        CustomNavigationView(title: "Profile", isProfile: true) {
            VStack {
                ProfilePhotoView(
                    showImagePicker: $showImagePicker,
                    imageURL: intent.state.myProfile?.profileImage ?? ""
                )
                
                if #available(iOS 16.0, *) {
                    List {
                        Section {
                            NavigationLink(
                                destination: EditProfileView(
                                    navigationTitle: "닉네임",
                                    placeholder: "닉네임을 입력하세요", 
                                    previousInput: intent.state.myProfile?.nickname ?? "",
                                    inputType: .nickname, 
                                    selection: $selection
                                ),
                                tag: "1",
                                selection: $selection
                            ) {
                                ProfileCell(title: "닉네임", data: intent.state.myProfile?.nickname)
                            }
                            NavigationLink(
                                destination: EditProfileView(
                                    navigationTitle: "연락처",
                                    placeholder: "연락처를 입력하세요",
                                    previousInput: intent.state.myProfile?.phone ?? "",
                                    inputType: .phone, 
                                    selection: $selection
                                ),
                                tag: "2",
                                selection: $selection
                            ) {
                                ProfileCell(title: "연락처", data: intent.state.myProfile?.phone)
                            }
                        }
                        
                        Section {
                            ProfileCell(title: "이메일", data: intent.state.myProfile?.email)
                            ProfileCell(title: "연결된 소설 계정", socialLoginImage: intent.state.myProfile?.provider?.image)
                            ProfileCell(title: "로그아웃")
                        }
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                    .background(.customLightGray)
                } else {
                    // TODO: - iOS15 version 대응
                }
            }
            .background(.customLightGray)
            .sheet(isPresented: $showImagePicker, content: {
                PhotoPicker(configuration: configuration, isPresented: $showImagePicker) { selectedImages in
                    intent.send(.uploadData(imageData: selectedImages))
                }
            })
            .onAppear {
                intent.send(.fetchMyProfile)
            }
        }
        .onReceive(Just(intent.state.myProfile)) { newValue in
            if newValue != nil {
                profileImage = newValue?.profileImage ?? ""
            }
        }
        
    }
}

#Preview {
    ProfileView(profileImage: .constant(""))
}

struct ProfileCell: View {
    let title: String
    let data: String?
    let socialLoginImage: String?
    
    init(title: String, data: String? = nil, socialLoginImage: String? = nil) {
        self.title = title
        self.data = data
        self.socialLoginImage = socialLoginImage
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 13, weight: .bold))
            
            Spacer()
            
            if let socialLoginImage = socialLoginImage,
                !socialLoginImage.isEmpty && (data == nil || data == "") {
                Image(socialLoginImage)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 20)
            } else {
                Text(data ?? "")
                    .foregroundStyle(.customDarkGray)
                    .font(.system(size: 13))
            }
    
        }
        .listRowSeparator(.hidden)
    }
}
