//
//  Middleware.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 31/08/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

import ReSwift

let logginMiddleware: Middleware<Any> = { dispatch, getState in
  return { next in
    return { action in
      //TODO: Action logging!
      print(action)
      return next(action)
    }
  }
}
