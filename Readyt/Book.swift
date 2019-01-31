//
//  Book.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 10/09/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

import Foundation
import RxSwift

struct Book: Equatable, Codable {
  var title: String?
  var author: String?

  var rating: Int?

  var description: String?

  var startReadingDate: Date?
  var endReadingDate: Date?

  var apiInfo: JSONDomain.Book?

  init(title: String?,
       author: String?,
       rating: Int?,
       startReadingDate: Date?,
       finishReadingDate: Date?,
       description: String?,
       apiInfo: JSONDomain.Book?) {

    self.title = title
    self.author = author
    self.rating = rating
    self.startReadingDate = startReadingDate
    self.endReadingDate = finishReadingDate
    self.description = description
    self.apiInfo = apiInfo
  }

  init(withApiInfo info: JSONDomain.Book) {
    self.title = info.volumeInfo.title
    self.author = info.volumeInfo.authors?.first
    self.description = info.volumeInfo.description
    self.rating = 0
    self.startReadingDate = nil
    self.endReadingDate = nil
    self.apiInfo = info
  }
}

class BookViewModel {
  var book: Book?

  var title: Variable<String?> = Variable(nil)
  var author: Variable<String?> = Variable(nil)
  var rating: Variable<Int?> = Variable(0)
  var startReadingDate: Variable<String?> = Variable(nil)
  var endReadingDate: Variable<String?> = Variable(nil)
  var description: Variable<String?> = Variable(nil)

  init(book: Book?) {
    self.book = book
  }

  func assignFirstValues() {
    let dateFormatter = DateFormatter(withFormat: "dd/MM/yyyy")

    title.value = book?.title
    author.value = book?.author
    rating.value = book?.rating
    description.value = book?.apiInfo?.volumeInfo.description

    if let safeStartReadingDate = book?.startReadingDate {
      startReadingDate.value = dateFormatter.string(from: safeStartReadingDate)
    }

    if let safeEndReadingDate = book?.endReadingDate {
      endReadingDate.value = dateFormatter.string(from: safeEndReadingDate)
    }
  }

  func getBook() -> Book {
    let dateFormatter = DateFormatter(withFormat: "dd/MM/yyyy")

    var safeStartReadingDate: Date?
    var safeEndReadingDate: Date?

    if let startRD = startReadingDate.value {
      safeStartReadingDate = dateFormatter.date(from: startRD)
    }

    if let endRD = endReadingDate.value {
      safeEndReadingDate = dateFormatter.date(from: endRD)
    }

    return Book(title: title.value,
                author: author.value,
                rating: rating.value,
                startReadingDate: safeStartReadingDate,
                finishReadingDate: safeEndReadingDate,
                description: description.value,
                apiInfo: book?.apiInfo)
  }
}
