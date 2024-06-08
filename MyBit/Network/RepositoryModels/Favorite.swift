//
//  Favorite.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/7/24.
//

import Foundation
import RealmSwift

final class Favorite: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var symbol: String
    @Persisted var imageURLString: String
    
    convenience init(id: String, name: String, symbol: String, imageURLString: String) {
        self.init()
        
        self.id = id
        self.name = name
        self.symbol = symbol
        self.imageURLString = imageURLString
    }
}
