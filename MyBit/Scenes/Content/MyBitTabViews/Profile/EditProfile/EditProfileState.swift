//
//  EditProfileState.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/14/24.
//

import Foundation

struct EditProfileState: StateType {
    var isLoading: Bool = false
    var input: String = ""
    var validation: Bool = false
    var initialFlage: Bool = true
    var myProfile: MyProfileInfo? = nil
    var errorMessage: String? = nil
}
