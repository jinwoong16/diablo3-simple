//
//  WebService.swift
//  diablo3Before
//
//  Created by jinwoong Kim on 2023/04/04.
//

import Foundation

enum HttpMethod: String {
  case GET, POST
}

protocol WebService {
  var region: Region { get }
  var locale: Locale? { get }
  var session: URLSession { get }
  var baseURL: URL? { get }
}

extension WebService {
  func call(url: URL, method: HttpMethod = .GET, headers: [HttpHeader]? = nil, body: Data? = nil) async throws -> Data {
    var url = url
    
    if let locale = locale {
      url.append(
        queryItems: [
          URLQueryItem(name: "locale", value: locale.rawValue)
        ]
      )
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.httpBody = body
    headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
    
    let (data, response) = try await session.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
      throw HttpError.invalidRequest
    }
    
    return data
  }
}
