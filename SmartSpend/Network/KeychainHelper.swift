////
////  KeychainHelper.swift
////  SmartSpend
////
////  Created by Refik Jaija on 20.8.25.
////
//
//// Utils/KeychainHelper.swift
//import Foundation
//import Security
//
//class KeychainHelper {
//    static let standard = KeychainHelper()
//    private init() {}
//
//    func save(_ data: String, service: String, account: String) {
//        let data = Data(data.utf8)
//        let query = [
//            kSecClass: kSecClassGenericPassword,
//            kSecAttrService: service,
//            kSecAttrAccount: account,
//            kSecValueData: data
//        ] as CFDictionary
//
//        SecItemDelete(query)
//        SecItemAdd(query, nil)
//    }
//
//    func read(service: String, account: String) -> String? {
//        let query = [
//            kSecClass: kSecClassGenericPassword,
//            kSecAttrService: service,
//            kSecAttrAccount: account,
//            kSecReturnData: true,
//            kSecMatchLimit: kSecMatchLimitOne
//        ] as CFDictionary
//
//        var dataTypeRef: AnyObject?
//        if SecItemCopyMatching(query, &dataTypeRef) == noErr {
//            if let data = dataTypeRef as? Data {
//                return String(data: data, encoding: .utf8)
//            }
//        }
//        return nil
//    }
//}


//
//  KeychainHelper.swift
//  SmartSpend
//
//  Created by Refik Jaija on 20.8.25.
//

// Utils/KeychainHelper.swift
import Foundation
import Security

class KeychainHelper {
    static let standard = KeychainHelper()
    private init() {}

    func save(_ data: String, service: String, account: String) {
        let data = Data(data.utf8)
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecValueData: data
        ] as CFDictionary

        SecItemDelete(query)
        SecItemAdd(query, nil)
    }

    func read(service: String, account: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var dataTypeRef: AnyObject?
        if SecItemCopyMatching(query, &dataTypeRef) == noErr {
            if let data = dataTypeRef as? Data {
                return String(data: data, encoding: .utf8)
            }
        }
        return nil
    }
    
    // NEW: Add delete method for token cleanup
    func delete(service: String, account: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary
        
        SecItemDelete(query)
    }
    
    // NEW: Delete all keychain items for the app
    func deleteAll() {
        let query = [kSecClass: kSecClassGenericPassword] as CFDictionary
        SecItemDelete(query)
    }
}
