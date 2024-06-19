//
//  AppState.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/18/24.
//

import Foundation

struct AppState: StateType {
    var isLoading: Bool = false
    var isLogin: Bool = false
    var errorMessage: String? = nil
}
