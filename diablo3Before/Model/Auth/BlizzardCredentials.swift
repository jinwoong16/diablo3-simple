//
//  BlizzardCredentials.swift
//  diablo3Before
//
//  Created by jinwoong Kim on 2023/04/04.
//

import Foundation

/**
 The Blizzard provides two ways of using OAuth: client-credentials-flow and authorization-code-flow.
 `BlizzardCredentials` object is used for the client-credentials-flow.
 This alone can give you a lot of information about the game.
 Client Credential Flow must make a POST request with the `multipart-form` data to the token URI: `grant-type=client_credentials`,
 and must pass basic authorization using the `client_id` as the user and the `client_secret` as the user password.
 More information about the Blizzard Client Credentials Flow is [here](https://develop.battle.net/documentation/guides/using-oauth/client-credentials-flow).
 */
struct BlizzardCredentials {
  var clientID: String {
    guard let id = Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID") as? String else {
      fatalError("‼️ NO CLIENT ID was found.")
    }
    return id
  }
  
  var clientSecret: String {
    guard let secret = Bundle.main.object(forInfoDictionaryKey: "CLIENT_SECRET") as? String else {
      fatalError("‼️ NO CLIENT SECRET was found.")
    }
    return secret
  }
  
  var encrypted: String? {
    return String(
      format: "%@:%@",
      clientID,
      clientSecret
    )
    .data(using: .utf8)?
    .base64EncodedString()
  }
}
