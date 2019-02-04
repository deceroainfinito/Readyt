//
//  BookAPI.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 03/09/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

//REMOVE_ME_TO_ACTIVATEswiftlint:disable

import Foundation

// Call Example by ISBN
// https://www.googleapis.com/books/v1
//        /volumes?q=isbn:9788426106001&langRestrict=es&key=watheverAPIKey
//let SEARCHURL = "https://www.googleapis.com/books/v1/REQUEST_TYPE?q=SEARCH_PARAMS&key=API_KEY"

let searchURL = "https://www.googleapis.com/books/v1/"

enum URLParams: String {
  case ISBNNumber = "isbn:"
  case lang = "langRestrict:"
  case author = "inauthor:"
  case title = "intitle:"
  case APIKey
}

enum REQUESTType: String {
  case volumes //= "volumes?q="
}

enum BookAPIError: Error {
  case incorrectURL
  case incorrectResponse
  case dataTaskFailed
  case decodingFailure
}

struct BookAPI {
  let APIKey = ""
  let baseURL: URL!
  let url: URL!

  let sessionConfig: URLSessionConfiguration!
  let session: URLSession!

  init?(baseURL: URL? = URL(string: searchURL), URLType: REQUESTType = .volumes) {
    guard let safeBaseURL = baseURL,
          let safeURL = URL(string: URLType.rawValue, relativeTo: safeBaseURL)
      else { return nil }

    self.baseURL = safeBaseURL
    self.url = safeURL

//    #if !targetEnvironment(simulator)
//      sessionConfig = URLSessionConfiguration()
//      sessionConfig.al .allowsCellularAccess = true
//      sessionConfig.multipathServiceType = .handover
//      sessionConfig.waitsForConnectivity = true
//    #else
      sessionConfig = URLSessionConfiguration.default
//    #endif
    session = URLSession(configuration: sessionConfig)

    // Standalone version
//    sessionConfig = URLSessionConfiguration.default
//    session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
  }

  func fetchBooksBy(isbn: String = "",
                    andAuthor author: String = "",
                    andTitle title: String = "",
                    onSuccess success:@escaping([JSONDomain.Book]) -> Void,
                    onFailure failure:@escaping(Error) -> Void) {

    guard let safeURL = buildSearchURLWithISBN(isbn, andAuthor: author, andTitle: title)
      else { return failure(BookAPIError.incorrectURL) }

    let task = session.dataTask(with: safeURL) { (data, response, error) in

      if error != nil {
        failure(BookAPIError.dataTaskFailed)
      } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
        do {
          let bookResponse = try self.parseData(data)
          success(bookResponse.items ?? [])
        } catch let error {
          failure(error)
        }
      } else {
        failure(BookAPIError.incorrectResponse)
      }
    }

    task.resume()
  }

  func parseData(_ data: Data) throws -> JSONDomain.BookResponse {
    let decoder = JSONDecoder()
    var bookResponse: JSONDomain.BookResponse

    do {
      bookResponse = try decoder.decode(JSONDomain.BookResponse.self, from: data)
    } catch {
      throw BookAPIError.decodingFailure
    }

    return bookResponse
  }

  fileprivate func buildSearchURLWithISBN(_ isbn: String,
                                          andAuthor author: String,
                                          andTitle title: String) -> URL? {

    var queryValue = ""

    if !isbn.isEmpty {
      queryValue += URLParams.ISBNNumber.rawValue + isbn
    }

    if !author.isEmpty {
      queryValue += URLParams.author.rawValue + author
    }

    if !title.isEmpty {
      queryValue += URLParams.title.rawValue + title
    }

    if !APIKey.isEmpty {
      queryValue += URLParams.APIKey.rawValue + APIKey
    }

    let queryComponent = URLQueryItem(name: "q", value: queryValue)
    //TODO: Became a user defined param?
    let maxResults     = URLQueryItem(name: "maxResults", value: "40")

    var components = URLComponents(url: url.absoluteURL, resolvingAgainstBaseURL: false)
    components?.queryItems = [queryComponent, maxResults]

    return components?.url
  }

}
