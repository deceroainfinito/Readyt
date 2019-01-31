//
//  Actions.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 31/08/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//
import Foundation
import ReSwift

struct TokenChangeAction: Action {
  let token: TokenState
}

struct RoutingAction: Action {
  let destination: RoutingDestination
}

struct BookFetchAction: Action {
  let params: BookFetchParamsState
}

struct UpdateSelectedBookIndexAction: Action {
  let index: SelectedBookIndexState
}

struct ResetSelectedIndexAction: Action {}

struct BookResetAction: Action {}

struct FoundBooksUpdateAction: Action {
  let items: FoundBooksItemsState
}

struct UpdateSelectedFoundBookAction: Action {
  let selectedFoundBook: SelectedBookState
}

struct CleanSelectedBookAction: Action {}

struct CleanFoundBookListAction: Action {}

struct AddNewBookAction: Action {
  let newBook: SelectedBookState
}

struct UpdateBookAction: Action {
  let index: SelectedBookIndexState
  let updatedBook: SelectedBookState
}

struct SearchParamsUpdate: Action {
  let params: BookFetchParamsState
}

func bookFetch(state: AppState, store: Store<AppState>) {
  let searchParams = state.searchParams

  BookAPI()!
    .fetchBooksBy(isbn: searchParams.isbn,
        andAuthor: searchParams.author,
        andTitle: searchParams.title,
        onSuccess: { (items) in
          DispatchQueue.main.async {
            let action: FoundBooksUpdateAction

            if items.isEmpty {
              let itemsState = FoundBooksItemsState(state: FoundBookListState.noItemFound)
              action = FoundBooksUpdateAction(items: itemsState)
            } else {
              let itemsState = FoundBooksItemsState(state: FoundBookListState.dataAvailable(items: items))
              action = FoundBooksUpdateAction(items: itemsState)
            }

            store.dispatch(action)
          }
    },
        onFailure: { (error) in
          print("Error: \(String(describing: error))")
    })
}
