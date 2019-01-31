//
//  AppRouter.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 30/08/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

//swiftlint:disable force_cast

import UIKit
import ReSwift

enum RoutingDestination: String, Codable {
  case bookList
  case settings
  case newBook
  case bookDetail
  case bookSearch
  case foundBookList
  case selectedOwnBook
  case selectedFoundBook
}

final class AppRouter: StoreSubscriber {
  typealias StoreSubscriberStateType = RoutingState

  let navigationController: UINavigationController!

  init(window: UIWindow) {
    navigationController = UINavigationController()

    window.rootViewController = navigationController

    store.subscribe(self) { subscription in
      subscription.select { state in
        state.routingState
      }
    }
  }

  fileprivate func pushViewController(destination: RoutingDestination, animated: Bool) {
    let newViewController: UIViewController
    let presenter: PresenterDelegate
    let bookViewModel: BookViewModel

    switch destination {
    case .bookList:
      newViewController = BookListViewController()
      presenter = BookListPresenter(withViewController: newViewController)
      (newViewController as! BookListViewController).presenter = presenter
    case .settings:
      newViewController = TokenViewController()
      presenter = TokenViewPresenter(withViewController: newViewController)
      (newViewController as! TokenViewController).presenter = presenter
    case .bookDetail:
      //TODO: Create BookDetailViewController
      newViewController = UIViewController()
    case .newBook, .selectedFoundBook, .selectedOwnBook:
      bookViewModel = BookViewModel(book: store.state.selectedBook.selectedBook)
      newViewController = NewBookViewController.instantiate(with: bookViewModel)
      presenter =  NewBookPresenter(withViewController: newViewController)
      (newViewController as! NewBookViewController).presenter = presenter
    case .bookSearch:
      newViewController = SearchViewController()
      presenter = SearchViewPresenter(withViewController: newViewController)
      (newViewController as! SearchViewController).presenter = presenter
    case .foundBookList:
      newViewController = FoundBookListViewController()
      presenter = FoundBookListPresenter(withViewController: newViewController)
      (newViewController as! FoundBookListViewController).presenter = presenter
    }

    //TODO: This may be above. Check newViewController class name with
    //      destination enum rawValue 
    if let currentVc = navigationController.topViewController {
      if type(of: newViewController) == type(of: currentVc) {
        return
      }
    }

    navigationController.pushViewController(newViewController, animated: animated)
  }
}

extension AppRouter {

  func newState(state: RoutingState) {
    let animated = navigationController.topViewController != nil

    pushViewController(destination: state.navigationState, animated: animated)
  }
}
