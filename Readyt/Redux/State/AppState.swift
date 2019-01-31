//
//  AppState.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 30/08/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

import ReSwift

struct AppState: StateType, Codable {
  var routingState: RoutingState
  var selectedBookIndex: SelectedBookIndexState
  var selectedBook: SelectedBookState
  var ownBookList: BookItemsState
  var searchParams: BookFetchParamsState
  var foundBookList: FoundBooksItemsState
  var token: TokenState
}
