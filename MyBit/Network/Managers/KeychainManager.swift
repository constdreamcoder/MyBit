//
//  KeychainManager.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/13/24.
//

import Foundation
import Security

@propertyWrapper
struct KeychainStorage {
    private let key: KeychainManager.Key

    var wrappedValue: String? {
        get {
            return KeychainManager.read(key: key.rawValue)
        }
        set {
            if let value = newValue {
                KeychainManager.create(key: key.rawValue, token: value)
            } else {
                KeychainManager.delete(key: key.rawValue)
            }
        }
    }

    init(key: KeychainManager.Key) {
        self.key = key
    }
}

struct KeychainManager {
    
    enum Key: String {
        case accessToken = "accessToken"
        case refreshToken = "refreshToken"
    }
    
    // Create
    static func create(key: String, token: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: token.data(using: .utf8, allowLossyConversion: false) as Any // 저장할 Token
        ]
        SecItemDelete(query) // Keychain은 Key값에 중복이 생기면, 저장할 수 없기 때문에 먼저 Delete해줌
        
        let status = SecItemAdd(query, nil)
        assert(status == noErr, "failed to save Token")
    }
    
    // Read
    static func read(key: String) -> String? {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue as Any, // CFData 타입으로 불러오라는 의미
            kSecMatchLimit: kSecMatchLimitOne // 중복되는 경우, 하나의 값만 불러오라는 의미
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        if status == errSecSuccess {
            if let retrievedData: Data = dataTypeRef as? Data {
                let value = String(data: retrievedData, encoding: String.Encoding.utf8)
                return value
            } else { return nil }
        } else {
            print("failed to loading, status code = \(status)")
            return nil
        }
    }
    
    // Delete
    static func delete(key: String) {
        let query: NSDictionary = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        let status = SecItemDelete(query)
        assert(status == noErr, "failed to delete the value, status code = \(status)")
    }
}