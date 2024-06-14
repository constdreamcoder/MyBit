//
//  ProfileState.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/14/24.
//

import Foundation

struct ProfileState: StateType {
    var isLoading: Bool = false
    var myProfile: MyProfileInfo? = nil
    var errorMessage: String? = nil
}
