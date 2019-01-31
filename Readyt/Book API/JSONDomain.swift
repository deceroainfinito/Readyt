//
//  JSONDomain.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 04/09/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

import Foundation

struct JSONDomain {

  struct BookResponse: Equatable, Codable {
    let items: [Book]?
  }

  struct Book: Equatable, Codable {
    let id: String
    let selfLink: String
    var volumeInfo: VolumeInfo
  }

  struct VolumeInfo: Equatable, Codable {
    let title: String
    let authors: [String]?
    let publishedDate: String?
    let description: String?
    let industryIdentifiers: [IndustryIdentifier]?
    let pageCount: Int?
    let averageRating: Float?
    let imageLinks: ImageLinks?
  }

  struct IndustryIdentifier: Equatable, Codable {
    let type: String
    let identifier: String
  }

  struct ImageLinks: Equatable, Codable {
    let smallThumbnail: String?
    let thumbnail: String?
  }
}
