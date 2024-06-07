//
//  String+Ext.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/7/24.
//

import Foundation

extension String {
    var convertToLastUpdatedFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        guard let date = dateFormatter.date(from: self) else { return "" }
        
        dateFormatter.dateFormat = "M/d HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}
