//
//  Diablo3Repository.swift
//  diablo3Before
//
//  Created by jinwoong Kim on 2023/04/26.
//

import Foundation

import Dependencies

struct Diablo3Repository {
  var getAct: @Sendable () async throws -> String
  var getActById: @Sendable (Int) async throws -> String
}

extension Diablo3Repository: DependencyKey {
  static let liveValue: Diablo3Repository = .init(
    getAct: {
      let data = try await d3.getActIndex()
      let rawString = String(decoding: data, as: UTF8.self)
      
      return rawString
    },
    getActById: { actId in
      let data = try await d3.getAct(by: actId)
      let rawString = String(decoding: data, as: UTF8.self)
      
      return rawString
    }
  )
  
  private static var d3: Diablo3WebService {
    @Dependency(\.blizzardAPI) var blizzardAPI
    return blizzardAPI.diablo3
  }
}

extension DependencyValues {
  var d3Repository: Diablo3Repository {
    get { self[Diablo3Repository.self] }
    set { self[Diablo3Repository.self] = newValue }
  }
}
