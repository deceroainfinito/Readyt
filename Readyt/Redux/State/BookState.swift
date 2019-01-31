//
//  SelectedBookState.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 01/09/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

import ReSwift

struct SelectedBookIndexState: StateType, Equatable, Codable {
  var index: Int?
}

struct SelectedBookState: StateType, Equatable, Codable {
  var selectedBook: Book?

  init(selectedBook state: Book? = nil) {
    self.selectedBook = state
  }
}

struct BookItemsState: StateType, Equatable, Codable {
  var items: [Book?]

  init(items state: [Book?] = []) {
    self.items = state
  }
}

struct FoundBooksItemsState: StateType, Equatable, Codable {
  var state: FoundBookListState

  init(state: FoundBookListState = .loading) {
    self.state = state
  }
}

struct BookFetchParamsState: StateType, Equatable, Codable {
  var isbn: String
  var author: String
  var title: String

  init(isbn: String = "",
       author: String = "",
       title: String = "") {

    self.isbn = isbn
    self.author = author
    self.title = title
  }
}
