//
//  EditProfileIntent.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/14/24.
//

import Foundation
import Combine

final class EditProfileIntent: IntentType {
    enum Action {
        case initialize(previousInput: String)
        case writeInput(input: String)
        case write(input: String, inputType: EditProfileInputType)
        case editMyProfile(inputType: EditProfileInputType)
    }
    
    @Published private(set) var state = EditProfileState()
    
    var cancelable = Set<AnyCancellable>()
        
    func send(_ action: Action) {
        switch action {
        case .initialize(let previousInput):
            initialize(previousInput)
        case .writeInput(let input):
            writeInput(input)
        case .write(let input, let inputType):
            write(input, inputType: inputType)
        case .editMyProfile(let inputType):
            editMyProfile(inputType)
        }
    }
}

extension EditProfileIntent {
    private func editMyProfile(_ inputType: EditProfileInputType) {
        
        var editMyProfileResult: AnyPublisher<MyProfileInfo, NetworkErrors>
        
        switch inputType {
        case .nickname:
            editMyProfileResult = UserManager.editMyProfile(nickname: state.input)
        case .phone:
            editMyProfileResult = UserManager.editMyProfile(phone: state.input)
        }
        
        editMyProfileResult
            .sink { [weak self] completion in
                guard let self else { return }
                
                if case .failure(let error) = completion {
                    print("errors", error)
                    state.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                }
                state.isLoading = false
            } receiveValue: { [weak self] myProfileInfo in
                guard let self else { return }
                
                print("myProfileInfo", myProfileInfo)

                state.myProfile = myProfileInfo
            }
            .store(in: &cancelable)

        
    }
}

extension EditProfileIntent {
    
    private func initialize(_ previousInput: String) {
        state.input = previousInput
        state.initialFlage = false
    }
    
    private func writeInput(_ input: String) {
        state.input = input
    }
    
    private func write(_ input: String, inputType: EditProfileInputType) {
        
        switch inputType {
        case .nickname:
            writeNickname(input)
        case .phone:
            writePhone(input)
        }
        
        print("input:", state.input)
    }
    
    private func writeNickname(_ input: String) {
        state.input = input
        state.validation = InputKind.nickname(input: input).isValid
    }
    
    private func writePhone(_ input: String) {        
        state.input = InputKind.phone(input: input).formatPhoneNumber
        state.validation = InputKind.isValidFormattedPhoneNumber(state.input)
        print("validation", state.validation)
    }
}
