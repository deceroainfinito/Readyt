//
//  RotuingState.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 30/08/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

import ReSwift

struct RoutingState: StateType, Equatable, Codable {
  var navigationState: RoutingDestination

  init(navigationState state: RoutingDestination = .bookList) {
    self.navigationState = state
  }
}
