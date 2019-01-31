//
//  TokenState.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 01/09/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

import ReSwift

struct TokenState: StateType, Equatable, Codable {
  var token: String?

  init(token state: String? = "") {
    self.token = state
  }
}
