//
//  AppReducer.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 30/08/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {

  return AppState(
    routingState: routingReducer(action: action, state: state?.routingState),
    selectedBookIndex: selectBookIndexReducer(action: action, state: state?.selectedBookIndex),
    selectedBook: selectBookReducer(action: action, state: state?.selectedBook),
    ownBookList: ownBookListReducer(action: action, state: state?.ownBookList),
    searchParams: searchReducer(action: action, state: state?.searchParams),
    foundBookList: foundBooksReducer(action: action, state: state?.foundBookList),
    token: tokenReducer(action: action, state: state?.token)
  )
}
