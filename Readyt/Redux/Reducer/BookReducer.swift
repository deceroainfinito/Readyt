//
//  BookReducer.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 01/09/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

import ReSwift

func selectBookReducer(action: Action, state: SelectedBookState?) -> SelectedBookState {
  var state = state ?? SelectedBookState()

  switch action {
  case let action as UpdateSelectedFoundBookAction:
    state = action.selectedFoundBook
  case is CleanSelectedBookAction:
    state = SelectedBookState(selectedBook: nil)
  default:
    break
  }

  return state
}

func selectBookIndexReducer(action: Action, state: SelectedBookIndexState?) -> SelectedBookIndexState {
  var state = state ?? SelectedBookIndexState()

  switch action {
  case let action as UpdateSelectedBookIndexAction:
    state = action.index
  case is ResetSelectedIndexAction:
    state = SelectedBookIndexState(index: nil)
  default:
    break
  }

  return state
}

func ownBookListReducer(action: Action, state: BookItemsState?) -> BookItemsState {
  var state = state ?? BookItemsState()

  switch action {
  case let action as UpdateBookAction:
    guard let index = action.index.index,
          let updatedBook = action.updatedBook.selectedBook
      else { fatalError("Update action lacks some parameters")}

    var items = state.items
    items[index] = updatedBook
    state = BookItemsState(items: items)
  case let action as AddNewBookAction:
    var newOwnList = state.items
    newOwnList.append(action.newBook.selectedBook)
    state = BookItemsState(items: newOwnList)
  default:
    break
  }

  return state
}

func foundBooksReducer(action: Action, state: FoundBooksItemsState?) -> FoundBooksItemsState {
  var state = state ?? FoundBooksItemsState()

  switch action {
  case let action as FoundBooksUpdateAction:
    state = action.items
  case is CleanFoundBookListAction:
    state = FoundBooksItemsState(state: FoundBookListState.loading)
  default:
    break
  }

  return state
}

func searchReducer(action: Action, state: BookFetchParamsState?) -> BookFetchParamsState {
  var state = state ?? BookFetchParamsState()

  switch action {
  case let action as SearchParamsUpdate:
    state = action.params
  default:
    break
  }

  return state
}
