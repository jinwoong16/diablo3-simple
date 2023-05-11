//
//  Diablo3CommunityView.swift
//  diablo3Before
//
//  Created by jinwoong Kim on 2023/04/07.
//

import SwiftUI

import ComposableArchitecture

struct Diablo3CommunityFeature: ReducerProtocol {
  struct State: Equatable {
    var isRequestInFlight = false
    var actInfo = ""
  }
  
  enum Action: Equatable {
    case buttonTapped
    case actResult(TaskResult<String>)
  }
  
  @Dependency(\.d3Repository) var d3Repository
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
      case .buttonTapped:
        state.isRequestInFlight = true
        return .task {
          await .actResult(
            TaskResult {
              try await self.d3Repository.getAct()
            }
          )
        }
        
      case let .actResult(.success(actInfo)):
        state.isRequestInFlight = false
        state.actInfo = actInfo
        return .none
        
      case let .actResult(.failure(error)):
        print("failed with: ", error)
        
        state.isRequestInFlight = false
        state.actInfo = ""
        return .none
    }
  }
}

struct Diablo3CommunityView: View {
  let store: StoreOf<Diablo3CommunityFeature>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      Form {
        Section {
          Text("Community")
          Button("Get All Act") { viewStore.send(.buttonTapped) }
            .frame(maxWidth: .infinity)
        }
        
        Section("Act result") {
          if viewStore.isRequestInFlight {
            Text("in flight ...")
          } else {
            Text("\(viewStore.actInfo)")
          }
        }
      }
    }
  }
}

struct Community_Previews: PreviewProvider {
  static var previews: some View {
    Diablo3CommunityView(
      store: Store(
        initialState: Diablo3CommunityFeature.State(),
        reducer: Diablo3CommunityFeature()
      )
    )
  }
}
