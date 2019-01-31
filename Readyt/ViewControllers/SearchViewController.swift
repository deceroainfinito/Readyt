//
//  SearchViewController.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 06/09/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

//swiftlint:disable identifier_name

import UIKit
import ReSwift
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {

  var presenter: PresenterDelegate!

  var searchPresenter: SearchViewPresenter {
    guard let presenter = presenter as? SearchViewPresenter else { fatalError() }

    return presenter
  }

  let dismissGesture: UITapGestureRecognizer = {
    let dismissG = UITapGestureRecognizer()
    dismissG.numberOfTapsRequired = 1

    return dismissG
  }()

  let backGesture: UISwipeGestureRecognizer = {
    let backG = UISwipeGestureRecognizer()
    backG.direction = .right

    return backG
  }()

  internal var disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    [backGesture, dismissGesture].forEach { view.addGestureRecognizer($0) }

    searchPresenter.newBackButton = UIBarButtonItem(title: "Back",
                                                    style: UIBarButtonItem.Style.plain,
                                                    target: self,
                                                    action: #selector(goBack))
    navigationItem.leftBarButtonItem = searchPresenter.newBackButton

    presenter.setupViews()

    rxMagic()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    store.subscribe(self) { subscription in
      subscription.select { state in
        state.searchParams
      }
    }

    store.dispatch(CleanFoundBookListAction())
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    updateParamsState()
    store.unsubscribe(self)
  }

  fileprivate func rxMagic() {

    checkSearchIsPossible()

    backGesture.rx.event.subscribe { (_) in
      self.goBack()
      }.disposed(by: disposeBag)

    dismissGesture.rx.event.subscribe { (_) in
      self.view.endEditing(true)
      }.disposed(by: disposeBag)

    searchPresenter.searchButton.rx.tap.subscribe { (_) in
      self.updateParamsState()
      self.goToFoundBookList()
      }.disposed(by: disposeBag)
  }

  fileprivate func checkSearchIsPossible() {
    let areEmpty =
      [searchPresenter.authorField,
       searchPresenter.isbnField,
       searchPresenter.titleField].map { field in

        field.rx.text.map({ _ in return field.text?.isEmpty })
    }

    _ = Observable.combineLatest(areEmpty) { iterator in
      return iterator.reduce(false, { x, y in
        return x || !y! })
      }.bind(to: self.searchPresenter.searchButton.rx.isEnabled)
  }

  @objc fileprivate func goBack() {
    navigationController?.popViewController(animated: true)
    store.dispatch(RoutingAction(destination: .bookList))
  }

  fileprivate func updateParamsState() {
    let params = buildParamsState()

    store.dispatch(SearchParamsUpdate(params: params))
  }

  func goToFoundBookList() {
    bookFetch(state: store.state, store: store)
    store.dispatch(RoutingAction(destination: .foundBookList))
  }

  fileprivate func buildParamsState() -> BookFetchParamsState {
    let isbn = searchPresenter.isbnField.text ?? ""
    let author = searchPresenter.authorField.text ?? ""
    let title = searchPresenter.titleField.text ?? ""

    return BookFetchParamsState(isbn: isbn, author: author, title: title)
  }
}

extension SearchViewController: StoreSubscriber {
  typealias StoreSubscriberStateType = BookFetchParamsState

  func newState(state: BookFetchParamsState) {
  }
}
