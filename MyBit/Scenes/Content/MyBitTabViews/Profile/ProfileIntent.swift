//
//  ProfileIntent.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/14/24.
//

import Foundation
import Combine

final class ProfileIntent: IntentType {
    enum Action {
        case fetchMyProfile
    }
    
    @Published private(set) var state = ProfileState()
    
    var cancelable = Set<AnyCancellable>()
        
    func send(_ action: Action) {
        switch action {
        case .fetchMyProfile:
            fetchMyProfile()
        }
    }
}

extension ProfileIntent {
    private func fetchMyProfile() {
        UserManager.fetchMyProfile()
            .sink { [weak self] completion in
                guard let self else { return }
                
                if case .failure(let error) = completion {
                    print("errors", error)
                    state.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                }
                state.isLoading = false
            } receiveValue: { [weak self] myProfileInfo in
                guard let self else { return }

                state.myProfile = myProfileInfo
            }
            .store(in: &cancelable)
    }
}