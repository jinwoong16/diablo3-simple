//
//  Region.swift
//  diablo3Before
//
//  Created by jinwoong Kim on 2023/04/04.
//

import Foundation

/// The Blizzard API varies by region,
/// and there are also differences in endpoints.
/// More information is [here](https://develop.battle.net/documentation/guides/regionality-and-apis).
enum Region: String, CaseIterable, Codable {
  case kr
  case us
  
  var oauthURI: String {
    return "https://oauth.battle.net"
  }
  
  var tokenURI: String {
    return "https://oauth.battle.net/token"
  }
  
  var apiURI: String {
    return "https://\(self.rawValue).api.blizzard.com"
  }
  
  func checkTokenURI(token: String) -> String {
    "https://oauth.battle.net/oauth/check_token?token=\(token)"
  }
}
