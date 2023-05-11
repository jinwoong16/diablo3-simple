//
//  BlizzardAPI.swift
//  diablo3Before
//
//  Created by jinwoong Kim on 2023/04/04.
//

import Foundation

import Dependencies

final class BlizzardAPI {
  var credentials: BlizzardCredentials
  private let session: URLSession
  private let region: Region
  private let locale: Locale?
  
  private(set) lazy var authentication = DefaultAuthenticationWebService(
    credentials: credentials,
    region: region,
    locale: locale,
    session: session
  )
  private(set) lazy var diablo3 = DefaultDiablo3WebService(
    region: region,
    locale: locale,
    session: session
  )
  
  init(credentials: BlizzardCredentials, session: URLSession = .shared, region: Region, locale: Locale? = nil) {
    self.credentials = credentials
    self.session = session
    self.region = region
    self.locale = locale
  }
}

extension BlizzardAPI: DependencyKey {
  static let liveValue: BlizzardAPI = .init(credentials: BlizzardCredentials(), region: .kr, locale: .ko_KR)
}

extension DependencyValues {
  var blizzardAPI: BlizzardAPI {
    get { self[BlizzardAPI.self] }
    set { self[BlizzardAPI.self] = newValue }
  }
}
