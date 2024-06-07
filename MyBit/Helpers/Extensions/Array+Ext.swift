//
//  Array+Ext.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/7/24.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
