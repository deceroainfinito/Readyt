//
//  BookListViewController.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 31/08/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

// swiftlint: disable line_length

import UIKit
import ReSwift
import RxSwift
import RxCocoa

class BookListViewController: UIViewController {

  fileprivate var books: Variable<[Book?]>! = Variable([])

  var presenter: PresenterDelegate!

  var bookPresenter: BookListPresenter {
    guard let presenter = presenter as? BookListPresenter else { fatalError() }
    return presenter
  }

  internal var disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    presenter.setupViews()

    rxMagic()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    store.subscribe(self) { subscription in
      subscription.select { state in
        state.ownBookList
      }
    }

    store.dispatch(CleanFoundBookListAction())
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    store.unsubscribe(self)
  }

  fileprivate func rxMagic() {

    bookPresenter.collectionView.delegate = nil
    bookPresenter.collectionView.rx.setDelegate(self).disposed(by: disposeBag)

    books
      .asObservable()
      .subscribe(onNext: { (items) in
        if items.isEmpty {
          self.bookPresenter.collectionView.backgroundView?.isHidden = false
        }
      }).disposed(by: disposeBag)

    books
      .asObservable()
      .bind(to: bookPresenter.collectionView.rx
        .items(cellIdentifier: "OwnBookCell")) { [unowned self] (_, book, cell) in
          guard let bookCell = (cell as? OwnBookCell) else { fatalError("Wrong casting to OwnBookCell")}

          self.bookPresenter.collectionView.backgroundView?.isHidden = true

          bookCell.book = book
      }.disposed(by: disposeBag)

    bookPresenter.collectionView.rx
      .itemSelected
      .subscribe(onNext: { [weak self] (indexPath) in
        guard let safeSelf = self,
          let selectedBook = safeSelf.books.value[indexPath.row] else { return }

        let selectedBookState = SelectedBookState(selectedBook: selectedBook)
        let selectedBookIndexState = SelectedBookIndexState(index: indexPath.row)

        store.dispatch(UpdateSelectedBookIndexAction(index: selectedBookIndexState))
        store.dispatch(UpdateSelectedFoundBookAction(selectedFoundBook: selectedBookState))
        store.dispatch(RoutingAction(destination: .selectedOwnBook))
      }).disposed(by: disposeBag)

    bookPresenter.addButton.rx.tap.subscribe({ _ in
        store.dispatch(RoutingAction(destination: .bookSearch))
      }).disposed(by: disposeBag)

    bookPresenter.minusButton.rx.tap .subscribe({ _ in
        store.dispatch(RoutingAction(destination: .settings))
      }).disposed(by: disposeBag)
  }
}

extension BookListViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {

    return CGSize(width: OwnBookCell.width, height: OwnBookCell.height)
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {

    return 10
  }
}

extension BookListViewController: StoreSubscriber {
  typealias StoreSubscriberStateType = BookItemsState

  func newState(state: BookItemsState) {
    books.value = state.items
  }
}
