//
//  RoutingReducer.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 30/08/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

import ReSwift

func routingReducer(action: Action, state: RoutingState?) -> RoutingState {
  var state = state ?? RoutingState()

  switch action {
  case let routingAction as RoutingAction:
    state.navigationState =  routingAction.destination
  default:
    break
  }

  return state
}
