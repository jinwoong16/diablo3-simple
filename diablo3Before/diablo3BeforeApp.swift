//
//  diablo3BeforeApp.swift
//  diablo3Before
//
//  Created by jinwoong Kim on 2023/04/04.
//

import SwiftUI

import ComposableArchitecture

@main
struct diablo3BeforeApp: App {
//  let blizzardAPI = BlizzardAPI(credentials: .init(), region: .us, locale: .en_US)
  
  var body: some Scene {
    WindowGroup {
      Home(
        store: Store(
          initialState: HomeFeature.State(),
          reducer: HomeFeature()
//            .dependency(\.blizzardAPI, blizzardAPI)
        )
      )
    }
  }
}
