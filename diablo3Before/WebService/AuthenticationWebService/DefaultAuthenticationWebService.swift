//
//  DefaultAuthenticationWebService.swift
//  diablo3Before
//
//  Created by jinwoong Kim on 2023/04/04.
//

import Foundation

final class DefaultAuthenticationWebService: AuthenticationWebService {
  var credentials: BlizzardCredentials
  var region: Region
  var locale: Locale?
  var session: URLSession
  
  var baseURL: URL? { return nil }
  
  init(credentials: BlizzardCredentials, region: Region, locale: Locale?, session: URLSession) {
    self.credentials = credentials
    self.region = region
    self.locale = locale
    self.session = session
  }
  
  func requestAccess() async throws -> Data {
    guard let encrypted = credentials.encrypted,
          let url = URL(string: region.tokenURI) else {
      throw HttpError.invalidRequest
    }
    
    guard let body = "grant_type=client_credentials".data(using: .utf8) else {
      throw HttpError.unexpectedBody
    }
    
    return try await call(
      url: url,
      method: .POST,
      headers: [
        .contentType(.form),
        .authorization(.basic(encrypted))
      ],
      body: body
    )
  }
  
  func validate(token: Token) async -> Bool {
    guard let url = URL(string: region.checkTokenURI(token: token.accessToken)),
          let _ = try? await call(url: url)
    else {
      return false
    }
    
    return true
  }
}
