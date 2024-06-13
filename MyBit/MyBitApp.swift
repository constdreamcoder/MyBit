//
//  MyBitApp.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/4/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct MyBitApp: App {
    
    init() {
        KakaoSDK.initSDK(appKey: APIKeys.kakaoNativeAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
                .onOpenURL(perform: { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        AuthController.handleOpenUrl(url: url)
                    }
                })
        }
    }
}
