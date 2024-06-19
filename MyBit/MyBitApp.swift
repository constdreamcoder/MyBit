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
    
    @StateObject private var appIntent = AppIntent()
    
    init() {
        KakaoSDK.initSDK(appKey: APIKeys.kakaoNativeAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
                .onOpenURL(perform: { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        let _ = AuthController.handleOpenUrl(url: url)
                    }
                })
                .onAppear {
                    appIntent.send(.isLogin)
                }
                .environmentObject(appIntent)
        }
    }
}
