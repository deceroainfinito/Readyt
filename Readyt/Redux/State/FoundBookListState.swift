//
//  FoundBookListState.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 02/10/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

//swiftlint:disable identifier_name operator_whitespace

import Foundation

enum FoundBookListState {
  case loading
  case dataAvailable(items: [JSONDomain.Book?])
  case noItemFound
}

extension FoundBookListState: Equatable { }
func ==(lhs: FoundBookListState, rhs: FoundBookListState) -> Bool {
  switch (lhs, rhs) {
  case (FoundBookListState.loading, FoundBookListState.loading):
    return true
  case (FoundBookListState.noItemFound, FoundBookListState.noItemFound):
    return true
  case (let FoundBookListState.dataAvailable(leftValue), let FoundBookListState.dataAvailable(rightValue)):
    return leftValue == rightValue
  default:
    return false
  }
}

extension FoundBookListState: Codable {
  enum CodingKeys: String, CodingKey {
    case base, dataAvailableParam
  }

  private enum Base: String, Codable {
    case loading, noItemFound, dataAvailable
  }

  private struct DataAvailableParam: Codable {
    let items: [JSONDomain.Book?]
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let base = try container.decode(Base.self, forKey: .base)

    switch base {
    case .loading:
      self = .loading
    case .noItemFound:
      self = .noItemFound
    case .dataAvailable:
      let dataAvailableParam = try container.decode(DataAvailableParam.self, forKey: .dataAvailableParam)
      self = .dataAvailable(items: dataAvailableParam.items)
    }
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    switch self {
    case .loading:
      try container.encode(Base.loading, forKey: .base)
    case .noItemFound:
      try container.encode(Base.noItemFound, forKey: .base)
    case .dataAvailable(let items):
      try container.encode(Base.dataAvailable, forKey: .base)
      try container.encode(DataAvailableParam(items: items), forKey: .dataAvailableParam)
    }
  }

}
