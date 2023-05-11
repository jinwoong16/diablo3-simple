//
//  DefaultDiablo3WebService.swift
//  diablo3Before
//
//  Created by jinwoong Kim on 2023/04/26.
//

import Foundation

final class DefaultDiablo3WebService: Diablo3WebService {
  enum APIs {
    case act
    case actById(Int)
    
    case artisan(String)
    case artisanRecipe(String, String)
    
    var path: String {
      switch self {
        case .act:
          return "/d3/data/act"
          
        case let .actById(id):
          return "/d3/data/act/\(id)"
          
        case let .artisan(slug):
          return "/d3/data/artisan/\(slug)"
          
        case let .artisanRecipe(slug, recipeSlug):
          return "/d3/data/artisan/\(slug)/recipe/\(recipeSlug)"
      }
    }
  }
  
  var region: Region
  var locale: Locale?
  var session: URLSession
  
  var baseURL: URL? { return URL(string: region.apiURI) }
  
  private var token: Token? { return KeychainHelper.standard.read(service: "blizzard-access-token", account: "blizzard") }
  
  init(region: Region, locale: Locale? = nil, session: URLSession) {
    self.region = region
    self.locale = locale
    self.session = session
  }
  
  func getActIndex() async throws -> Data {
    guard let token = token?.accessToken else { throw TokenError.noToken }
    guard var url = baseURL else { throw HttpError.invalidRequest }
    url.append(path: APIs.act.path)
    
    return try await call(
      url: url,
      method: .GET,
      headers: [.authorization(.bearer(token))]
    )
  }
  
  func getAct(by actId: Int) async throws -> Data {
    guard let token = token?.accessToken else { throw TokenError.noToken }
    guard var url = baseURL else { throw HttpError.invalidRequest }
    url.append(path: APIs.actById(actId).path)
    
    return try await call(
      url: url,
      method: .GET,
      headers: [.authorization(.bearer(token))]
    )
  }
  
  func getArtisan(by slug: String) async throws -> Data {
    guard let token = token?.accessToken else { throw TokenError.noToken }
    guard var url = baseURL else { throw HttpError.invalidRequest }
    url.append(path: APIs.artisan(slug).path)
    
    return try await call(
      url: url,
      method: .GET,
      headers: [.authorization(.bearer(token))]
    )
  }
  
  func getRecipe(by slug: String, recipeSlug: String) async throws -> Data {
    guard let token = token?.accessToken else { throw TokenError.noToken }
    guard var url = baseURL else { throw HttpError.invalidRequest }
    url.append(path: APIs.artisanRecipe(slug, recipeSlug).path)
    
    return try await call(
      url: url,
      method: .GET,
      headers: [.authorization(.bearer(token))]
    )
  }
}
