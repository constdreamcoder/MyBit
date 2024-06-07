//
//  Double+Ext.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/7/24.
//

import Foundation
import SwiftUI

extension Double {
    var changeRateColor: Color {
        if self > 0 {
            return .customRed
        } else if self == 0 {
            return .customBlack
        } else {
            return .customBlue
        }
    }
}
