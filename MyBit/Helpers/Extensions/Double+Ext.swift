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
    
    var currencyFormat: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: self)) ?? "0.0"
    }
    
    var percentFormat: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        numberFormatter.maximumFractionDigits = 2
        
        return numberFormatter.string(from: NSNumber(value: self)) ?? "0.0"
    }
    
    var transactionPrice24HFormat: String {
        let valueInMillions = Int(self) / 1_000_000
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: valueInMillions)) ?? "0"
    }
}
