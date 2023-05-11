//
//  Token.swift
//  diablo3Before
//
//  Created by jinwoong Kim on 2023/04/04.
//

import Foundation

struct Token: Codable {
  let accessToken: String
  let tokenType: String
  let expiresIn: Int
  let sub: String
  
  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case tokenType = "token_type"
    case expiresIn = "expires_in"
    case sub
  }
}

extension Token: CustomStringConvertible {
  var description: String {
    return """
           {
              "token": "\(accessToken)",
              "type": "\(tokenType)",
              "expires_in": "\(expiresIn)",
              "sub": "\(sub)"
           }
           """
  }
}

enum TokenError: LocalizedError {
  case noToken
  
  var errorDescription: String? {
    switch self {
      case .noToken:
        return NSLocalizedString("There is no token in this device.", comment: "No Token")
    }
  }
}
