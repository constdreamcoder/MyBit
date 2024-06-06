//
//  StateType.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/6/24.
//

import Foundation

protocol StateType {
    var isLoading: Bool { get }
    var errorMessage: String? { get }
}

extension StateType {
    var isLoading: Bool { false }
    var errorMessage: String? { nil }
}
