//
//  TabState.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 31/08/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

import ReSwift

struct TabState: StateType, Equatable {
  var tabIndex: Int

  init(tabIndex state: Int = 0) {
    self.tabIndex = state
  }
}
