//
//  TokenReducer.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 01/09/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

import ReSwift

func tokenReducer(action: Action, state: TokenState?) -> TokenState {
  var state = state ?? TokenState()

  switch action {
  case let action as TokenChangeAction:
    state = action.token
  default:
    break
  }

  return state
}
