//
//  AuthenticationWebService.swift
//  diablo3Before
//
//  Created by jinwoong Kim on 2023/04/04.
//

import Foundation

protocol AuthenticationWebService: WebService {
  var credentials: BlizzardCredentials { get set }
  
  func requestAccess() async throws -> Data
  func validate(token: Token) async -> Bool
}
