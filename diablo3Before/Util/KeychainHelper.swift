//
//  KeychainHelper.swift
//  diablo3Before
//
//  Created by jinwoong Kim on 2023/04/06.
//

import Foundation

final class KeychainHelper {
  static let standard = KeychainHelper()
  private init() {}
  
  func save<T>(_ item: T, service: String, account: String) where T: Codable {
    do {
      let data = try JSONEncoder().encode(item)
      save(data, service: service, account: account)
    } catch {
      assertionFailure("‼️ Fail to encode item for keychain: \(error)")
    }
  }
  
  func read<T>(service: String, account: String) -> T? where T: Codable {
    guard let data = read(service: service, account: account) else {
      return nil
    }
    
    do {
      let item = try JSONDecoder().decode(T.self, from: data)
      return item
    } catch {
      assertionFailure("‼️ Fail to decode item for keychain: \(error)")
      return nil
    }
  }
  
  func delete(service: String, account: String) {
    let query = [
      kSecAttrService: service,
      kSecAttrAccount: account,
      kSecClass: kSecClassGenericPassword
    ] as CFDictionary
    
    let status = SecItemDelete(query)
    
    if status != errSecSuccess {
      print("Error: \(status)")
    }
  }
}

private extension KeychainHelper {
  func save(_ data: Data, service: String, account: String) {
    let query = [
      kSecValueData: data,
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: account
    ] as CFDictionary
    
    let status = SecItemAdd(query, nil)
    
    if status == errSecDuplicateItem {
      let query = [
        kSecAttrService: service,
        kSecAttrAccount: account,
        kSecClass: kSecClassGenericPassword
      ] as CFDictionary
      
      let attributesToUpdate = [kSecValueData: data] as CFDictionary
      
      SecItemUpdate(query, attributesToUpdate)
    }
  }
  
  func read(service: String, account: String) -> Data? {
    let query = [
      kSecAttrService: service,
      kSecAttrAccount: account,
      kSecClass: kSecClassGenericPassword,
      kSecReturnData: true
    ] as CFDictionary
    
    var result: AnyObject?
    SecItemCopyMatching(query, &result)
    
    return (result as? Data)
  }
}
