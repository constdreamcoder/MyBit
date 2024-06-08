//
//  FavoriteRepository.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/7/24.
//

import Foundation
import RealmSwift

final class FavoriteRepository: RepositoryType {
    typealias T = Favorite
    
    static let shared = FavoriteRepository()
    
    var realm: Realm {
        return try! Realm()
    }
    
    private init() {}
}
