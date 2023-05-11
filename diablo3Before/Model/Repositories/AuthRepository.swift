//
//  AuthRepository.swift
//  diablo3Before
//
//  Created by jinwoong Kim on 2023/04/04.
//

import Foundation

import Dependencies

struct AuthRepository {
  var getAccessToken: @Sendable () async throws -> Token
  var validate: @Sendable (Token) async -> Bool
  
  /// Remove the token from keychain.
  var delete: () -> ()
}

extension AuthRepository: DependencyKey {
  static let liveValue: Self = .init(
    getAccessToken: {
      if let token = readToken(),
         await auth.validate(token: token) {
        return token
      } else {
        let data = try await auth.requestAccess()
        let decoder = JSONDecoder()
        let token = try decoder.decode(Token.self, from: data)
        save(token: token)

        return token
      }
    },
    validate: { token in
      return await auth.validate(token: token)
    },
    delete: {
      delete()
    }
  )
  
  private static var auth: AuthenticationWebService {
    @Dependency(\.blizzardAPI) var blizzardAPI
    return blizzardAPI.authentication
  }
  
  private static func save(token: Token) {
    KeychainHelper.standard.save(token, service: "blizzard-access-token", account: "blizzard")
  }
  
  private static func readToken() -> Token? {
    KeychainHelper.standard.read(service: "blizzard-access-token", account: "blizzard")
  }
  
  private static func delete() {
    KeychainHelper.standard.delete(service: "blizzard-access-token", account: "blizzard")
  }
}

extension DependencyValues {
  var authRepository: AuthRepository {
    get { self[AuthRepository.self] }
    set { self[AuthRepository.self] = newValue }
  }
}
