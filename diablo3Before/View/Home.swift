//
//  Home.swift
//  diablo3Before
//
//  Created by jinwoong Kim on 2023/04/04.
//

import SwiftUI

import ComposableArchitecture

struct HomeFeature: ReducerProtocol {
  struct State: Equatable {
    var currentToken = "No"
    var isRequestInFlight = false
    
    var diablo3CommunityFeature = Diablo3CommunityFeature.State()
    var diablo3GameDataFeature = Diablo3GameDataFeature.State()
  }
  
  enum Action: Equatable {
    /// Home features
    case getTokenButtonTapped
    case currentTokenResult(TaskResult<String>)
    case deleteTokenButtonTapped
    
    /// Subfeatures
    case diablo3CommunityFeature(Diablo3CommunityFeature.Action)
    case diablo3GameDataFeature(Diablo3GameDataFeature.Action)
  }
  
  @Dependency(\.authRepository) var authRepository
  
  var body: some ReducerProtocol<State, Action> {
    Reduce(homeReducer(into:action:))
    
    Scope(state: \.diablo3CommunityFeature, action: /Action.diablo3CommunityFeature) {
      Diablo3CommunityFeature()
    }
    Scope(state: \.diablo3GameDataFeature, action: /Action.diablo3GameDataFeature) {
      Diablo3GameDataFeature()
    }
  }
  
  func homeReducer(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
      case .getTokenButtonTapped:
        state.isRequestInFlight = true
        return .task {
          await .currentTokenResult(
            TaskResult {
              try await self.authRepository.getAccessToken().accessToken
            }
          )
        }
        
      case .deleteTokenButtonTapped:
        return .fireAndForget {
          self.authRepository.delete()
        }
        
      case let .currentTokenResult(.success(token)):
        state.isRequestInFlight = false
        state.currentToken = token
        print("success getting the token!")
        return .none
        
      case .currentTokenResult(.failure):
        state.isRequestInFlight = false
        state.currentToken = "failed..."
        print("falied...")
        return .none
        
      default:
        return .none
    }
  }
}

struct Home: View {
  let store: StoreOf<HomeFeature>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      NavigationStack {
        Form {
          Section {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Button("GET TOKEN!") { viewStore.send(.getTokenButtonTapped) }
              .frame(maxWidth: .infinity)

            if viewStore.isRequestInFlight {
              Text("in flight ...")
            } else {
              Text("\(viewStore.currentToken)")
            }

            Button("DELETE") { viewStore.send(.deleteTokenButtonTapped) }
              .frame(maxWidth: .infinity)
          }

          Section("Diablo 3") {
            NavigationLink("Community APIs") {
              Diablo3CommunityView(
                store: self.store.scope(
                  state: \.diablo3CommunityFeature,
                  action: HomeFeature.Action.diablo3CommunityFeature
                )
              )
            }
            
            NavigationLink("Game Data APIs") {
              Diablo3GameDataView(
                store: self.store.scope(
                  state: \.diablo3GameDataFeature,
                  action: HomeFeature.Action.diablo3GameDataFeature
                )
              )
            }
            
          }
        }
      }
    }
  }
}

struct Home_Previews: PreviewProvider {
  static var previews: some View {
    Home(
      store: Store(
        initialState: HomeFeature.State(),
        reducer: HomeFeature()
      )
    )
  }
}
