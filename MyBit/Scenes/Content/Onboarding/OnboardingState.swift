//
//  OnboardingState.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/13/24.
//

import Foundation

struct OnboardingState: StateType {
    var isLoading: Bool = false
    var userInfo: UserInfo? = nil
    var errorMessage: String? = nil
}
