//
//  Diablo3WebService.swift
//  diablo3Before
//
//  Created by jinwoong Kim on 2023/04/26.
//

import Foundation

/**
 Get diablo 3 community data with access token.
 The ref page is [here](https://develop.battle.net/documentation/diablo-3/community-apis).
 */
protocol Diablo3WebService: WebService {
  /// D3 Act API
  func getActIndex() async throws -> Data
  func getAct(by actId: Int) async throws -> Data
  
  /// D3 Artisan and Recipe API
  func getArtisan(by slug: String) async throws -> Data
  func getRecipe(by slug: String, recipeSlug: String) async throws -> Data
}
