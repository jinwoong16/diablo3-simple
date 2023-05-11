//
//  Diablo3GameDataView.swift
//  diablo3Before
//
//  Created by jinwoong Kim on 2023/04/07.
//

import SwiftUI

import ComposableArchitecture

struct Diablo3GameDataFeature: ReducerProtocol {
  struct State: Equatable {}
  
  enum Action: Equatable {
    case empty
  }
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
      default:
        return .none
    }
  }
}

struct Diablo3GameDataView: View {
  let store: StoreOf<Diablo3GameDataFeature>
  
  var body: some View {
    Text("Game data")
  }
}

struct GameData_Previews: PreviewProvider {
  static var previews: some View {
    Diablo3GameDataView(
      store: Store(
        initialState: Diablo3GameDataFeature.State(),
        reducer: Diablo3GameDataFeature()
      )
    )
  }
}
